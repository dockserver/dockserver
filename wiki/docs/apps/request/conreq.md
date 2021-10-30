<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# Conreq Beta

[![Docker Pulls](https://img.shields.io/docker/pulls/roxedus/conreq?style=flat-square)](https://hub.docker.com/r/roxedus/conreq)
[![Docker Stars](https://img.shields.io/docker/stars/roxedus/conreq?style=flat-square)](https://hub.docker.com/r/roxedus/conreq)
[![Docker Hub](https://img.shields.io/badge/Open%20On-DockerHub-blue?style=flat-square)](https://hub.docker.com/r/roxedus/conreq)
[![Discord](https://img.shields.io/discord/440067432552595457?style=flat-square&label=Discord&logo=discord)](https://discord.gg/gQhGZzEjmX "Chat with the community and get realtime support!")

Conreq, a content requesting platform.

Want to join the community or have a question? Join us on [Discord](https://discord.gg/gQhGZzEjmX), discuss on [GitHub Discussions](https://github.com/Archmonger/Conreq/discussions), or see our planned features and roadmap on [GitHub Projects](https://github.com/Archmonger/Conreq/projects)!

Looking for more info? Are you a developer and want to contribute? Check out our [Documentation](https://archmonger.github.io/Conreq/)!

## Installation (Production Environment)

Install through **[Unraid Community Applications](https://squidly271.github.io/forumpost0.html)**, or **[Hotio](https://hotio.dev/containers/conreq/)**/**[SelfHosters](https://registry.hub.docker.com/r/roxedus/conreq) Docker**.

Here's a list of all available environment variables:

```python
# General Settings
TZ = "America/Los_Angeles"                # default: UTC (Timezone for log files, in "TZ Database" format)
BASE_URL = "requests"                     # default: None
APP_NAME = "RequestCentral"               # default: Conreq
APP_DESCRIPTION = "Get yo stuff!"         # default: Content Requesting
ARR_REFRESH_INTERNAL = "*/15"             # default: */1 (Cron minutes for Sonarr/Radarr library refresh)

# Data Storage
DATA_DIR = "/example/directory"           # default: /config (Defaults to "data" outside of docker)
DB_ENGINE = "MYSQL"                       # default: SQLITE3
MYSQL_CONFIG_FILE = "/config/mysql.cnf"   # default: None

# Security
SSL_SECURITY = "True"                     # default: False (True enables advanced SSL security features)
PWNED_VALIDATOR = "False"                 # default: True (False disables checking for compromised passwords)
X_FRAME_OPTIONS = "SAMEORIGIN"            # default: DENY (False disables X-Frame-Options)
ALLOWED_HOST = "192.168.0.199"            # default: * (Allows all hosts)
DEBUG = False                             # default: False (Disable security features, only enable this during development. Defaults to True outside of docker.)

# Email
EMAIL_USE_TLS = "False"                   # default: True
EMAIL_PORT = "465"                        # default: 587
EMAIL_HOST = "smtp-mail.outlook.com"      # default: smtp.gmail.com
EMAIL_HOST_USER = "myself@outlook.com"    # default: None
EMAIL_HOST_PASSWORD = "dogmemes123"       # default: None
```

# Screenshots

| ![Login screen](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/desktop_discover.png?raw=true) | ![Discover tab](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/desktop_more_info.png?raw=true) |
| :------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------: |
|                                               Discover (Desktop)                                               |                                               More Info (Desktop)                                               |

| ![More Info Tab](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/desktop_modal_episode_selection.png?raw=true) | ![Content Preview Modal](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/desktop_modal_filter.png?raw=true) |
| :----------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------------: |
|                                               Episode Selection Modal (Desktop)                                                |                                                   Filter Modal (Desktop)                                                    |

| ![Discover Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/desktop_modal_preview.png?raw=true) | ![More Info Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/desktop_sign_in.png?raw=true) |
| :------------------------------------------------------------------------------------------------------------------------: | :-------------------------------------------------------------------------------------------------------------------: |
|                                                  Preview Modal (Desktop)                                                   |                                                   Sign In (Desktop)                                                   |

| ![Discover Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/mobile_discover.png?raw=true) | ![More Info Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/mobile_more_info.png?raw=true) |
| :------------------------------------------------------------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------: |
|                                                  Discover (Mobile)                                                   |                                                   More Info (Mobile)                                                   |

| ![Discover Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/mobile_modal_episode_selection.png?raw=true) | ![More Info Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/mobile_modal_filter.png?raw=true) |
| :---------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------: |
|                                                  Episode Selection Modal (Mobile)                                                   |                                                   Filter Modal (Mobile)                                                   |

| ![Discover Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/mobile_registration.png?raw=true) | ![More Info Tab Mobile](https://github.com/Archmonger/Conreq/blob/main/misc/screenshots/mobile_sign_in.png?raw=true) |
| :----------------------------------------------------------------------------------------------------------------------: | :------------------------------------------------------------------------------------------------------------------: |
|                                                  Registration (Mobile)                                                   |                                                   Sign In (Mobile)                                                   |

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
