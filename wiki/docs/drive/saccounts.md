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

# Manually Creating Service Accounts

This guide assumes you have already

- Created a project https://console.developers.google.com/
- OAuth Consent https://console.developers.google.com/apis/credentials/consent
- Client ID and Secret https://console.developers.google.com/apis/credentials
- Enabled "Google Drive API" on your Project.

Go to: https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts

    Choose your project
    Click "+create service account"
    name = your choice
    Click "Create and continue"
    Click "Done"
    To the right click actions>manage keys
    Add key
    key type = JSON
    Save JSON file to directory of your choice for later use
    repeat for as many as you wish to create
    rename all JSON files to: GDSA1, GDSA2, GDSA3, etc. with no file extension


Now you can proceed to this portion of the migration instruction:
https://dockserver.io/install/migration.html#mount-uploader

Or to mount setup:
https://dockserver.io/apps/system/mount.html#setup

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
