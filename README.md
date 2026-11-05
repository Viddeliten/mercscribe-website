# MercScribe download site

`public_html/` is the download page for MercScribe. Only that folder is on the web; this
file and `.git` stay outside it.

`build-installer.ps1` in the MercScribe folder puts each new installer here and writes
`public_html/version.json`. Look it over, commit and push it, then on the server:

    cd /home/storybook/domains/mercscribe && git pull

The page shows at mercurious.love/mercscribe through a link made once:

    ln -s /home/storybook/domains/mercscribe/public_html /home/storybook/domains/mercurious.love/public_html/mercscribe

Installers are in `public_html/downloads/`. The newest is the one the page offers, and the
others are listed under *Older versions*. To keep one but take it off the web:

    powershell -ExecutionPolicy Bypass -File versions.ps1 -Hide 1.9.20

That moves it to `hidden/` (outside `public_html`, so it can't be downloaded) and updates the
list; `-Show 1.9.20` puts it back. Neither commits: commit, push and pull as above.

The page's colours are variables at the top of `public_html/index.html`.
