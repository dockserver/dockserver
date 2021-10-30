<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# Docker + Updater = Dockupdater

[![Release](https://img.shields.io/github/release/dockupdater/dockupdater.svg?style=flat-square)](https://hub.docker.com/r/dockupdater/dockupdater/)
[![Travis](https://img.shields.io/travis/dockupdater/dockupdater/master.svg)](https://travis-ci.org/dockupdater/dockupdater/)
[![Codecov](https://img.shields.io/codecov/c/github/dockupdater/dockupdater/master.svg)](https://codecov.io/gh/dockupdater/dockupdater)
[![Python Version](https://img.shields.io/pypi/pyversions/dockupdater.svg?style=flat-square)](https://pypi.org/project/dockupdater/)
[![Pypi Version](https://img.shields.io/pypi/v/dockupdater.svg?style=flat-square)](https://pypi.org/project/dockupdater/)
[![Latest version](https://images.microbadger.com/badges/version/dockupdater/dockupdater.svg)](https://microbadger.com/images/dockupdater/dockupdater)
[![Docker Pulls](https://img.shields.io/docker/pulls/dockupdater/dockupdater.svg?style=flat-square)](https://hub.docker.com/r/dockupdater/dockupdater/)
[![Layers](https://images.microbadger.com/badges/image/dockupdater/dockupdater.svg)](https://microbadger.com/images/dockupdater/dockupdater)

Automatically keep your docker services and your docker containers up-to-date with the latest version.

## Overview

**Dockupdater** will monitor (all or specified by a label) running docker containers and running service (in Docker swarm) and update them to the (latest or tagged) available image in the remote registry.

- Push your image to your registry and simply wait your defined interval for dockupdater to find the new image and redeploy your container autonomously.
- Notify you via many platforms courtesy of [Apprise](https://github.com/caronc/apprise)
- Use with Docker swarm to update services on the latest available version
- Limit your server SSH access
- Useful to keep 3rd party container up-to-date

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
