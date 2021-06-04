<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

# Authelia
Authelia is an open-source full-featured authentication server.

# Features
* Username/Password first factor authentication
* Time-based one-time passwords (TOTP) second factor authentication

# Installation and Setup
* Authelia is deployed via the DockServer main menu, option ```[ 1 ] Dockserver - Traefik + Authelia```

## Two-Factor Authentication (2FA) (Optional)
### Requirements
* Authelia deployed via DockServer menu
* Authenticator app (Google Authenticator, 1Password, Authy, etc...)

### 2FA Setup
Once Authelia is deployed, open it's configuration file:

```sudo nano /opt/appdata/authelia/configuration.yml```

Change the following:
```
totp:
  issuer: authelia
```
to:
```
totp:
  issuer: authelia
  period: 30
  skew: 1
```
Scroll further and change the following:
```
## one factor login
- domain: "*.YOURDOMAIN.COM"
  policy: one_factor
```
to this:
```
## two factor login
- domain: "*.YOURDOMAIN.COM"
  policy: two_factor
```
Save and exit by typing ```CTRL + X```, then ```Y```.

Restart the container:

```sudo docker restart authelia```

Now visit https://authelia.YOURDOMAIN.com and login with the username/password.  You'll be presented with a screen saying you need to register your device for TOTP.  Click **"Not registered yet?"** and a message will appear on screen saying **"An email has been sent to your address to complete the process"**.  As we didn't set up SMTP, no email has been sent.  However, the link you need to continue the setup can be found here:

```/opt/appdata/authelia/notification.txt```

Copy and paste the URL found in this file into your browser, and then scan the QR code with your favourite OTP app (Google Authenticator, 1Password, Authy, AndOTP, etc).  Follow the setup instructions in your app, and enter the 6-digit OTP in Authelia.

Congrats, you've got 2FA setup with Authelia!

## Support
Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

* Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support