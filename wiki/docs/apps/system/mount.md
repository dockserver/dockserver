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
- Service Key Mount.
- Rclone Web-GUI (https://mount.mydomain.com).
- Notifications via [Apprise](https://github.com/caronc/apprise).

## Configuration
All settings can be found here: `/opt/appdata/system/mount/mount.env`

Latest yml for installation can be found here [Link](https://github.com/dockserver/apps/blob/master/mount/docker-compose.yml).

#### USER VALUES
|Setting   |Default|Description|
|----------|-------|-----------|
|`PUID`    |`1000` |PGUID to be used by Mount.|
|`PGID`    |`1000` |PGID to be used by Mount.|
|`TIMEZONE`|`UTC`  |Timezone to be used by Mount.|

#### CRITICAL SETUP FOR CRYPT USER
|Setting       |Default |Description|
|--------------|--------|-----------|
|`HASHPASSWORD`|`hashed`|If using `drive.csv` and encrypted Team Drive, this must be set. Otherwise, you may leave the value as is.</br>Options:</br>`hashed` - Tells uploader that you have the encrypted password in your `drive.csv`.</br>`plain` - Tells uploader that you have the plain password in your `drive.csv`.|

#### MERGERFS ADDITIONAL FOLDER
|Setting                      |Default         |Description|
|-----------------------------|----------------|-----------|
|`ADDITIONAL_MOUNT`           |`null`          |Additional mount points for `unionfs`.|
|`ADDITIONAL_MOUNT_PERMISSION`|`RW`            |Read/Write permissons for additional mount points. Options:</br>`RW` - Read/Write</br>`RO` - Read Only|

#### RCLONE - SETTINGS
For Rclone WebUI - Leave user and password blank and hit login button. 


|Setting           |Default            |Description|
|------------------|-------------------|-----------|
|`UMASK`           |`18`               |Rclone uses its own values `18` = `022`.|
|`DRIVETRASH`      |`false`            |Whether or not the Drive Trash should be used. Options:</br>`true`</br>`false`|
|`DRIVE_CHUNK_SIZE`|`128M`             |Rclone performance setting. This setting should only be changed if you know what you are doing.|
|`BUFFER_SIZE`     |`32M`              |Rclone memory buffer setting. See [Rclone documentation](https://rclone.org/docs/#buffer-size-size) for details.|
|`TMPRCLONE`       |`/mnt/rclone_cache`|Rclone cache folder.|
|`UAGENT`          |`NONE`             |This is randomly generated and does not need to be changed.|
|`TPSLIMIT`        |`10`               |Rclone limit transactions per second. See [Rclone documentation](https://rclone.org/docs/#tpslimit-float) for details.|
|`TPSBURST`        |`10`               |Rclone limit transactions burst. See [Rclone documentation](https://rclone.org/docs/#tpslimit-burst-int) for details.|

#### VFS - SETTINGS
|Setting                    |Default|Description|
|---------------------------|-------|-----------|
|`VFS_READ_CHUNK_SIZE`      |`128M` |Rclone read chunk size. See [Rclone documentation](https://rclone.org/commands/rclone_mount/#vfs-chunked-reading) for details.|
|`VFS_READ_CHUNK_SIZE_LIMIT`|`4096M`|Rclone limit read chunk size. See [Rclone documentation](https://rclone.org/commands/rclone_mount/#vfs-chunked-reading) for details.|
|`VFS_CACHE_MAX_SIZE`       |`NONE` |Rclone maximum allowed local cache size.|
|`VFS_REFRESH_ENABLE`       |`true` |Whether or not the VFS cache should be refreshed. Options:</br>`true`</br>`false`|
|`VFS_REFRESH`              |`12h`  |How often to perform a VFS refresh.|

#### LOG - SETTINGS
|Setting    |Default|Description|
|-----------|-------|-----------|
|`LOG_LEVEL`|`INFO` |Please refer to the [Rclone documentation](https://rclone.org/docs#log-level-level) before changes are made. Options:</br>`DEBUG`</br>`INFO`</br>`NOTICE`</br>`ERROR`|

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

## Optional Settings

### Service Key Mount
Service Key Mount is used to prevent **Google API Bans**. To make use of this, you need to create new Keys within a different Google Project.

**IMPORTANT**: Do **not** use the same Keys as for the Uploader!

#### Setup:
- Create new Service Account Keys (see [Documentation](https://dockserver.io/drive/saccounts.html))
- Share all Keys with all Team Drives and set to `Manager`.
- Place the new Keys in `opt/appdata/system/mount/keys`. (You may name the Keys whatever you'd like)
- When Keys are present, a file named `drive.csv` is created under `opt/appdata/system/mount`. This file contains all Team Drive information from your `rclone.conf` located in `opt/appdata/system/rclone`.

If you don't have an `rclone.conf`, you can create the `drive.csv` manually. </br>

**Unencrypted Team Drives example:**
```yaml
1 = TEAM_DRIVE_NAME
2 = TEAM_DRIVE_ID
TV|0AFsVct4HDKPrUk9PVvvvvvvvv
TV4K|0AFsVct4HDKPrUk9PVxxxxxxxxxx
Movies|0AFsVct4HDKPrUk9PVyyyyyyyyyy
Movies4K|0AFsVct4HDKPrUk9PVzzzzzzzzzz
...
```

**Encrypted Team Drives example:**
```yaml
1 = TEAM_DRIVE_NAME
2 = TEAM_DRIVE_ID
3 = PASSWORD - <HASHED|PLAIN>
4 = PASSWORD SALT - <HASHED|PLAIN>
tdrive1|0AFsVct4HDKPrUk9PVvvvvvvvv|72nsjsiwjsjsu|72nsjsiwjsjsu
tdrive2|0AFsVct4HDKPrUk9PVxxxxxxxxxx|72nsjsiwjsjsu|72nsjsiwjsjsu
tdrive3|0AFsVct4HDKPrUk9PVyyyyyyyyyy|72nsjsiwjsjsu|72nsjsiwjsjsu
tdrive4|0AFsVct4HDKPrUk9PVzzzzzzzzzz|72nsjsiwjsjsu|72nsjsiwjsjsu
...
```

### Use RAM for rclone_cache

**IMPORTANT**: Only for advanced users.  If your system has less than 128GB of RAM or you are unable to allocate at least 50GB for rclone_cache, you should **not** attempt this.

Since our servers usually have a lot of unused RAM, there is a possibility to save local storage while reducing wear and tear on the drive(s) by utilizing RAM for the rclone_cache.
</br>`/dev/shm` is the RAM cache in Linux and , by default, is 1/2 of all system RAM. The example below shows how to change this.

#### Example setup for a system with 128GB of RAM:
1. `sudo nano /etc/fstab`
1. Add `tmpfs /dev/shm tmpfs defaults,size=116g 0 0` (Where `116g` is the amount of RAM to reserve for cache, in gigabytes.)
1. Disable swap: `sudo swapoff -a`
1. `sudo nano /opt/appdata/system/mount/mount.env`
1. Change `TMPRCLONE=/ram_cache`
1. Change `VFS_CACHE_MAX_SIZE=80G`
1. Reboot machine `sudo reboot -n`
1. Verify that `/mnt/unionfs` is mounted. If not, redeploy Mount (`sudo mountpoint /mnt/unionfs/` & `sudo docker log mount`)

## Support
Kindly report any issues on [GitHub](https://github.com/dockserver/dockserver/issues) or [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
