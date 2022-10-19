![Image of DockServer](/img/container_images/docker-uploader.png)

<p align="left">
    <a href="https://discord.gg/FYSvu83caM">
        <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
    </a>
        <a href="https://github.com/dockserver/dockserver/releases">
        <img src="https://img.shields.io/github/downloads/dockserver/dockserver/total?label=Total%20Downloads&logo=github" alt="Total Releases Downloaded from GitHub">
    </a>
    <a href="https://github.com/dockserver/dockserver/releases/latest">
        <img src="https://img.shields.io/github/v/release/dockserver/dockserver?include_prereleases&label=Latest%20Release&logo=github" alt="Latest Official Release on GitHub">
    </a>
    <a href="https://github.com/dockserver/dockserver/blob/master/LICENSE">
        <img src="https://img.shields.io/github/license/dockserver/dockserver?label=License&logo=gnu" alt="GNU General Public License">
    </a>
</p>

# Uploader

#### Slick uploader for TDrive or TCrypt based of Google Service Accounts

Can be started/stopped as docker at your convenience - Or keep it running all the time...

## Uploader Setup
### Uploader.env `/opt/appdata/system/uploader/uploader.env`

#### RCLONE - Settings
`BANDWITHLIMIT=${BANDWITHLIMIT:-null}`
The value per upload, not for the entire upload.
Please refer to the Rclone documentation before changes are made-> https://rclone.org/docs/#bwlimit-bandwidth-spec

`LOG_LEVEL=${LOG_LEVEL:-INFO}` 
Please refer to the Rclone documentation before changes are made -> https://rclone.org/docs/#log-level-level

`FOLDER_DEPTH=${FOLDER_DEPTH:-1}`
If you use Multi-Drive Uploader then this is necessary to define how deep you have to look into the folders (the depth has to be the same on every Trive) and for the correct display in the Uploader-UI, SQL and Notifications. 
Example: if it is set to 1, then the "movies" folder on the Tdrive has to be in the root e.g. `/movies`.
         if it is set to 2, then the "movies" folder on the Tdrive has to be below the root folder e.g. `/media/movies`.

`TRANSFERS=${TRANSFERS:-2}`
The number of concurrent uploads

#### USER - SETTINGS
`DRIVEUSEDSPACE=${DRIVEUSEDSPACE:-null}`
Example: if you write "80" in here, the uploader will wait until the disk used space is over 80%, only then will the upload begin.

`MIN_AGE_UPLOAD=${MIN_AGE_UPLOAD:-1}`
How many `minutes` old the file should be before the upload takes place, e.g. `10m`.

`LOG_ENTRY=${LOG_ENTRY:-1000}`
How many log entries should be saved

`LOG_RETENTION_DAYS=${LOG_RETENTION_DAYS:-null}`
How many days of log entries should be kept. If `LOG_RETENTION_DAYS` is defined, then `LOG_ENTRY` is ignored.

#### AUTOSCAN - SETTINGS
`AUTOSCAN_URL=${AUTOSCAN_URL:-null}`
Example Remote https://autoscan.domain.com 
Example Local http://autoscan:3030

`AUTOSCAN_USER=${AUTOSCAN_USER:-null}`
`AUTOSCAN_PASS=${AUTOSCAN_PASS:-null}`

#### NOTIFICATION - SETTINGS
Apprise is integrated in the uploader, a markdown has already been integrated in the uploader. 
Please refer to the Apprise documentation for mor information -> https://github.com/caronc/apprise/wiki

![Image of Notification](/img/notifications/discord-uploader.png)

`NOTIFICATION_URL=${NOTIFICATION_URL:-null}`
Discord Example: discord://{WebhookID}/{WebhookToken}

`NOTIFICATION_LEVEL=${NOTIFICATION_LEVEL:-ALL}`
`ALL` - logging everything
`ERROR` - logging only errors
`NONE` - logging nothing

`NOTIFICATION_SERVERNAME=${NOTIFICATION_SERVERNAME:-null}`
Default Servername: Uploader

#### LANGUAGE MESSAGES
`LANGUAGE=${LANGUAGE:-en}`
only `EN` and `DE`


## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
