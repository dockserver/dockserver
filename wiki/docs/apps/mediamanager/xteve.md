<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

## xTeve is a M3U Proxy for Plex DVR and Emby Live TV

**_use ( http://xteve:34400 ) for in-app communication_**

#### **Install Notes:**

Access interface will be published on https://xteve.domain.com/web - Accessing xteve.domain.com will throw an XML error

#### Settings to edit in xTeve:

-Playlist (add yours)
-EPG source (unless you use the one in Plex)
-Settings -> Buffer -> Xteve -> Buffer size 8MB

When setting it up in plex:
-Add **xteve:34400** as tuner
-If you want to use the EPG from XTEVE (XEPG) the link you set in Plex **must** be
http://xteve:34400/xmltv/xteve.xml

Protip: Manage,modulate and shorten your m3u link on www.m3u4u.com - They also have an excellent EPG & Playlist editor

####

##Best Practice for Plex/Xteve:

The output from your provider **MUST** be MPEG-TS(.ts) - make sure that this is set both at your provider and at m3u4u.com. Otherwise plex will drop the streams when the framerates drop in the streams.

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
