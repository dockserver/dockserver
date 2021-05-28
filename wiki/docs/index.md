<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

*Docker + Traefik with Authelia and Cloudflare Protection*

## Minimum Specs

* Ubuntu 18/20 or Debian 9/10
* 2 Cores
* 4GB Ram
* 20GB Disk Space

## Requirements

* A VPS/VM or Dedicated Server

* Domain

* [Cloudflare](https://dash.cloudflare.com/sign-up) account free tier

## Pre-Install

1. Login to your Cloudflare Account & goto DNS click on Add record.
2. Add 1 **A-Record** pointed to your server's ip.
3. Copy your [CloudFlare-Global-Key](https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys) and [CloudFlare-Zone-ID](https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys).

### Set the following on Cloudflare

1. `SSL = FULL` **( not FULL/STRICT )**
2. `Always on = YES`
3. `HTTP to HTTPS = YES`
4. `RocketLoader and Broli / Onion Routing = NO`
5. `TLS min = 1.2`
6. `TLS = v1.3`

## Easy Mode install

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

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

* Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support

## Code and Permissions

```sh
Copyright 2021 @dockserver
Code owner @dockserver
Dev Code @dockserver
Co-Dev -APPS- @CONTRIBUTORS-LIST
```

----


<!--START_SECTION:activity-->
1. 🎉 Merged PR [#17](https://github.com/dockserver/dockserver/pull/17) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
2. 🗣 Commented on [#2](https://github.com/dockserver/dockserver/issues/2) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
3. 💪 Opened PR [#17](https://github.com/dockserver/dockserver/pull/17) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
4. 🗣 Commented on [#2](https://github.com/dockserver/dockserver/issues/2) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
5. 🎉 Merged PR [#16](https://github.com/dockserver/dockserver/pull/16) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
6. 🗣 Commented on [#15](https://github.com/dockserver/dockserver/issues/15) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
7. 💪 Opened PR [#16](https://github.com/dockserver/dockserver/pull/16) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
8. 🗣 Commented on [#15](https://github.com/dockserver/dockserver/issues/15) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
9. 🗣 Commented on [#15](https://github.com/dockserver/dockserver/issues/15) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
10. 🎉 Merged PR [#15](https://github.com/dockserver/dockserver/pull/15) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
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
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
