<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# Tdarr V2: Distributed Transcoding System

Audio/Video Library Analytics & Transcode/Remux Automation

<p align="center">
  <img src="https://storage.googleapis.com/tdarr/media/images/banner-systems.png"/>
</p>

- FFmpeg/HandBrake + video health checking (Windows, macOS, Linux & Docker)

[![Reddit](https://img.shields.io/badge/Reddit-Tdarr-orange)](https://www.reddit.com/r/Tdarr/)[![Discord](https://img.shields.io/badge/Discord-Chat-green.svg)](https://discord.gg/GF8X8cq) [![paypal](https://img.shields.io/badge/-donate-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=L5MWTNDLLB6AC&source=url)

[![patreon](https://img.shields.io/badge/patreon-support-brightgreen.svg)](https://www.patreon.com/Tdarr)

<h2>About:</h2>

Tdarr V2 is a closed-source distributed transcoding system for automating media library transcode/remux management and making sure your files are exactly how you need them to be in terms of codecs/streams/containers and so on. Put your spare hardware to use with Tdarr Nodes for Windows, Linux (including Linux arm) and macOS. Code in this repository is for Tdarr V1, Tdarr V2 is not open-source.

Designed to work alongside applications like Sonarr/Radarr and built with the aim of modularisation, parallelisation and scalability, each library you add has its own transcode settings, filters and schedule. Workers can be fired up and closed down as necessary, and are split into 4 types - Transcode CPU/GPU and Health Check CPU/GPU. Worker limits can be managed by the scheduler as well as manually. For a desktop application with similar functionality please see [HBBatchBeast](https://github.com/HaveAGitGat/HBBatchBeast).

- Cross-platform Tdarr Nodes which work together with Tdarr Server to process your files
- GPU and CPU workers
- Use/create Tdarr Plugins for infinite control on how your files are processed:
  https://github.com/HaveAGitGat/Tdarr_Plugins
- Audio and video library management
- 7 day, 24 hour scheduler
- Folder watcher
- Worker stall detector
- Load balancing between libraries/drives
- Use HandBrake or FFmpeg
- Tested on a 1,000,000 file dummy library
- Search for files based on hundreds of properties
- Library stats
- Hardware transcoding container (install Nvidia plugin on unRAID/Nvidia runtime container on Ubuntu)

<p align="center">
<img src="https://i.imgur.com/wRV6tBJ.png" height="300" />
</p>

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
