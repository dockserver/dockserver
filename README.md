# **DockServer**

<p align="center">
    <a href="https://dockserver.io">
      <img src="https://raw.githubusercontent.com/dockserver/dockserver/master/wiki/docs/img/dockservee_animated.gif" alt="Join DockServer community">
    </a>
</p>

----- 

<p align="center">
    </br>
    <a href="https://discord.gg/FYSvu83caM">
        <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
    </a>
    </br>
    <img src="https://img.shields.io/liberapay/receives/dockserver.svg?logo=liberapay">
    </br>
    <a href="https://github.com/dockserver/dockserver/releases/latest">
        <img src="https://img.shields.io/github/v/release/dockserver/dockserver?include_prereleases&label=Latest%20Release&logo=github" alt="Latest Official Release on GitHub">
    </a>
    </br>
    <a href="https://github.com/dockserver/dockserver/blob/master/LICENSE">
        <img src="https://img.shields.io/github/license/dockserver/dockserver?label=License&logo=mit" alt="MIT License">
    </a>
    </br>
    <noscript>
      <a href="https://liberapay.com/dockserver/donate">
      <img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a>
    </noscript>
</p>


_Docker + Traefik with Authelia and Cloudflare Protection_


---

Some stats of [DOCKSERVER](https://dockserver.io)![metrics](https://raw.githubusercontent.com/dockserver/dockserver/master/github-metrics.svg)


--- 


## Minimum Specs and Requirements

- Stable: Ubuntu 18/20/21 or Debian 9/10/11

- CPU 2 Cores or 2 VCores
- 4GB Ram
- 20GB Disk Space

- A VPS/VM or Dedicated Server
- your Domain or buy a new [namecheap](https://www.namecheap.com/)
- [Cloudflare](https://dash.cloudflare.com/sign-up) account free tier

---


## For Testing

- [Hetzner Cloud](https://www.hetzner.com/de/cloud)
- [Digital Ocean](https://www.digitalocean.com/)
- [Vault](https://www.vultr.com/)


---


## Pre-Install

1. Login to your Cloudflare Account & goto DNS click on Add record.
1. Add 1 **A-Record** pointed to your server's ip.
1. Copy your [CloudFlare-Global-Key](https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys) and [CloudFlare-Zone-ID](https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys).


---


## Set the following on Cloudflare

1. `SSL = FULL` **( not FULL/STRICT )**
1. `Always on = YES`
1. `HTTP to HTTPS = YES`
1. `RocketLoader and Broli / Onion Routing = NO`
1. `TLS min = 1.2`
1. `TLS = v1.3`


---


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


---

<!--START_SECTION:activity-->

1. ❌ Closed PR [#456](https://github.com/dockserver/dockserver/pull/456) in [dockserver/dockserver](https://github.com/dockserver/dockserver)
<!--END_SECTION:activity-->


---

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

<noscript><a href="https://liberapay.com/dockserver/donate"><img alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg"></a></noscript>

---

## Code and Permissions

```sh
Copyright 2021 @dockserver
Code owner @dockserver
Dev Code @dockserver
Co-Dev -APPS- @CONTRIBUTORS-LIST
```

---

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

### Contributors

<table>
<tr>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/doob187>
            <img src=https://avatars.githubusercontent.com/u/60312740?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=doob187/>
            <br />
            <sub style="font-size:14px"><b>doob187</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/fscorrupt>
            <img src=https://avatars.githubusercontent.com/u/45659314?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=FSCorrupt/>
            <br />
            <sub style="font-size:14px"><b>FSCorrupt</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/drag0n141>
            <img src=https://avatars.githubusercontent.com/u/44865095?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=DrAg0n141/>
            <br />
            <sub style="font-size:14px"><b>DrAg0n141</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/aelfa>
            <img src=https://avatars.githubusercontent.com/u/60222501?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Aelfa/>
            <br />
            <sub style="font-size:14px"><b>Aelfa</b></sub>
        </a>
    </td>
</tr>
<tr>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/cyb3rgh05t>
            <img src=https://avatars.githubusercontent.com/u/5200101?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=cyb3rgh05t/>
            <br />
            <sub style="font-size:14px"><b>cyb3rgh05t</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/justinglock40>
            <img src=https://avatars.githubusercontent.com/u/23133649?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=justinglock40/>
            <br />
            <sub style="font-size:14px"><b>justinglock40</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/brtbach>
            <img src=https://avatars.githubusercontent.com/u/24246495?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=brtbach/>
            <br />
            <sub style="font-size:14px"><b>brtbach</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/mrfret>
            <img src=https://avatars.githubusercontent.com/u/72273384?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=mrfret/>
            <br />
            <sub style="font-size:14px"><b>mrfret</b></sub>
        </a>
    </td>
</tr>
<tr>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/renovate-bot>
            <img src=https://avatars.githubusercontent.com/u/25180681?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=WhiteSource Renovate/>
            <br />
            <sub style="font-size:14px"><b>WhiteSource Renovate</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/dan3805>
            <img src=https://avatars.githubusercontent.com/u/35934387?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=dan3805/>
            <br />
            <sub style="font-size:14px"><b>dan3805</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/ramsaytc>
            <img src=https://avatars.githubusercontent.com/u/16809662?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=ramsaytc/>
            <br />
            <sub style="font-size:14px"><b>ramsaytc</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/Nossersvinet>
            <img src=https://avatars.githubusercontent.com/u/83166809?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Nossersvinet/>
            <br />
            <sub style="font-size:14px"><b>Nossersvinet</b></sub>
        </a>
    </td>
</tr>
<tr>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/ookla-ariel-ride>
            <img src=https://avatars.githubusercontent.com/u/42082417?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Ookla, Ariel, Ride!/>
            <br />
            <sub style="font-size:14px"><b>Ookla, Ariel, Ride!</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/ImgBotApp>
            <img src=https://avatars.githubusercontent.com/u/31427850?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Imgbot/>
            <br />
            <sub style="font-size:14px"><b>Imgbot</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/RedDaut>
            <img src=https://avatars.githubusercontent.com/u/78737369?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Red Daut/>
            <br />
            <sub style="font-size:14px"><b>Red Daut</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/Shayne55434>
            <img src=https://avatars.githubusercontent.com/u/37595910?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Shayne/>
            <br />
            <sub style="font-size:14px"><b>Shayne</b></sub>
        </a>
    </td>
</tr>
<tr>
    <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
        <a href=https://github.com/townsmcp>
            <img src=https://avatars.githubusercontent.com/u/14061617?v=4 width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=James T/>
            <br />
            <sub style="font-size:14px"><b>James T</b></sub>
        </a>
    </td>
</tr>
</table>
<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->


