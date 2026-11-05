# MercScribe download site

`public_html/` is the download page for MercScribe. Only that folder is on the web; this
file and `.git` stay outside it.

`build-installer.ps1` in the MercScribe folder puts each new installer here and writes
`public_html/version.json`. Look it over, commit and push it, then on the server:

    cd /home/storybook/domains/mercscribe && git pull

The page shows at mercurious.love/mercscribe through a link made once:

    ln -s /home/storybook/domains/mercscribe/public_html /home/storybook/domains/mercurious.love/public_html/mercscribe

Installers are in `public_html/downloads/`. The newest is the one the page offers, and the
others are listed under *Older versions*, each with *What was new*, taken from its section of
MercScribe's CHANGELOG.md (the bold start of each change). The news is in
`public_html/version.json` and can be edited there; running the script again keeps it.
To keep one but take it off the web:

    powershell -ExecutionPolicy Bypass -File versions.ps1 -Hide 1.9.20

That moves it to `hidden/` (outside `public_html`, so it can't be downloaded) and updates the
list; `-Show 1.9.20` puts it back. Neither commits: commit, push and pull as above.

The page's colours are variables at the top of `public_html/index.html`.

## When browsers block the download

Chrome says "Suspicious download blocked" (and Windows SmartScreen warns) because the
installer isn't signed and few people have downloaded it yet. Each new version starts over,
because without a signature the trust belongs to the file. The page tells people how to keep
it anyway.

- **Code signing is the real fix:** with a code-signing certificate, the trust builds up on the
  certificate and carries over to every new version. For an individual in the EU, Certum's
  code-signing certificate (with a cloud key, no USB stick needed) costs roughly €100 a year.
  Microsoft's Trusted Signing is cheaper, but check whether it takes individuals in your
  country. Check prices before buying. The signing would then go into `build-installer.ps1`.
- **Microsoft:** send each new installer to https://www.microsoft.com/en-us/wdsi/filesubmission
  as a *Software developer*, saying it's a false SmartScreen warning. An answer can take days
  to weeks.
- **Google** has no clear form for downloads. Add the site to Google Search Console
  (https://search.google.com/search-console). *Security & Manual Actions → Security issues*
  shows it if the site itself is flagged, and lets you ask for a review.
  https://safebrowsing.google.com/safebrowsing/report_error/ reports a site that's wrongly
  flagged. Otherwise the warning goes away as more people download the file.
