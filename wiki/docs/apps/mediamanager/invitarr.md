<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# Invitarr

Invitarr is a chatbot that invites discord users to plex. You can also automate this bot to invite discord users to plex once a certain role is given to a user or the user can also be added manually.

## Features

- Ability to invite users to plex from discord
- Fully automatic invites using roles
- Ability to kick users from plex if they leave the discord server or if their role is taken away.
- Ability to view the database in discord and to edit it.
- Fully configurable via discord.

## Commands:

```
.plexinvite <email>
This command is used to add an email to plex
.plexremove <email>
This command is used to remove an email from plex
.dbls
This command is used to list Invitarrs database
.dbadd <email> <@user>
This command is used to add exsisting users email and discord id to the DB.
.dbrm <position>
This command is used to remove a record from the Db. Use -db ls to determine record position. ex: -db rm 1
```

# Docker Setup & Start

1. Insatll Invitarr over Dockserver App Install Menu

2. Follow this [Guide](https://discordpy.readthedocs.io/en/latest/discord.html) on how to get the discord bot token. Note: When inviting the bot to your discord server make sure it has “Administrator” permission.

**Enable Intents else bot will not Dm users after they get the role.**
https://discordpy.readthedocs.io/en/latest/intents.html#privileged-intents

3. Open Portainer an edit Invitarr conatiner to add BOT TOKEN

Refer to the [Wiki](https://github.com/Sleepingpirates/Invitarr/wiki) for detailed steps.

# After bot has started

## Setup Commands:

```
.setupplex
This command is used to setup plex login.
.roleadd <@role>
These role(s) will be used as the role(s) to automatically invite user to plex
.setuplibs (optional)
This command is used to setup plex libraries. Default is set to all.
```

Refer to the [Wiki](https://github.com/Sleepingpirates/Invitarr/wiki) for detailed steps.

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
