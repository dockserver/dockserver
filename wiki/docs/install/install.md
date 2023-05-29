### **DockServer**


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

### Update System before you begin with installation

```sh
sudo apt-get update -yqq
sudo apt-get upgrade -yqq
sudo apt-get autoclean -yqq
```

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


### Open the dockserver Interface 

```sh
sudo dockserver -i
```

- Now the preinstall runs full automatic
- If not triggered by installer, please restart your server.

---

### Install Traefik & Authelia first 

**Note** ( critical step | without dockserver will not work )

---

After deployment of Traefik & Authelia you have to install [mount](https://dockserver.io/apps/system/mount.html), then you can install any app.

1. Open the dockserver Interface again 
2. Type 2 
3. Type 1
now you can see all the apps sections.


