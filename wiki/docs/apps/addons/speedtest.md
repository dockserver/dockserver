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


# Speedtest Tracker

[![Docker pulls](https://img.shields.io/docker/pulls/henrywhitaker3/speedtest-tracker?style=flat-square)](https://hub.docker.com/r/henrywhitaker3/speedtest-tracker) [![GitHub Workflow Status](https://img.shields.io/github/workflow/status/henrywhitaker3/Speedtest-Tracker/Stable?label=master&logo=github&style=flat-square)](https://github.com/henrywhitaker3/Speedtest-Tracker/actions) [![GitHub Workflow Status](https://img.shields.io/github/workflow/status/henrywhitaker3/Speedtest-Tracker/Dev?label=dev&logo=github&style=flat-square)](https://github.com/henrywhitaker3/Speedtest-Tracker/actions) [![last_commit](https://img.shields.io/github/last-commit/henrywhitaker3/Speedtest-Tracker?style=flat-square)](https://github.com/henrywhitaker3/Speedtest-Tracker/commits) [![issues](https://img.shields.io/github/issues/henrywhitaker3/Speedtest-Tracker?style=flat-square)](https://github.com/henrywhitaker3/Speedtest-Tracker/issues) [![commit_freq](https://img.shields.io/github/commit-activity/m/henrywhitaker3/Speedtest-Tracker?style=flat-square)](https://github.com/henrywhitaker3/Speedtest-Tracker/commits) ![version](https://img.shields.io/badge/version-v1.10.4-success?style=flat-square) [![license](https://img.shields.io/github/license/henrywhitaker3/Speedtest-Tracker?style=flat-square)](https://github.com/henrywhitaker3/Speedtest-Tracker/blob/master/LICENSE)

This program runs a speedtest check every hour and graphs the results. The back-end is written in [Laravel](https://laravel.com/) and the front-end uses [React](https://reactjs.org/). It uses the [Ookla's speedtest cli](https://www.speedtest.net/apps/cli) package to get the data and uses [Chart.js](https://www.chartjs.org/) to plot the results.

A demo can be found [here](https://speedtest.henrywhitaker.com)

Disclaimer: You will need to accept Ookla's EULA and privacy agreements in order to use this container.

![speedtest](https://user-images.githubusercontent.com/36062479/78822484-a82b8300-79ca-11ea-8525-fdeae496a0bd.gif)

## Features

- Automatically run a speedtest every hour
- Graph of previous speedtests going back x days
- Backup/restore data in JSON/CSV format
- Slack/Discord/Telegram notifications
- [healthchecks.io](https://healthchecks.io) integration
- Organizr integration

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
