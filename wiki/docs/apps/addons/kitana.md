<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# <img src="https://github.com/pannal/Kitana/raw/master/static/img/android-icon-36x36.png" align="left" height="36" style="vertical-align: center">Kitana

[![](https://img.shields.io/github/release/pannal/Kitana.svg?style=flat&label=current)](https://github.com/pannal/Kitana/releases/latest) [![Maintenance](https://img.shields.io/maintenance/yes/2021.svg)]() [![Slack Status](https://szslack.fragstore.net/badge.svg)](https://szslack.fragstore.net) [![master](https://img.shields.io/badge/master-stable-green.svg?maxAge=2592000)]()

A responsive Plex plugin web frontend

## Introduction

#### What is Kitana?

Kitana exposes your Plex plugin interfaces "to the outside world". It does that by authenticating against Plex.TV, then connecting to the Plex Media Server you tell it to, and essentially proxying the plugin UI.
It has full PMS connection awareness and allows you to connect locally, remotely, or even via relay.

It does that in a responsive way, so your Plugins are easily managable from your mobile phones for example, as well.

**_Running one instance of Kitana can serve infinite amounts of servers and plugins_** - you can even expose your Kitana instance to your friends, so they can manage their plugins as well, so they don't have to run their own Kitana instance.

Kitana was built for [Sub-Zero](https://github.com/pannal/Sub-Zero.bundle) originally, but handles other plugins just as well.

#### Isn't that a security concern?

Not at all. Without a valid Plex.TV authentication, Kitana can do nothing. All authentication data is stored serverside inside the current user's session storage (which is long running), so unwanted third party access to your server is virtually impossible.

#### The Plex plugin UIs still suck, though!

Yes, they do. Kitana does little to improve that, besides adding responsiveness to the whole situation.

Also, it isn't designed to. Kitana is an intermediate solution to the recent problem posed by Plex Inc. and their plans to phase out all UI-based plugins from the Plex Media Server environment.

## Features

- small footprint by using the CherryPy framework
- heavy caching for faster plugin handling
- full PMS connection awareness and automatic fallback in case the configured connection is lost
- fully responsive (CSS3)
- made to run behind reverse proxies (it doesn't provide its own HTTPS interface)
- fully cross-platform

## Screenshots

[Imgur Gallery](https://imgur.com/a/ovzXdjt)

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
