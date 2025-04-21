![Image of DockServer](/img/container_images/docker-dockserver.png)

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

# Mount Keys

### Service Key Mount
Service Key Mount is used to prevent **Google API Bans**. To make use of this, you need to create new Keys within a different Google Project.

**IMPORTANT**: Do **not** use the same Keys as for the Uploader!

#### Setup:
- Create new Service Account Keys (see [Documentation](https://dockserver.github.io/dockserver/drive/saccounts.html))
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

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)
