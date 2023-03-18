![Image of DockServer](/img/container_images/docker-restic.png)

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


# Restic

Restic is a backup program that is fast, efficient and secure. It supports the three major operating systems (Linux, macOS, Windows) and a few smaller ones (FreeBSD, OpenBSD).

### Features:
- Full Rclone Support.
- Runs default every day at 2am.
- Multiple jobs possible.
- Automatic configuration and repository creation.

## Configuration
All settings can be found here: `/opt/appdata/restic/restic/restic.env`

#### USER VALUES
|Setting   |Default|Description|
|----------|-------|-----------|
|`PUID`    |`1000` |PGUID to be used by Restic.|
|`PGID`    |`1000` |PGID to be used by Restic.|
|`TIMEZONE`|`UTC`  |Timezone to be used by Restic.|

#### RESTIC - SETTINGS
|Setting          |Default|Description|
|-----------------|-------|-----------|
|`RESTIC_JOBS` |`1` |Configure multiple jobs, creates for every job an extra ENV file.|
|`RESTIC_HOST`   |`Restic`    |Restic Backup hostname.|
|`RESTIC_REPOSITORY`|`null` |Rclone Backup path eg example: `rclone:tdrive:backup/myservername`.|
|`RESTIC_PASSWORD` |`null`    |Secure password for your backups.|
|`RESTIC_TAG` |`appdata`    |Backup Tag, good for multiple Backups.|
|`RESTIC_EXCLUDES` |`/app/restic/excludes.txt`  |Default Excludes File inside the Docker.|
|`RESTIC_PACK_SIZE` |`32`  |Restic Pack Size [Restic documentation](https://restic.readthedocs.io/en/latest/047_tuning_backup_parameters.html#pack-size)|
|`RESTIC_CACHE_DIR` |`/config/.cache`  |Backup Cache Folder.|
|`RESTIC_FOLDER` |`/opt/appdata`    |Backup Folder.|

#### RCLONE - SETTINGS
|Setting          |Default         |Description|
|-----------------|----------------|-----------|
|`GOOGLE_IP`      |`142.250.74.78` |Set hardcoded IP for `www.googleapis.com` this does prevent Error 429. You can specify multiple IPs with comma separated.|
|`PROXY`          |`null`          |Set HTTP or SOCKS5 Proxy for RClone. [Rclone documentation](https://rclone.org/faq/#can-i-use-rclone-with-an-http-proxy) for details.|

#### NOTIFICATION - SETTINGS
[Apprise](https://github.com/caronc/apprise) has been integrated into Uploader and is defaulted to format all notifications in [Markdown](https://www.markdownguide.org/). Please refer to the [Apprise documentation](https://github.com/caronc/apprise/wiki) for more information.

![Image of Notification](/img/notifications/discord-restic.png)

|Setting                  |Default|Description|
|-------------------------|-------|------------|
|`NOTIFICATION_URL`       |`null` |The notification URL to be passed to Apprise. Discord examples:</br>`https://discordapp.com/api/webhooks/{WebhookID}/{WebhookToken}`</br>`discord://{WebhookID}/{WebhookToken}/`</br>`discord://{user}@{WebhookID}/{WebhookToken}/`|
|`NOTIFICATION_LEVEL`     |`ALL`  |What notifications should be sent to `NOTIFICATION_URL`. Options:</br>`ALL` - Send notification for all backups</br>`ERROR` - Send notification for only errors</br>`NONE` - Do not send any notifications|
|`NOTIFICATION_SERVERNAME`|`null` |What to display on the notification, after "Restic - ". `null` will default to "Restic - Docker". Anything else will only replace "Docker".</br>Examples:</br>`NOTIFICATION_SERVERNAME=null` results in "Restic - Docker"</br>`NOTIFICATION_SERVERNAME=My Awesome Server` will result in "Restic Backup - My Awesome Server"|

## Setup Restic Backup

#### Install Container

Install from dockserver>apps>backup menu

#### Create Service Account
copy service account to `/appdata/restic`
make sure service account has manager permissions on google.


#### Create Rclone.conf 
`nano /opt/appdata/restic/rclone/rclone.conf`
Should look something like this:
`
[tdrive]
type = drive
scope = drive
service_account_file = /config/NAMEOFSA
team_drive =xxxxxxxxx
`


#### ENV Setup
edit `/opt/appdata/restic/restic/restic.env`
change `RESTIC_REPOSITORY="null"` to `RESTIC_REPOSITORY="rclone:tdrive:PATH/TO/BACKUP/FOLDER"`
change `RESTIC_PASSWORD=null` to `RESTIC_PASSWORD=YOURPASSWORD`


#### Restart Container

After changes, `sudo docker restart restic`



## Restic Commands
Manual Backup
`
docker exec -it restic bash
source /app/restic/restic.sh
resticbackup
`
Full restore
`
docker exec -it restic bash
source /app/restic/restic.sh
resticrestore-full
`
APP Restore
`
docker exec -it restic bash
source /app/restic/restic.sh
resticrestore <APPNAME>
`






## Support
Kindly report any issues on [GitHub](https://github.com/dockserver/dockserver/issues) or [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
