<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# Tauticord

A Discord bot that displays live data from Tautulli

# Features

Tauticord uses the Tautulli API to pull information from Tautulli and display them in a Discord channel, including:

### OVERVIEW:

- Number of current streams
- Number of transcoding streams
- Total bandwidth
- Total LAN bandwidth

### FOR EACH STREAM:

- Stream state (playing, paused, stopped, loading)
- Media type (tv show/movie/song/photo)
- User
- Media title
- Product and player
- Quality profile
- Stream bandwidth
- If stream is transcoding
- Progress of stream
- ETA of stream completion

Administrator (the bot owner) can react to Tauticord's messages to terminate a specific stream (if they have Plex Pass).

Users can also indicate what libraries they would like monitored. Tauticord will create/update a voice channel for each library name with item counts every hour.

# Requirements

- A Plex Media Server
- Tautulli
- A Discord server

---

# Installation and Setup

## Setup a Discord Bot

HOW TO MAKE A DISCORD BOT: https://www.digitaltrends.com/gaming/how-to-make-a-discord-bot/

Permissions required:

- Manage Channels
- View Channels
- Send Messages
- Manage Messages
- Read Message History
- Add Reactions

## Setup Tauticord

- Install Tauticord from Docksever Addons Menu.

- Stop the container.

`sudo docker stop tauticord`

- Head over to the appdata folder.

`cd /opt/appdata/tauticord/`

- Create a config file.

`sudo nano config.yaml`

- Copy / Paste the following config into the created file from previous step.

```sh
appName: Tauticord
logLevel: WARN

Tautulli:
  Connection:
    URL: "http://tautulli:8181" # change this if tautulli is not installed from Dockserver.
    APIKey: ""
  Customization:
    TerminateMessage: "Your stream has been terminated. Please contact the admin in the Discord."
    # how often (seconds) the bot pulls new data. I'd recommend not making the bot ping Tautulli more often than every 5 seconds.
    RefreshSeconds: 15
    # can only kill streams if you have a plex pass, so this controls whether you're given the option
    PlexPass: true
    ServerTimeZone: "UTC"
    Use24HourTime: false
  LibraryNames:
    # list of names of the libraries you'd like stats about
    # Voice channels will be made/updated with stats (refreshed every hour)
    - Movies
    - TV Shows
    - Music

Discord:
  Connection:
    BotToken: ""
    # Right-click on your server's icon -> "Copy ID"
    ServerID: 00000000000000000
    # Right-click on your profile picture -> "Copy ID"
    OwnerID: 00000000000
    # Where the live stats will be posted
    ChannelName: "tautulli"
  Customization:
    # if True, use embeds to print information, use regular text message if False
    UseEmbeds: true

Extras:
  # See README.md for details
  Analytics: true
```

- Edit the config file to your needs.

- Start the container.

`sudo docker start tauticord`

Et voilà, your Bot should now be online in your Disord Server.

---

## Wiki Maintainer

[@cyb3rgh05t](https://github.com/cyb3rgh05t)

---

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
