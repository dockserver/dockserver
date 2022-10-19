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
</br>
The value per upload, not for the entire upload.
</br>
Please refer to the Rclone documentation before changes are made-> https://rclone.org/docs/#bwlimit-bandwidth-spec

`LOG_LEVEL=${LOG_LEVEL:-INFO}`
</br>
Please refer to the Rclone documentation before changes are made -> https://rclone.org/docs/#log-level-level

`FOLDER_DEPTH=${FOLDER_DEPTH:-1}`
</br>
If you use Multi-Drive Uploader then this is necessary to define how deep you have to look into the folders (the depth has to be the same on every Trive) and for the correct display in the Uploader-UI, SQL and Notifications. 
</br> 
Example: if it is set to 1, then the "movies" folder on the Tdrive has to be in the root e.g. `/movies`.</br>
         if it is set to 2, then the "movies" folder on the Tdrive has to be below the root folder e.g. `/media/movies`.
</br>
**IMPORTANT**: This setting schould only be used if you know what you are doing. By changing the value no exception is possible.

`TRANSFERS=${TRANSFERS:-2}`
</br>
The number of concurrent uploads

#### USER - SETTINGS
`DRIVEUSEDSPACE=${DRIVEUSEDSPACE:-null}`
</br>
Example: if you write "80" in here, the uploader will wait until the disk used space is over 80%, only then will the upload begin.

`MIN_AGE_UPLOAD=${MIN_AGE_UPLOAD:-1}`
</br>
How old in minutes the file should be before the upload takes place, e.g. `10` for 10 minutes.

`LOG_ENTRY=${LOG_ENTRY:-1000}`
</br>
How many log entries should be saved.

`LOG_RETENTION_DAYS=${LOG_RETENTION_DAYS:-null}`
</br>
How many days of log entries should be kept. If `LOG_RETENTION_DAYS` is defined, then `LOG_ENTRY` is ignored.

#### AUTOSCAN - SETTINGS
`AUTOSCAN_URL=${AUTOSCAN_URL:-null}`
</br>
Example Remote: `https://autoscan.domain.com`
</br>
Example Local: `http://autoscan:3030`

`AUTOSCAN_USER=${AUTOSCAN_USER:-null}`
</br>
`AUTOSCAN_PASS=${AUTOSCAN_PASS:-null}`

#### NOTIFICATION - SETTINGS
Apprise is integrated in the uploader, a markdown has already been integrated in the uploader.
</br>
Please refer to the Apprise documentation for mor information -> https://github.com/caronc/apprise/wiki

![Image of Notification](/img/notifications/discord-uploader.png)

`NOTIFICATION_URL=${NOTIFICATION_URL:-null}`
</br>
Discord Example: `discord://{WebhookID}/{WebhookToken}`

`NOTIFICATION_LEVEL=${NOTIFICATION_LEVEL:-ALL}`
</br>
Options:
</br>
`ALL` - logging everything
</br>
`ERROR` - logging only errors
</br>
`NONE` - logging nothing

`NOTIFICATION_SERVERNAME=${NOTIFICATION_SERVERNAME:-null}`
</br>
Default Servername: `Uploader - Docker`
</br>
Changing this setting, only "Docker" will be replaced, "Uploader" is fixed.

#### LANGUAGE MESSAGES
`LANGUAGE=${LANGUAGE:-en}`
</br>
Only `en` or `de`


### MULTI DRIVE UPLOAD

If you would like to upload to different Tdrives instead of using one single Tdrive you can use the MULTI DRIVE UPLOADER.
</br>
To make use of this feature you need to create a file named `uploader.csv` in `/opt/appdata/system/servicekeys/`.
</br>
You can find a sample file in `opt/appdata/system/uploader/sample`.
</br>
</br>
Example:
```yaml
TVShows|0XXXXXXXXX000000EERR
TV4K|0XXXXXXXXX000000ZZTT
Movies|0XXXXXXXXX000000JJJKK
4K|0XXXXXXXXX000000BBAA
```
Foreach Tdrive add a line in the `uploader.csv` file (look at example file).
</br>
**IMPORTANT**: All Keys must be know on all Tdrives!


### OTHER UPLOADER FEATURES

Instead of using the `rclonegdsa.conf` located in `/opt/appdata/system/servicekeys/`, you can now use a `drive.csv` where you can put the default Tdrive to upload in.
</br>
To make use of this feature you need to create a file named `drive.csv` in `/opt/appdata/system/uploader/`.
</br>
</br>
Example:
```yaml
uploader|0XXXXXXXXX000000EERR
```

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
