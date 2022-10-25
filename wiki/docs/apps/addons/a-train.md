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


# A-Train

A-Train is the official Autoscan trigger that listens for changes within Google Drive.
It is the successor of Autoscan's Bernard trigger, which unfortunately contains enough logic errors to prompt a rewrite.

- Supports **Shared Drives**
- **Service Account**-based authentication
- Does not support My Drive
- Does not support encrypted files
- Does not support alternative authentication methods

## Prerequisites

A-Train works exclusively through [Shared Drives](https://support.google.com/a/answer/7212025) and [Service Accounts](https://cloud.google.com/iam/docs/service-accounts).
Shared Drives can only be created on GSuite / Google Workspace accounts.

First, you must [create a Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts#iam-service-accounts-create-console) and [create a JSON key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating_service_account_keys).
Afterwards, if you do not have one already, [create a Shared Drive within Google Drive](https://support.google.com/a/users/answer/9310249) and then add the email address of the Service Account to the Shared Drive (with `Reader` permission).

## Setup A-Train

- Install A-Train from Docksever Addons Menu.

- Stop the container.

`sudo docker stop a-train`

- Head over to the appdata folder.

`cd /opt/appdata/a-train/data/`

- Create a a-train.toml file.

`sudo nano a-train.toml`

- Copy / Paste the following config into the created file from previous step and edit it to your needs.

```
[autoscan]
url = "http://autoscan:3030"
username = "your_username"
password = "your_password"

[drive]
account = "./service-account.json"
drives = ["shared_drive_id", ....]
```

- Create a service-account.json. 

[create a Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts#iam-service-accounts-create-console) and [create a JSON key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating_service_account_keys).

- Copy it in ```/opt/appdata/a-train/data/```

That´s it... Now you can start A-Train with ```sudo docker start a-train``` and check logs ```sudo docker logs -f a-train``` for errors.

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
