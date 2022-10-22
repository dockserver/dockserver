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
Automated uploader for Google Team Drive.</br>

### Features:
- Completely automated.
- Clean web interface.
- Support for encrypted Team Drives.
- Support for multiple Team Drives.
- Bypass daily upload limit of 750GB via Service Accounts.
- Support for [Autoscan](https://github.com/Cloudbox/autoscan).
- Full support for [Rclone's bandwidth limit](https://rclone.org/docs/#bwlimit-bandwidth-spec).
- Notifications via [Apprise](https://github.com/caronc/apprise).
- Variable concurrent uploads.
- Settings are refreshed for each upload. No need to restart the container after making a configuration change!
- Start and stop on demand via the container or web interface.

### Limitations:
- No support for Google Drive.
- If using multiple Team Drives for Uploader, `FOLDER_DEPTH` must be identical across all drives.
- Bandwidth limit is *per* upload IE - If you have `TRANSFERS=2` and `BANDWIDTH_LIMIT=20M`, the maximum total upload speed would be 40MiB.
- Bandwidth cannot be changed for any active uploads.
- Support for only English or German.

## Configuration
All settings can be found here: `/opt/appdata/system/uploader/uploader.env`

#### USER VALUES
|Setting   |Default|Description|
|----------|-------|-----------|
|`PUID`    |`1000` |PGUID to be used by Uploader.|
|`PGID`    |`1000` |PGID to be used by Uploader.|
|`TIMEZONE`|`UTC`  |Timezone to be used by Uploader.|

#### ENCRYPTION SETUP
|Setting       |Default |Description|
|--------------|--------|-----------|
|`HASHPASSWORD`|`hashed`|If using an encrypted Team Drive, this must be set.|

#### RCLONE - SETTINGS
|Setting          |Default         |Description|
|-----------------|----------------|-----------|
|`BANDWIDTH_LIMIT`|`null`          |The maximum upload speed *per upload*. Please refer to the [Rclone documentation](https://rclone.org/docs/#bwlimit-bandwidth-spec) before changes are made.|
|`LOG_LEVEL`      |`INFO`          |Please refer to the [Rclone documentation](https://rclone.org/docs#log-level-level) before changes are made.|
|`DLFOLDER`       |`/mnt/downloads`|Path to your download directory.|
|`FOLDER_DEPTH`   |`1`             |How many folders deep your library folder is from the root of your Team Drive. If set incorrectly, the Uploader web interface, database, and notifications will all display the incorrect folder. Examples:</br>`FOLDER_DEPTH=1` the library folder is in the root of your Team Drive. IE - `/movies`.</br>`FOLDER_DEPTH=2` the library folder is below the root folder. IE - `/media/movies`.</br></br>**IMPORTANT**: This setting should only be used if you know what you are doing. By changing the value, you accept all risks that come with it.|
|`TRANSFERS`      |`2`             |The maximum number of concurrent uploads.|

#### USER - SETTINGS
|Setting             |Default|Description|
|--------------------|-------|-----------|
|`DRIVEUSEDSPACE`    |`null` |Amount of local storage, in percent, to use before uploading any files. Example:</br></br>`DRIVEUSEDSPACE=80` will wait until the drive space used reaches 80% before uploading files.|
|`MIN_AGE_UPLOAD`    |`1`    |How old a file should be, in minutes, before it is uploaded. Example:</br>`MIN_AGE_UPLOAD=10` will wait until a file is 10 minutes old before it is uploaded.|
|`LOG_ENTRY`         |`1000` |How many log entries should be retained in the local database.|
|`LOG_RETENTION_DAYS`|`null` |How many days of log entries should be kept. If `LOG_RETENTION_DAYS` is defined, then `LOG_ENTRY` is ignored.|

#### VFS - SETTINGS
|Setting             |Default     |Description|
|--------------------|------------|-----------|
|`VFS_REFRESH_ENABLE`|`true`      |Whether or not the VFS cache should be refreshed. Options:</br>`true`</br>`false`|
|`MOUNT`             |`mount:8554`|The local address of your mount instance.|

#### AUTOSCAN - SETTINGS
|Setting        |Default|Description|
|---------------|-------|-----------|
|`AUTOSCAN_URL` |`null` |Remote or local path to Autoscan. Examples:</br>Remote: `AUTOSCAN_URL=https://autoscan.domain.com`</br>Local: `AUTOSCAN_URL=http://autoscan:3030`|
|`AUTOSCAN_USER`|`null` |Autoscan username.|
|`AUTOSCAN_PASS`|`null` |Autoscan password.|

#### NOTIFICATION - SETTINGS
[Apprise](https://github.com/caronc/apprise) has been integrated into Uploader and is defaulted to format all notifications in [Markdown](https://www.markdownguide.org/). Please refer to the [Apprise documentation](https://github.com/caronc/apprise/wiki) for more information.

![Image of Notification](/img/notifications/discord-uploader.png)
|Setting                  |Default|Description|
|-------------------------|-------|------------|
|`NOTIFICATION_URL`       |`null` |The notification URL to be passed to Apprise. Discord examples:</br>`https://discordapp.com/api/webhooks/{WebhookID}/{WebhookToken}`</br>`discord://{WebhookID}/{WebhookToken}/`</br>`discord://{user}@{WebhookID}/{WebhookToken}/`|
|`NOTIFICATION_LEVEL`     |`ALL`  |What notifications should be sent to `NOTIFICATION_URL`. Options:</br>`ALL` - Send notification for all uploads</br>`ERROR` - Send notification for only errors</br>`NONE` - Do not send any notifications|
|`NOTIFICATION_SERVERNAME`|`null` |What to display on the notification, after "Uploader - ". `null` will default to "Uploader - Docker". Anything else will only replace "Docker".</br>Examples:</br>`NOTIFICATION_SERVERNAME=null` results in "Uploader - Docker"</br>`NOTIFICATION_SERVERNAME=My Awesome Server` will result in "Uploader - My Awesome Server"|

#### LANGUAGE MESSAGES
|Setting   |Default|Description|
|----------|-------|-----------|
|`LANGUAGE`|`en`   |Language to use. Options:</br>`en` - English</br>`ge` - German|

### Multi-Drive Uploader
If you would like to upload to multiple Team Drives, you need to create a file named `uploader.csv` in `/opt/appdata/system/servicekeys/`. You can find a sample file in `opt/appdata/system/uploader/sample`. For each Team Drive, add a line in the `uploader.csv` file.
</br>
</br>
Example:
```yaml
TVShows|0XXXXXXXXX000000EERR
TV4K|0XXXXXXXXX000000ZZTT
Movies|0XXXXXXXXX000000JJJKK
4K|0XXXXXXXXX000000BBAA
```

**IMPORTANT**: All Keys must be known on all Team Drives!

### Other Uploader Features
Instead of using `/opt/appdata/system/servicekeys/rclonegdsa.conf`, you can now use a `drive.csv` where you can put the default Team Drive to upload in. To make use of this feature, you need to create a file named `drive.csv` in `/opt/appdata/system/uploader/`.
</br>
</br>
Example:
```yaml
uploader|0XXXXXXXXX000000EERR
```

## Support
Kindly report any issues on [GitHub](https://github.com/dockserver/dockserver/issues) or [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)