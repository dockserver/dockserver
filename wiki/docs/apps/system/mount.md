![Image of DockServer](/img/container_images/docker-mount.png)

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

# Mount

### Features:
- Key Rotation System.
- Rclone Web-GUI (https://mount.mydomain.com).
- Notifications via [Apprise](https://github.com/caronc/apprise).


### Limitations:
- Support for only English or German.

## Configuration
All settings can be found here: `/opt/appdata/system/mount/mount.env`

#### USER VALUES
|Setting   |Default|Description|
|----------|-------|-----------|
|`PUID`    |`1000` |PGUID to be used by Mount.|
|`PGID`    |`1000` |PGID to be used by Mount.|
|`TIMEZONE`|`UTC`  |Timezone to be used by Mount.|

#### CRITICAL SETUP FOR CRYPT USER
|Setting       |Default |Description|
|--------------|--------|-----------|
|`HASHPASSWORD`|`hashed`|If using `drive.csv` and encrypted Team Drive, this must be set.</br>Options:</br>`hashed`</br>`plain`|

You have 2 options for this value `HASHPASSWORD`.

1. `hashed` this tells uploader that you have the encrypted password in your `drive.csv`.

2.  `plain` this tells the uploader that you have the plain password in your `drive.csv`.

You can leave the value as it is if you dont use Multi Drive uploading.

#### MERGERFS ADDITIONAL FOLDER
|Setting          |Default         |Description|
|-----------------|----------------|-----------|
|`ADDITIONAL_MOUNT`|`null`          |Additional mount points for `unionfs`|
|`ADDITIONAL_MOUNT_PERMISSION`      |`RW`          |Read/Write permissons for additional mount points. Options:</br>`RW`</br>`RO`|

#### RCLONE - SETTINGS
|Setting             |Default|Description|
|--------------------|-------|-----------|
|`UMASK`    |`18` |Rclone uses his own values `18` = `022`|
|`DRIVETRASH`    |`false`    |Whether or not the Drive Trash schould be used. Options:</br>`true`</br>`false`|
|`DRIVE_CHUNK_SIZE`         |`128M` |Rclone Performance setting - This setting should only be changed if you know what you are doing|
|`BUFFER_SIZE`|`32M` |Rclone memory buffer setting - [Rclone documentation](https://rclone.org/docs/#buffer-size-size)|
|`TMPRCLONE`|`/mnt/rclone_cache` |Rclone Cache Folder|
|`UAGENT`|`NONE` |Randomly generated - doesn't need to be changed|
|`TPSLIMIT`|`10` |Rclone limit transactions per second - [Rclone documentation](https://rclone.org/docs/#tpslimit-float)|
|`TPSBURST`|`10` |Rclone limit transactions burst - [Rclone documentation](https://rclone.org/docs/#tpslimit-burst-int)|

#### VFS - SETTINGS
|Setting             |Default     |Description|
|--------------------|------------|-----------|
|`VFS_READ_CHUNK_SIZE`|`128M`      |Rclone read chunk size - [Rclone documentation](https://rclone.org/commands/rclone_mount/#vfs-chunked-reading)|
|`VFS_READ_CHUNK_SIZE_LIMIT`|`4096M`      |Rclone limit read chunk size - [Rclone documentation](https://rclone.org/commands/rclone_mount/#vfs-chunked-reading)|
|`VFS_CACHE_MAX_SIZE`|`NONE`      |Maximum rclone cache size - calculated within server drive size|
|`VFS_REFRESH_ENABLE`|`true`      |Whether or not the VFS cache should be refreshed. Options:</br>`true`</br>`false`|
|`VFS_REFRESH`             |`12h`|After what period of time the next VFS refresh should be done|

#### LOG - SETTINGS
|Setting             |Default     |Description|
|--------------------|------------|-----------|
|`LOG_LEVEL`      |`INFO`          |Please refer to the [Rclone documentation](https://rclone.org/docs#log-level-level) before changes are made.|

#### NOTIFICATION - SETTINGS
[Apprise](https://github.com/caronc/apprise) has been integrated into Mount and is defaulted to format all notifications in [Markdown](https://www.markdownguide.org/). Please refer to the [Apprise documentation](https://github.com/caronc/apprise/wiki) for more information.

![Image of Notification](/img/notifications/discord-mount.png)
|Setting                  |Default|Description|
|-------------------------|-------|------------|
|`NOTIFICATION_URL`       |`null` |The notification URL to be passed to Apprise. Discord examples:</br>`https://discordapp.com/api/webhooks/{WebhookID}/{WebhookToken}`</br>`discord://{WebhookID}/{WebhookToken}/`</br>`discord://{user}@{WebhookID}/{WebhookToken}/`|
|`NOTIFICATION_SERVERNAME`|`null` |What to display on the notification, after "Mount - ". `null` will default to "Mount - Docker". Anything else will only replace "Docker".</br>Examples:</br>`NOTIFICATION_SERVERNAME=null` results in "Mount - Docker"</br>`NOTIFICATION_SERVERNAME=My Awesome Server` will result in "Mount - My Awesome Server"|

#### LANGUAGE MESSAGES
|Setting   |Default|Description|
|----------|-------|-----------|
|`LANGUAGE`|`en`   |Language to use. Options:</br>`en` - English</br>`de` - German|

## Optional - Service Key Mount
Service Key Mount is used to prevent **GOOGLE API Bans**. To make use of this you need to create new Keys with a new Google Project.</br></br>
**IMPORTANT**: do not use the same Keys as for the Uploader.</br></br>
To create new Keys please refer to this [Documentation](https://dockserver.io/drive/saccounts.html).</br>
Put the new Keys in `opt/appdata/system/mount/keys`. You can name the keys whatever you want.</br>
When keys are present a new file named `drive.csv` is created under `opt/appdata/system/mount`. This file contains all Team Drive Informations from your `rclone.conf` located in `opt/appdata/system/rclone`.
When you dont have an `rclone.conf` you can create the `drive.csv` by yourself.
</br>
</br>

#### Uncryted Team Drives

Example:

```yaml
1 = TEAM_DRIVE_NAME
2 = TEAM_DRIVE_ID
TV|0AFsVct4HDKPrUk9PVvvvvvvvv
TV4K|0AFsVct4HDKPrUk9PVxxxxxxxxxx
Movies|0AFsVct4HDKPrUk9PVyyyyyyyyyy
Movies4K|0AFsVct4HDKPrUk9PVzzzzzzzzzz
.
.
.
```

#### Encryted Team Drives

Example:
```yaml
1 = TEAM_DRIVE_NAME
2 = TEAM_DRIVE_ID
3 = PASSWORD - HASHED OR PLAIN
4 = PASSWORD SALT - HASHED OR PLAIN
tdrive1|0AFsVct4HDKPrUk9PVvvvvvvvv|72nsjsiwjsjsu|72nsjsiwjsjsu
tdrive2|0AFsVct4HDKPrUk9PVxxxxxxxxxx|72nsjsiwjsjsu|72nsjsiwjsjsu
tdrive3|0AFsVct4HDKPrUk9PVyyyyyyyyyy|72nsjsiwjsjsu|72nsjsiwjsjsu
tdrive4|0AFsVct4HDKPrUk9PVzzzzzzzzzz|72nsjsiwjsjsu|72nsjsiwjsjsu
.
.
.
```

**IMPORTANT**: All Keys must be known on all Team Drives!


## RAM Rclone Cache

#### Rclone_cache into RAM

Since our servers usually have a lot of ram that is not used at all, there is a possibility to save some ssd memory by putting the rclone_cache into the ram.

**IMPORTANT**: Only for advanced Users

You should give rclone at least 50GB cache!
This tutorial is only recommended if you have at least 128GB RAM.

#### Setup

For this we proceed as follows:

1. how much ram is available? in my example 128GB
1. the /dev/shm directory is the ram cache in linux, by default 1/2 of the ram
However, we can increase this.
1. `sudo nano /etc/fstab`
 add
`tmpfs /dev/shm tmpfs defaults,size=116g 0 0`

1. disable swap: `sudo swapoff -a`
1. `sudo nano /opt/appdata/system/mount/mount.env`

1. change `TMPRCLONE=/ram_cache`
1. change `VFS_CACHE_MAX_SIZE=80G`

1. reboot machine `sudo reboot -n`
1. check if /mnt/unionfs get still mounted, if not redeploy mount app ( `sudo mountpoint /mnt/unionfs/` & `sudo docker log mount` )


## Support
Kindly report any issues on [GitHub](https://github.com/dockserver/dockserver/issues) or [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support

