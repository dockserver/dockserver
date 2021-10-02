# **DockServer**   
      
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

*Docker + Traefik with Authelia and Cloudflare Protection*

----

## Minimum Specs and Requirements 

* Ubuntu 18/20 or Debian 9/10
* 2 Cores
* 4GB Ram
* 20GB Disk Space

* A VPS/VM or Dedicated Server
* Domain
* [Cloudflare](https://dash.cloudflare.com/sign-up) account free tier

---

## Pre-Install

1. Login to your Cloudflare Account & goto DNS click on Add record.
1. Add 1 **A-Record** pointed to your server's ip.
1. Copy your [CloudFlare-Global-Key](https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys) and [CloudFlare-Zone-ID](https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys).

----

## Set the following on Cloudflare

1. `SSL = FULL` **( not FULL/STRICT )**
1. `Always on = YES`
1. `HTTP to HTTPS = YES`
1. `RocketLoader and Broli / Onion Routing = NO`
1. `TLS min = 1.2`
1. `TLS = v1.3`

----

### Easy Mode install

Run the following command:

```sh
sudo wget -qO- https://git.io/J3GDc | sudo bash
```

<details>
  <summary>Long commmand if the short one doesn't work.</summary>
  <br />

  ```sh
  sudo wget -qO- https://raw.githubusercontent.com/dockserver/dockserver/master/wgetfile.sh | sudo bash
  ```

</details>

----

## Latest Changes 🎉

<!--START_SECTION:activity-->
1. ❗️ Closed issue [#179](https://github.com/dockserver/dockserver/issues/179) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
2. ❗️ Closed issue [#1](https://github.com/dockserver/dockserver/issues/1) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
3. ❌ Closed PR [#7](https://github.com/dockserver/language/pull/7) in [dockserver/language](https://github.com/dockserver/language)
4. 🗣 Commented on [#7](https://github.com/dockserver/language/issues/7) in [dockserver/language](https://github.com/dockserver/language)
5. 💪 Opened PR [#7](https://github.com/dockserver/language/pull/7) in [dockserver/language](https://github.com/dockserver/language)
6. 🎉 Merged PR [#6](https://github.com/dockserver/language/pull/6) in [dockserver/language](https://github.com/dockserver/language)
7. 🗣 Commented on [#3](https://github.com/dockserver/language/issues/3) in [dockserver/language](https://github.com/dockserver/language)
8. 💪 Opened PR [#6](https://github.com/dockserver/language/pull/6) in [dockserver/language](https://github.com/dockserver/language)
9. 🗣 Commented on [#3](https://github.com/dockserver/language/issues/3) in [dockserver/language](https://github.com/dockserver/language)
10. 🎉 Merged PR [#5](https://github.com/dockserver/language/pull/5) in [dockserver/language](https://github.com/dockserver/language)
10. 🗣 Commented on [#15](https://github.com/dockserver/dockserver/issues/15) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
<!-- markdownlint-restore -->
<!--END_SECTION:activity-->

----

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/mrfret"><img src="https://avatars.githubusercontent.com/u/72273384?v=4?s=100" width="100px;" alt=""/><br /><sub><b>mrfret</b></sub></a><br /><a href="#infra-mrfret" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/dockserver/dockserver/commits?author=mrfret" title="Tests">⚠️</a> <a href="https://github.com/dockserver/dockserver/commits?author=mrfret" title="Code">💻</a> <a href="#content-mrfret" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/doob187"><img src="https://avatars.githubusercontent.com/u/60312740?v=4?s=100" width="100px;" alt=""/><br /><sub><b>doob187</b></sub></a><br /><a href="#infra-doob187" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/dockserver/dockserver/commits?author=doob187" title="Tests">⚠️</a> <a href="https://github.com/dockserver/dockserver/commits?author=doob187" title="Code">💻</a> <a href="#content-doob187" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/aelfa"><img src="https://avatars.githubusercontent.com/u/60222501?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Aelfa</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/commits?author=aelfa" title="Tests">⚠️</a> <a href="https://github.com/dockserver/dockserver/issues?q=author%3Aaelfa" title="Bug reports">🐛</a> <a href="#infra-aelfa" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/dockserver/dockserver/commits?author=aelfa" title="Code">💻</a> <a href="#content-aelfa" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/DrAg0n141"><img src="https://avatars.githubusercontent.com/u/44865095?v=4?s=100" width="100px;" alt=""/><br /><sub><b>DrAg0n141</b></sub></a><br /><a href="#infra-DrAg0n141" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/dockserver/dockserver/commits?author=DrAg0n141" title="Tests">⚠️</a> <a href="https://github.com/dockserver/dockserver/commits?author=DrAg0n141" title="Code">💻</a> <a href="#content-DrAg0n141" title="Content">🖋</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/Nossersvinet"><img src="https://avatars.githubusercontent.com/u/83166809?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Nossersvinet</b></sub></a><br /><a href="#infra-Nossersvinet" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/dockserver/dockserver/commits?author=Nossersvinet" title="Tests">⚠️</a> <a href="https://github.com/dockserver/dockserver/commits?author=Nossersvinet" title="Code">💻</a> <a href="#content-Nossersvinet" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/townsmcp"><img src="https://avatars.githubusercontent.com/u/14061617?v=4?s=100" width="100px;" alt=""/><br /><sub><b>townsmcp</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/issues?q=author%3Atownsmcp" title="Bug reports">🐛</a> <a href="https://github.com/dockserver/dockserver/commits?author=townsmcp" title="Tests">⚠️</a></td>
    <td align="center"><a href="https://github.com/Hawkinzzz"><img src="https://avatars.githubusercontent.com/u/24587652?v=4?s=100" width="100px;" alt=""/><br /><sub><b>hawkinzzz</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/issues?q=author%3AHawkinzzz" title="Bug reports">🐛</a> <a href="https://github.com/dockserver/dockserver/commits?author=Hawkinzzz" title="Tests">⚠️</a></td>
    <td align="center"><a href="https://github.com/clandorsdx"><img src="https://avatars.githubusercontent.com/u/48338663?v=4?s=100" width="100px;" alt=""/><br /><sub><b>clandorsdx</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/issues?q=author%3Aclandorsdx" title="Bug reports">🐛</a></td>
  </tr>
  <tr>
    <td align="center"><a href="http://streamnet.club"><img src="https://avatars.githubusercontent.com/u/5200101?v=4?s=100" width="100px;" alt=""/><br /><sub><b>cyb3rgh05t</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/commits?author=cyb3rgh05t" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/SilverSix311"><img src="https://avatars.githubusercontent.com/u/8906465?v=4?s=100" width="100px;" alt=""/><br /><sub><b>SilverSix311</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/commits?author=SilverSix311" title="Tests">⚠️</a> <a href="https://github.com/dockserver/dockserver/commits?author=SilverSix311" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/dan3805"><img src="https://avatars.githubusercontent.com/u/35934387?v=4?s=100" width="100px;" alt=""/><br /><sub><b>dan3805</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/commits?author=dan3805" title="Tests">⚠️</a> <a href="https://github.com/dockserver/dockserver/commits?author=dan3805" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/ramsaytc"><img src="https://avatars.githubusercontent.com/u/16809662?v=4?s=100" width="100px;" alt=""/><br /><sub><b>ramsaytc</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/commits?author=ramsaytc" title="Documentation">📖</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/RedDaut"><img src="https://avatars.githubusercontent.com/u/78737369?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Red Daut</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/commits?author=RedDaut" title="Code">💻</a> <a href="https://github.com/dockserver/dockserver/issues?q=author%3ARedDaut" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/brtbach"><img src="https://avatars.githubusercontent.com/u/24246495?v=4?s=100" width="100px;" alt=""/><br /><sub><b>brtbach</b></sub></a><br /><a href="https://github.com/dockserver/dockserver/commits?author=brtbach" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

----

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

* Join our <a href="https://discord.gg/FYSvu83caM">
        <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
    </a> for Support

----

## Code and Permissions

```sh
Copyright 2021 @dockserver
Code owner @dockserver
Dev Code @dockserver
Co-Dev -APPS- @CONTRIBUTORS-LIST
```
