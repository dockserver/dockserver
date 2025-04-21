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

# Migration Introduction

While many of us has enjoyed PGblitz over the years, the project is now scattered. Some simply ghosted the whole community, and the rest of the devs are working on other projects.
Even though PGblitz still works, **there are numerous upsides in shifting to dockserver:**

- Updated rclone/mount
- No file limits
- Sonarr/Radarr can now analyze the media without hitting api bans
- On-the-fly configuration of HW Transcoding
- Intelligent uploader that will automatically start pushing your content to the cloud when disk space is getting low
  ...to name a few...

# Before you start:

We strongly recommend restoring your Server on a [VPS](https://www.hetzner.com/cloud "VPS") or something similar before making the final migration. This is to avoid data-loss and to harden your backups for your final dockserver migration. This guide will take you through a migration with Teamdrive deployed on your pg installation. Feel free to experiement with the gdsa builder in the CLI.

## Prerequisites:

- PGblitz
- Tdrive/Tcrypt mount deployed
- CloudCMD deployed (Under Community Apps)

Open CloudCMD, Navigate to:

/appdata/plexguide/.blitzkeys

Download the contents of that folder (rclone.conf and GDSA keys) to your local machine. These files are very important. Handle with care.

On some forks of PG these files are placed under /uploader and /mount.

Now you are ready to backup your PG apps.

```
sudo wget -qO- https://raw.githubusercontent.com/dockserver/dockserver/master/backup.sh | sudo bash
```

This will create a folder named /appbackups on the root of your remote drive. When the backup is done, check that these files exist on your remote drive. Also, check them for file sizes to make sure it looks right. Plex can take a long time, be patient.

Now, please order a VPS with ubuntu 22 on it and follow the instructions on the [Wiki](https://dockserver.github.io/install/install.html). When dockserver is installed on your host, return here and follow instructions

# Mount & Uploader

Open a terminal

Create the folders

```
sudo mkdir -p /opt/appdata/system/{rclone,servicekeys}
```

```
sudo chown -cR 1000:1000 /opt/appdata
```

Install CloudCMD (under addons)

Navigate to
/opt/appdata/system/rclone
Upload the rclone.conf from your old server.
Do not rename this one.

Navigate to
/opt/appdata/system/servicekeys

Upload the the same rclone.conf to this folder.
Rename this rclone.conf to rclonegdsa.conf

Navigate to
/opt/appdata/system/servicekeys/keys
Upload all service keys (GDSA01,02..)
Rename all service keys to not containing a 0 so GDSA01 becomes GDSA1 and so forth..


Edit your rclone.conf

```sh
sudo nano /opt/appdata/system/rclone/rclone.conf
```

Remove all GDSA lines here, only the remotes(g/tdrive, g/tcrypt) are left in the file - PGUNION has to be deleted as well
Like this:
```
[gdrive]
client_id = XOXOYOURID
client_secret = XOXOYOURSECRET
type = drive
server_side_across_configs = true
token = XOXOYOURTOKEN

[tdrive]
client_id = XOXOYOURID
client_secret = XOXOYOURSECRET
type = drive
server_side_across_configs = true
token = XOXOYOURTOKEN
team_drive = XXXXXXXXXXXXXXXXXXX

[tdrive2]
client_id = XOXOYOURID
client_secret = XOXOYOURSECRET
type = drive
server_side_across_configs = true
token = XOXOYOURTOKEN
team_drive = XXXXXXXXXXXXXXXXXXX
```

CTRX+X press y

Edit rclonegdsa.conf

```
sudo nano /opt/appdata/system/servicekeys/rclonegdsa.conf
```

Remove all the remotes (g/tdrive, g/tcrypt) - PGUNION has to be deleted as well.
You'll also want to make sure to update the `service_account_file` line. Remove the previous path and change it to `/system/servicekeys/keys/` like below.
Again, remove all zeroes so that the values will be displayed like this:

```
[GDSA1]
type = drive
scope = drive
service_account_file = /system/servicekeys/keys/GDSA1
team_drive = XXXXXXXXXXXXXXXXXXX

[GDSA2]
type = drive
scope = drive
service_account_file = /system/servicekeys/keys/GDSA2
team_drive = XXXXXXXXXXXXXXXXXXX
```

CTRL+X y

Done.

Now you can deploy mount & uploader under in the system section in the CLI

After this you are ready to restore your PG apps on a brand new Dockserver installation

## Note:
Google Token Expire

it may possible that your Google token expires after a server reboot/migration or other things

logs can be checked with this:
```
sudo tail -n 50 -f /opt/appdata/system/mount/logs/rclone-union.log
```
And you can also check if remotes are displaying something:
```
sudo docker exec mount ls -1p /mnt/unionfs
```
if you see something like: 
Token Expired or could not authenticate with google

then this is your solution (only do a token refresh):
```
sudo docker stop mount
sudo fusermount -uzq /mnt/unionfs 
sudo fusermount -uzq /mnt/remotes
```
```
cd /opt/appdata/system/rclone
```
You can install rclone using the following command:
```
sudo apt install curl jq && sudo curl https://rclone.org/install.sh | sudo bash
```
After installing Rclone, verify the Rclone version with the following command:
```
sudo rclone --version
```
Then reconnect:
```
rclone config reconnect tdrive: --config=rclone.conf

rclone config reconnect gdrive: --config=rclone.conf
```
Then start mount again:
```
sudo fusermount -uzq /mnt/unionfs
sudo docker start mount
sudo docker logs -f mount
( or use dozzle for the logs reading )
```


## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our <a href="https://discord.gg/FYSvu83caM">
