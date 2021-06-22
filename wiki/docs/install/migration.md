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

# Introduction

While many of us has enjoyed PGblitz over the years, the project is now scattered. Some simply ghosted the whole community, and the rest of the devs are working on other projects. 
Even though PGblitz still works, **there are numerous upsides in shifting to dockserver:**

- Updated rclone/mount 
- No file limits
- Sonarr/Radarr can now analyze the media without hitting api bans
- On-the-fly configuration of HW Transcoding
- Intelligent uploader that will automatically start pushing your content to the cloud when disk space is getting low
...to name a few...

# Before you start: 

We strongly recommend restoring your Server on a [VPS](https://www.hetzner.com/cloud "VPS") or something similar before making the final migration. This is to avoid data-loss and to harden your backups for your final dockserver migration.

## Prerequisites:
- PGblitz
- CloudCMD deployed (Under Community Apps) 

Open CloudCMD, Navigate to: 

/appdata/plexguide/.blitzkeys

Download the contents of that folder (rclone.conf and GDSA keys) to your local machine. These files are very important. Handle with care.

On some forks of PG these files are placed under /uploader and /mount.

Now you are ready to backup your PG apps.

`sudo wget -qO- https://raw.githubusercontent.com/dockserver/dockserver/master/backup.sh | sudo bash`

This will create a folder named /appbackups on the root of your remote drive. When the backup is done, check that these files exist on your remote drive. Also, check them for file sizes to make sure it looks right. Plex can take a long time, be patient. 

Now, please order a VPS with ubuntu 18/20 on it and follow the instructions on the [frontpage](http://docs.dockserver.io "frontpage"). When dockserver is installed on your host, return here and follow instructions


# Mount & Uploader

Install CloudCMD (under addons) 

Navigate to 
/opt/system/rclone
Upload the rclone.conf from your old server

Navigate to 
/opt/system/servicekeys

Upload the rclone.conf to this folder
Rename rclone.conf to rclonegdsa.conf

Navigate to 
/opt/system/servicekeys/keys
Upload all service keys (GDSA01,02..)
Rename all service keys to not containing a 0 so GDSA01 becomes GDSA1 and so forth..

Open a terminal

`sudo nano /opt/appdata/system/rclone/rclone.conf`

Remove all GDSA lines here, only the remotes(g/tdrive, g/tcrypt) are left in the file - PGUNION has to be deleted as well
CTRX+X press y 

`sudo nano /opt/appdata/system/servicekeys/rclonegdsa.conf`

Again, remove all zeroes so that the values will be displayed like this:

[GDSA1] 
service_account_file = /system/servicekeys/keys/GDSA1

[GDSA2] 
service_account_file = /system/servicekeys/keys/GDSA2

CTRL+X y 

Done. 

Now you can deploy mount & uploader under in the system section in the CLI

After this you are ready to restore your PG apps on a brand new Dockserver installation





## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

* Join our <a href="https://discord.gg/FYSvu83caM">
        <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
    </a> for Support

----

