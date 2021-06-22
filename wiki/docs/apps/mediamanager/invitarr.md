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
- Fully configurable via a web portal

## Commands: 
```
-plex add <email>
This command is used to add an email to plex
-plex rm <email>
This command is used to remove an email from plex
-db ls
This command is used to list Invitarrs database
-db add <email> <@user>
This command is used to add exsisting users email and discord id to the DB.
-db rm <position>
This command is used to remove a record from the Db. Use -db ls to determine record position. ex: -db rm 1
```

Refer to the [Wiki](https://github.com/Sleepingpirates/Invitarr/wiki) for detailed steps.

**Enable Intents else bot will not Dm users after they get the role.**
https://discordpy.readthedocs.io/en/latest/intents.html#privileged-intents


**Default login**

```
User: admin
Pass: admin
```


## Screenshot
![bot](https://github.com/Sleepingpirates/Invitarr/blob/master/Screenshots/June_06.10.2020_07.08.21_PM.png)


## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

* Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
