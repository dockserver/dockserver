<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)


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
