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

# Creating Gdrive Remote

First, install rclone:
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

Type gdrive

Select from the list Google Drive (not Google Cloud Storage)

Now it is time to make your own client_id and secret:

Goto https://console.developers.google.com/

Make sure you are logged in with the correct google account.

Create a New Project

Under “ENABLE APIS AND SERVICES” search for “Drive”, and enable the “Google Drive API”

Click "OAuth consent screen" in the left-side panel. Choose "External"
On the next screen type in App name (your choice), user support email (email you logged in with),
at bottom developer contact info (same email)
Save and continue

Next screen (Scopes) change nothing. Save and continue.

Next screen add test user. Same email. Save and continue.


Now click “Credentials” in the left-side panel (not “Create credentials”, which opens the wizard), then “+ CREATE CREDENTIALS” at top, then “OAuth client ID”.

Choose an application type of “Desktop App”, and fill in name (your choice)click “Create” 

This will then show you a client ID and client secret.

Copy the Client ID

Go back to the terminal window and right click to paste the Client ID

Now go back to the Google developers console and copy the Client Secret

Go back to terminal window and right click to paste the Client Secret

You will now Have a number of prompts:

scope – type 1 and then enter

root folder - Leave Blank and press Enter

service_account_file - Leave this blank and press enter

advanced config (y/n) - Type n and then enter

auto config - Type n and then enter

Copy the URL provided and paste into browser.

Enter your login details and paste token into terminal.

Configure this as a team drive? , type n and then enter

type y for Yes this is OK

You can type Q to exit or move on to tdrive

The rclone.conf file will be save in /.config/rclone

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
