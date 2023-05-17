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

### IMPORTANT
Each Uploader instance needs his own Project/Keys, never use keys from other projects.

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
- Start and stop on demand via the container or web interface (active uploads are not considered when pausing via the web interface).

    ![pauseupload](/img/uploader/pauseupload.gif)
    
- Change time formatting.

    ![changetime](/img/uploader/changetime.gif)
    

### Limitations:
- No support for Google Drive.
- If using multiple Team Drives for Uploader, `FOLDER_DEPTH` must be identical across all drives.
- Bandwidth limit is *per* upload IE - If you have `TRANSFERS=2` and `BANDWIDTH_LIMIT=20M`, the maximum total upload speed would be 40MiB.
- Bandwidth cannot be changed for any active uploads.

### Exclude files from being uploaded
rclone.exclude is located here: `/opt/appdata/system/uploader/rclone.exclude`

Example:

- if you don´t want that **srt** files are being uploaded, you have to add `.*\.srt$` to the file.
- You can exclude folders to, examples are in the file, because we already exclude certain folders.

## Configuration
All settings can be found here: `/opt/appdata/system/uploader/uploader.env`

#### USER VALUES
|Setting   |Default|Description|
|----------|-------|-----------|
|`PUID`    |`1000` |PGUID to be used by Uploader.|
|`PGID`    |`1000` |PGID to be used by Uploader.|
|`TIMEZONE`|`UTC`  |Timezone to be used by Uploader.|

#### CRITICAL SETUP FOR CRYPT USER
|Setting       |Default |Description|
|--------------|--------|-----------|
|`HASHPASSWORD`|`hashed`|If using `drive.csv` or `uploader.csv` and encrypted Team Drive, this must be set.</br>Options:</br>`hashed`</br>`plain`|

You have 2 options for this value `HASHPASSWORD`.

1. `hashed` this tells uploader that you have the encrypted password in your `drive.csv` or `uploader.csv`.

2. `plain` this tells uploader that you have the plain password in your `drive.csv` or `uploader.csv`.

You can leave the value as it is if you dont use Multi Drive uploading.

#### RCLONE - SETTINGS
|Setting          |Default         |Description|
|-----------------|----------------|-----------|
|`BANDWIDTH_LIMIT`|`null`          |The maximum upload speed *per upload*. Please refer to the [Rclone documentation](https://rclone.org/docs/#bwlimit-bandwidth-spec) before changes are made.|
|`GOOGLE_IP`      |`142.250.74.78` |Set hardcoded IP for `www.googleapis.com` this does prevent Error 429. You can specify multiple IPs with comma separated.|
|`PROXY`          |`null`          |Set HTTP or SOCKS5 Proxy for RClone. [Rclone documentation](https://rclone.org/faq/#can-i-use-rclone-with-an-http-proxy) for details.|
|`LOG_LEVEL`      |`INFO`          |Please refer to the [Rclone documentation](https://rclone.org/docs#log-level-level) before changes are made.|
|`DLFOLDER`       |`/mnt/downloads`|Path to your download directory.|
|`TRANSFERS`      |`2`             |The maximum number of concurrent uploads.|

#### USER - SETTINGS
|Setting          |Default|Description|
|-----------------|-------|-----------|
|`DRIVEUSEDSPACE` |`null` |Amount of local storage, in percent, to use before uploading any files. Example:</br>`DRIVEUSEDSPACE=80` will wait until the drive space used reaches 80% before uploading files.|
|`FOLDER_DEPTH`   |`1`    |If your movie/show folders are in root of drive, you can leave this to 1, if you have them in a subfolder you have to change the depth value, Example `media/tvshow/showname` would result in `FOLDER_DEPTH=2` (if you use multiuploader, you need the same DEPTH/folder structure on all drives where you upload to).</br></br>**IMPORTANT**: This setting should only be used if you know what you are doing. By changing the value, you accept all risks that come with it.|
|`FOLDER_PRIORITY`|`null` |Add folders you like to prioritize - Example: `tv,movies` (tv first, then movies, then all others not in the list).|
|`MIN_AGE_UPLOAD` |`1`    |How old a file should be, in minutes, before it is uploaded. Example:</br>`MIN_AGE_UPLOAD=10` will wait until a file is 10 minutes old before it is uploaded.|

#### VFS - SETTINGS
|Setting             |Default     |Description|
|--------------------|------------|-----------|
|`VFS_REFRESH_ENABLE`|`true`      |Whether or not the VFS cache refresh should be send to the Mount Docker. Options:</br>`true`</br>`false`|
|`MOUNT`             |`mount:8554`|The local address of your mount instance.|

#### LOG - SETTINGS
|Setting             |Default|Description|
|--------------------|-------|-----------|
|`LOG_ENTRY`         |`1000` |How many log entries should be retained in the local database.|
|`LOG_RETENTION_DAYS`|`null` |How many days of log entries should be kept. If `LOG_RETENTION_DAYS` is defined, then `LOG_ENTRY` is ignored.|

#### AUTOSCAN - SETTINGS
Autoscan is optional, people with feeders may use it to trigger scan after upload is completed.</br>If you enable it in uploader, you can disable it in the *arrs.

|Setting        |Default|Description|
|---------------|-------|-----------|
|`AUTOSCAN_URL` |`null` |Remote or local path to Autoscan. Examples:</br>Remote: `AUTOSCAN_URL=https://autoscan.domain.com`</br>Local: `AUTOSCAN_URL=http://autoscan:3030`|
|`AUTOSCAN_USER`|`null` |Autoscan username.|
|`AUTOSCAN_PASS`|`null` |Autoscan password.|

#### NOTIFICATION - SETTINGS
[Apprise](https://github.com/caronc/apprise) has been integrated into Uploader and is defaulted to format all notifications in [Markdown](https://www.markdownguide.org/). Please refer to the [Apprise documentation](https://github.com/caronc/apprise/wiki) for more information.

![Image of Notification](/img/notifications/discord-uploader.png)

|Setting                  |Default|Description|
|-------------------------|-------|-----------|
|`NOTIFICATION_URL`       |`null` |The notification URL to be passed to Apprise. Discord examples:</br>`https://discordapp.com/api/webhooks/{WebhookID}/{WebhookToken}`</br>`discord://{WebhookID}/{WebhookToken}/`</br>`discord://{user}@{WebhookID}/{WebhookToken}/`|
|`NOTIFICATION_LEVEL`     |`ALL`  |What notifications should be sent to `NOTIFICATION_URL`. Options:</br>`ALL` - Send notification for all uploads</br>`ERROR` - Send notification for only errors</br>`NONE` - Do not send any notifications|
|`NOTIFICATION_SERVERNAME`|`null` |What to display on the notification, after "Uploader - ". `null` will default to "Uploader - Docker". Anything else will only replace "Docker".</br>Examples:</br>`NOTIFICATION_SERVERNAME=null` results in "Uploader - Docker"</br>`NOTIFICATION_SERVERNAME=My Awesome Server` will result in "Uploader - My Awesome Server"|

#### STRIPARR - SETTINGS
[Striparr](https://github.com/mikenye/docker-striparr) is optional and needs the Striparr Docker to be deployed on the same System. The files will not be uploaded until they have been successfully striped. 

|Setting       |Default|Description|
|--------------|-------|-----------|
|`STRIPARR_URL`|`null` |The Striparr URL. Example: `STRIPARR_URL=http://striparr:40000`|

#### LANGUAGE MESSAGES
|Setting   |Default|Description|
|----------|-------|-----------|
|`LANGUAGE`|`en`   |Language to use. Options:</br>`en` - English</br>`de` - German|

### Multi-Drive Uploader
If you would like to upload to multiple Team Drives, you need to create a file named `uploader.csv` in `/opt/appdata/system/servicekeys/`. You can find a sample file in `opt/appdata/system/uploader/sample`. For each Team Drive, add a line in the `uploader.csv` file.

**IMPORTANT**: If "LOCAL_FOLDER_NAME" contains a hyphen, do not include it.
</br>
</br>

**Unencrypted Team Drives example:**

- 1 = LOCAL_FOLDER_NAME -> (TV)
- 2 = TEAM_DRIVE_ID -> (0AFsVct4HDKPrUk9PVvvvvvvvv)
#### Important: Each line in csv is one Local Folder
Example:
```yaml
TV|0AFsVct4HDKPrUk9PVvvvvvvvv
TV4K|0AFsVct4HDKPrUk9PVxxxxxxxxxx
Movies|0AFsVct4HDKPrUk9PVyyyyyyyyyy
Movies4K|0AFsVct4HDKPrUk9PVzzzzzzzzzz
appbackups|0AFsVct4HDKPrUk9PVzzzzzzzzzz
music|0AFsVct4HDKPrUk9PVzzzzzzzzzz
```

**Encrypted Team Drives example:**

- 1 = LOCAL_FOLDER_NAME -> (Movies)
- 2 = TEAM_DRIVE_ID -> (0AFsVct4HDKPrUk9PVvvvvvvvv)
- 3 = PASSWORD - <HASHED|PLAIN> -> (72nsjsiwjsjsu)
- 4 = PASSWORD SALT - <HASHED|PLAIN> -> (72nsjsiwjsjsu)
#### Important: Each line in csv is one Local Folder
Example:
```yaml
Movies|0AFsVct4HDKPrUk9PVvvvvvvvv|72nsjsiwjsjsu|72nsjsiwjsjsu
TV SHows|0AFsVct4HDKPrUk9PVxxxxxxxxxx|72nsjsiwjsjsu|72nsjsiwjsjsu
4K|0AFsVct4HDKPrUk9PVyyyyyyyyyy|72nsjsiwjsjsu|72nsjsiwjsjsu
TV 4K|0AFsVct4HDKPrUk9PVzzzzzzzzzz|72nsjsiwjsjsu|72nsjsiwjsjsu
appbackups|0AFsVct4HDKPrUk9PVzzzzzzzzzz|72nsjsiwjsjsu|72nsjsiwjsjsu
music|0AFsVct4HDKPrUk9PVzzzzzzzzzz|72nsjsiwjsjsu|72nsjsiwjsjsu
```

**IMPORTANT**: </br>
</br>
All Keys must be known on all Team Drives! </br>
You also have to add all folders where you want to upload files (even backup folders).

### Other Uploader Features
Instead of using `/opt/appdata/system/servicekeys/rclonegdsa.conf`, you can now use a `drive.csv` where you can put the default Team Drive to upload in. To make use of this feature, you need to create a file named `drive.csv` in `/opt/appdata/system/uploader/`.
</br>
</br>

#### Unencrypted Team Drives

- 1 = TEAM_DRIVE_NAME -> (uploader)
- 2 = TEAM_DRIVE_ID -> (0XXXXXXXXX000000EERR)
#### Important: Each line in csv is one tdrive
Example:

```yaml
uploader|0XXXXXXXXX000000EERR
```

#### Encrypted Team Drives

- 1 = TEAM_DRIVE_NAME -> (uploader)
- 2 = TEAM_DRIVE_ID -> (0XXXXXXXXX000000EERR)
- 3 = PASSWORD - HASHED OR PLAIN -> (72nsjsiwjsjsu)
- 4 = PASSWORD SALT - HASHED OR PLAIN -> (72nsjsiwjsjsu)
#### Important: Each line in csv is one tdrive
Example:
```yaml
uploader|0XXXXXXXXX000000EERR|72nsjsiwjsjsu|72nsjsiwjsjsu
```

## Support
Kindly report any issues on [GitHub](https://github.com/dockserver/dockserver/issues) or [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
