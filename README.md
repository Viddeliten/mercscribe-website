# MercScribe download site

`public_html/` is the download page for MercScribe. Only that folder is on the web; this
file and `.git` stay outside it.

`build-installer.ps1` in the MercScribe folder puts each new installer here, writes
`public_html/version.json` and commits it. Push it, then on the server:

    cd /home/storybook/domains/mercscribe && git pull

The page shows at mercurious.love/mercscribe through a link made once:

    ln -s /home/storybook/domains/mercscribe/public_html /home/storybook/domains/mercurious.love/public_html/mercscribe

The page's colours are variables at the top of `public_html/index.html`.
