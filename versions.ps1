# The download page's list of older versions.
# Usage (from this folder):  powershell -ExecutionPolicy Bypass -File versions.ps1 [-Hide <version>] [-Show <version>] [-NoCommit]
#   (nothing)        update the list in public_html\version.json from the installers in public_html\downloads
#   -Hide 1.9.20     move that installer to hidden\ (kept, but not on the web) and take it off the list
#   -Show 1.9.20     put a hidden one back
#   -NoCommit        don't commit (build-installer.ps1 commits itself)
param([string]$Hide, [string]$Show, [switch]$NoCommit)
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)
$downloads = "public_html\downloads"
New-Item -ItemType Directory -Force $downloads, "hidden" | Out-Null
$infoFile = "public_html\version.json"
$info = [IO.File]::ReadAllText("$PSScriptRoot\$infoFile", $utf8) | ConvertFrom-Json
$setupName = { param($v) "MercScribe-Setup-$v.exe" }

if ($Hide) {
    if ($Hide -eq $info.version) { throw "$Hide is the version the page offers. Build a newer one first, or it would have nothing to download." }
    $file = Join-Path $downloads (& $setupName $Hide)
    if (-not (Test-Path $file)) { throw "There's no $file." }
    Move-Item $file "hidden\"
}
if ($Show) {
    $file = Join-Path "hidden" (& $setupName $Show)
    if (-not (Test-Path $file)) { throw "There's no $file." }
    Move-Item $file "$downloads\"
}

# Every installer in downloads\ except the one the page offers, newest first.
$older = @(Get-ChildItem $downloads -Filter "MercScribe-Setup-*.exe" | ForEach-Object {
    $v = $_.BaseName -replace '^MercScribe-Setup-', ''
    if ($v -ne $info.version) {
        [pscustomobject][ordered]@{ version = $v; file = "downloads/$($_.Name)"; sizeMB = [math]::Round($_.Length / 1MB); date = $_.LastWriteTime.ToString('yyyy-MM-dd') }
    }
} | Sort-Object { [version]$_.version } -Descending)
$info | Add-Member -NotePropertyName older -NotePropertyValue $older -Force
[IO.File]::WriteAllText("$PSScriptRoot\$infoFile", ($info | ConvertTo-Json -Depth 4), $utf8)
Write-Host "Older versions on the page: $(if ($older) { ($older.version) -join ', ' } else { 'none' })."
$hidden = @(Get-ChildItem "hidden" -Filter "MercScribe-Setup-*.exe" | ForEach-Object { $_.BaseName -replace '^MercScribe-Setup-', '' })
if ($hidden) { Write-Host "Hidden: $($hidden -join ', ')." }

if (-not $NoCommit) {
    git add -A
    git diff --cached --quiet
    if ($LASTEXITCODE) {
        git commit -q -m $(if ($Hide) { "Hide $Hide" } elseif ($Show) { "Show $Show" } else { "Update the list of versions" })
        Write-Host "Committed. Push it, then git pull on the server."
    }
}
