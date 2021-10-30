**Diun**

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
    <a href="https://github.com/dockserver/dockserver/blob/main/LICENSE">
        <img src="https://img.shields.io/github/license/dockserver/dockserver?label=License&logo=gnu" alt="GNU General Public License">
    </a>
</p>

## Diun

<p align="center"><a href="https://crazy-max.github.io/diun/" target="_blank"><img height="128" src="https://raw.githubusercontent.com/crazy-max/diun/master/.res/diun.png"></a></p>

<p align="center">
  <a href="https://github.com/crazy-max/diun/releases/latest"><img src="https://img.shields.io/github/release/crazy-max/diun.svg?style=flat-square" alt="GitHub release"></a>
  <a href="https://github.com/crazy-max/diun/releases/latest"><img src="https://img.shields.io/github/downloads/crazy-max/diun/total.svg?style=flat-square" alt="Total downloads"></a>
  <a href="https://github.com/crazy-max/diun/actions?workflow=build"><img src="https://img.shields.io/github/workflow/status/crazy-max/diun/build?label=build&logo=github&style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/diun/"><img src="https://img.shields.io/docker/stars/crazymax/diun.svg?style=flat-square&logo=docker" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/diun/"><img src="https://img.shields.io/docker/pulls/crazymax/diun.svg?style=flat-square&logo=docker" alt="Docker Pulls"></a>
  <br /><a href="https://goreportcard.com/report/github.com/crazy-max/diun"><img src="https://goreportcard.com/badge/github.com/crazy-max/diun?style=flat-square" alt="Go Report"></a>
  <a href="https://www.codacy.com/app/crazy-max/diun"><img src="https://img.shields.io/codacy/grade/f2ef980c87d247ce8a8dbc98a8f4f434.svg?style=flat-square" alt="Code Quality"></a>
  <a href="https://codecov.io/gh/crazy-max/diun"><img src="https://img.shields.io/codecov/c/github/crazy-max/diun?logo=codecov&style=flat-square" alt="Codecov"></a>
  <a href="https://github.com/sponsors/crazy-max"><img src="https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square" alt="Become a sponsor"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

---

## What is Diun?

**D**ocker **I**mage **U**pdate **N**otifier is a CLI application written in [Go](https://golang.org/) and delivered as a
[single executable](https://github.com/crazy-max/diun/releases/latest) (and a [Docker image](https://github.com/crazy-max/diun/blob/master/docs/install/docker.md))
to receive notifications when a Docker image is updated on a Docker registry.

With Go, this can be done with an independent binary distribution across all platforms and architectures that Go supports.
This support includes Linux, macOS, and Windows, on architectures like amd64, i386, ARM, PowerPC, and others.

## Features

- Allow to watch a Docker repository and report new tags
- Include and exclude filters with regular expression for tags
- Internal cron implementation through go routines
- Worker pool to parallelize analyses
- Allow overriding image os and architecture
- [Docker](https://github.com/crazy-max/diun/blob/master/docs/providers/docker.md), [Swarm](https://github.com/crazy-max/diun/blob/master/docs/providers/swarm.md), [Kubernetes](https://github.com/crazy-max/diun/blob/master/docs/providers/kubernetes.md),
  [Dockerfile](https://github.com/crazy-max/diun/blob/master/docs/providers/dockerfile.md) and [File](https://github.com/crazy-max/diun/blob/master/docs/providers/file.md) providers available
- Get notified through Gotify, Mail, Slack, Telegram and [more](https://github.com/crazy-max/diun/blob/master/docs/config/index.md#reference)
- [Healthchecks Support](https://github.com/crazy-max/diun/blob/master/docs/config/watch.md#healthchecks) to monitor Diun watcher
- Enhanced logging
- Official [Docker image](https://hub.docker.com/r/crazymax/diun/)) to receive notifications when a Docker image is updated on

---

## Install Diun

1. Open dockserver
   ```sh
   dockserver
   ```
1. ```sh
   [ 2 ] DockServer - Applications
   ```
1. ```sh
   addons
   ```
1. ```sh
   diun
   ```
1. Finish

Diun will be installed full automatically.
The installation folder is

```sh
/opt/appdata/diun
```

---

## About

**Diun** is a CLI application written in [Go](https://golang.org/) and delivered as a
[single executable](https://github.com/crazy-max/diun/releases/latest) (and a
[Docker image](https://hub.docker.com/r/crazymax/diun/)) to receive notifications when a Docker image is updated on
a Docker registry.

![](https://raw.githubusercontent.com/crazy-max/diun/master/.res/screenshot.png)

## Documentation

Documentation can be found on https://crazy-max.github.io/diun/

## How can I help?

All kinds of contributions are welcome :raised_hands:! The most basic way to show your support is to star :star2: the
project, or to raise issues :speech_balloon: You can also support this project by
[**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) :clap: or by making a
[Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely! :rocket:

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See [LICENSE](https://github.com/crazy-max/diun/blob/master/LICENSE) for more details

---

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our <a href="https://discord.gg/FYSvu83caM">
  <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
  </a> for Support
