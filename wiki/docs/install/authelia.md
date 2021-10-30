# **Authelia**

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

# Authelia

<p align="center">
   <a href="https://www.authelia.com/">
      <img src="https://raw.githubusercontent.com/authelia/authelia/master/docs/images/authelia-title.png" alt="Authelia">
   </a>
</p>

[![Build](https://img.shields.io/buildkite/d6543d3ece3433f46dbe5fd9fcfaf1f68a6dbc48eb1048bc22/master?logo=buildkite&style=flat-square&color=brightgreen)](https://buildkite.com/authelia/authelia)
[![Go Report Card](https://goreportcard.com/badge/github.com/authelia/authelia?logo=go&style=flat-square)](https://goreportcard.com/report/github.com/authelia/authelia)

[![Docker Tag](https://img.shields.io/docker/v/authelia/authelia/latest?logo=docker&style=flat-square&color=blue&sort=semver)](https://microbadger.com/images/authelia/authelia)
[![Docker Size](https://img.shields.io/docker/image-size/authelia/authelia/latest?logo=docker&style=flat-square&color=blue&sort=semver)](https://hub.docker.com/r/authelia/authelia/tags)
[![GitHub Release](https://img.shields.io/github/release/authelia/authelia.svg?logo=github&style=flat-square&color=blue)](https://github.com/authelia/authelia/releases)

[![AUR source version](https://img.shields.io/aur/version/authelia?logo=arch-linux&label=authelia&style=flat-square&color=blue)](https://aur.archlinux.org/packages/authelia/)
[![AUR binary version](https://img.shields.io/aur/version/authelia-bin?logo=arch-linux&label=authelia-bin&style=flat-square&color=blue)](https://aur.archlinux.org/packages/authelia-bin/)
[![AUR development version](https://img.shields.io/aur/version/authelia-git?logo=arch-linux&label=authelia-git&style=flat-square&color=blue)](https://aur.archlinux.org/packages/authelia-git/)
[![LICENSE](https://img.shields.io/github/license/authelia/authelia?logo=apache&style=flat-square&color=blue)](https://www.apache.org/licenses/LICENSE-2.0)

[![Sponsor](https://img.shields.io/opencollective/all/authelia-sponsors?logo=Open%20Collective&label=financial%20contributors&style=flat-square&color=blue)](https://opencollective.com/authelia-sponsors)
[![Discord](https://img.shields.io/discord/707844280412012608?label=discord&logo=discord&style=flat-square&color=blue)](https://discord.authelia.com)
[![Matrix](https://img.shields.io/matrix/authelia:matrix.org?label=matrix&logo=matrix&style=flat-square&color=blue)](https://riot.im/app/#/room/#authelia:matrix.org)

---

Authelia is an open-source authentication and authorization server providing 2-factor authentication and single sign-on (SSO) for your applications via a web portal. It acts as a companion of reverse proxies like nginx, Traefik or HAProxy to let them know whether queries should pass through. Unauthenticated users are redirected to Authelia Sign-in portal instead.

## Features summary

Here is the list of the main available features:

- Several second factor methods:
  - **[Security Key (U2F)](https://www.authelia.com/docs/features/2fa/security-key)** with [Yubikey].
  - **[Time-based One-Time password](https://www.authelia.com/docs/features/2fa/one-time-password)**
    with [Google Authenticator].
  - **[Mobile Push Notifications](https://www.authelia.com/docs/features/2fa/push-notifications)**
    with [Duo](https://duo.com/).
- Password reset with identity verification using email confirmation.
- Single-factor only authentication method available.
- Access restriction after too many authentication attempts.
- Fine-grained access control per subdomain, user, resource and network.
- Support of basic authentication for endpoints protected by single factor.
- Beta support for [OpenID Connect](https://www.authelia.com/docs/configuration/identity-providers/oidc.html).
- Highly available using a remote database and Redis as a highly available KV store.
- Compatible with Kubernetes [ingress-nginx](https://github.com/kubernetes/ingress-nginx) controller out of the box.

For more details about the features, follow [Features](https://www.authelia.com/docs/features/).

If you want to know more about the roadmap, follow [Roadmap](https://www.authelia.com/docs/roadmap).

---

## Installation and Setup

- Authelia is deployed via the DockServer main menu, option

```sh
[ 1 ] Dockserver - Traefik + Authelia
```

Follow the Instructions

---

## Two-Factor Authentication (2FA) (Optional)

### Requirements

- Authelia deployed via DockServer menu
- Authenticator app ([Google Authenticator], [1Password], [Authy], [AndOTP], etc ...)

---

## 2FA Setup

Once Authelia is deployed, open it's configuration file:

```sh
sudo nano /opt/appdata/authelia/configuration.yml
```

Change the following:

```sh
totp:
  issuer: authelia
```

to:

```sh
totp:
  issuer: authelia
  period: 30
  skew: 1
```

Scroll further and change the following:

```sh
## one factor login
- domain: "*.YOURDOMAIN.COM"
  policy: one_factor
```

to this:

```sh
## two factor login
- domain: "*.YOURDOMAIN.COM"
  policy: two_factor
```

Save and exit by typing `CTRL + X`, then `Y`.

Restart the container:

```sh
sudo docker restart authelia
```

Now visit https://authelia.YOURDOMAIN.com and login with the username/password.
You'll be presented with a screen saying you need to register your device for TOTP.
Click **"Not registered yet?"** and a message will appear on screen saying **"An email has been sent to your address to complete the process"**.
As we didn't set up SMTP, no email has been sent. However, the link you need to continue the setup can be found here:

```sh
cat /opt/appdata/authelia/notification.txt
```

Copy and paste the URL found in this file into your browser, and then scan the QR code with your favourite OTP app ([Google Authenticator], [1Password], [Authy], [AndOTP], etc).
Follow the setup instructions in your app, and enter the 6-digit OTP in Authelia.

Congrats, you've got 2FA setup with Authelia!

---

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our <a href="https://discord.gg/FYSvu83caM">
  <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
  </a> for Support

---

## License

**Authelia** is **licensed** under the **[Apache 2.0]** license. The terms of the license are detailed
in [LICENSE](https://github.com/authelia/authelia/blob/master/LICENSE).

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fauthelia%2Fauthelia.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fauthelia%2Fauthelia?ref=badge_large)

[apache 2.0]: https://www.apache.org/licenses/LICENSE-2.0
[totp]: https://en.wikipedia.org/wiki/Time-based_One-time_Password_Algorithm
[security key]: https://www.yubico.com/about/background/fido/
[yubikey]: https://www.yubico.com/products/yubikey-hardware/yubikey4/
[auth_request]: https://nginx.org/en/docs/http/ngx_http_auth_request_module.html
[google authenticator]: https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en
[1password]: https://1password.com/
[authy]: https://authy.com/
[andotp]: https://play.google.com/store/apps/details?id=org.shadowice.flocke.andotp
[config.template.yml]: https://raw.githubusercontent.com/authelia/authelia/master/config.template.yml
[nginx]: https://www.nginx.com/
[traefik]: https://traefik.io/
[haproxy]: https://www.haproxy.org/
[docker]: https://docker.com/
[kubernetes]: https://kubernetes.io/
