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

# Creating Tdrive Remote

First, install rclone if you have not:
```
sudo apt install rclone
```
or
```
curl https://rclone.org/install.sh | sudo bash
```

Then:
```
rclone config
```
Type n for New Remote

Type tdrive

Select from the list Google Drive (not Google Cloud Storage)

Use the same client ID and secret from gdrive remote creation

You will now Have a number of prompts:

scope – type 1 and then enter

root folder - Leave Blank and press Enter

service_account_file - Leave this blank and press enter

advanced config (y/n) - Type n and then enter

auto config - Type n and then enter

Copy the URL provided and paste into browser.

Enter your login details and paste token into terminal.

Configure this as a team drive? , type y and then enter

type y for Yes this is OK

You can type Q to exit

The rclone.conf file will be save in /.config/rclone

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our <a href="https://discord.gg/FYSvu83caM">

## Installation notes

- Each drive supports not more than 99 service accounts
- Each service account will allow 750GB of data upload per 24 hours
- Do **NOT** confuse team drive name for the actual ID
  To find your ID - Go to drive.google.com -> Teamdrive and copy the ID from the url
  example: https://drive.google.com/drive/folders/XXXXX845JTK5VXUXXXXXXXX

For this example the id is **XXXXX845JTK5VXUXXXXXXXX**

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
