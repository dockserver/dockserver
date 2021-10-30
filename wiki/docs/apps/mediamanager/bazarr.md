<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# Bazarr

A good client for finding subtitles for your stuff.

This needs to be configured from bottom up, and an anti-captcha account is recommended but not mandatory

In order to get autoscan on picking up subs you can use this under "Custom post processing"

`curl -sG -X POST -u username:password --data-urlencode "dir={{directory}}" http://autoscan:3030/triggers/manual`

Here is a [heatmap](https://wiki.bazarr.media/bazarr-stats/ "heatmap") that the devs on bazarr made. Great inspiration if you're looking into which indexers to choose

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
