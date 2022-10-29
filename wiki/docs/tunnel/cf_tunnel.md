![Image of DockServer](/img/container_images/docker-cloudflared.png)

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


# Cloudflared

## Cloudflare Tunnel

Easily expose your locally hosted services securly, using Cloudflare Tunnel!

**IMPORTANT** - A Cloudflare Tunnel can only be used with apps that can be accessed over port 80 and 443.

### Setup

1. `mkdir /opt/appdata/cloudflared`
2. `chmod 777 /opt/appdata/cloudflared`
3. `docker pull cloudflare/cloudflared:latest`
4. `docker run -it --rm -v /opt/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel login`

![Image of Cloudflared](/img/cloudflared/login.png)

- Follow the link provided and log into your Cloudflare account.
- Authorize Cloudflared to access your domain.

![Image of Cloudflared](/img/cloudflared/authorize.png)

![Image of Cloudflared](/img/cloudflared/success.png)

5. `docker run -it --rm -v /opt/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel create tunnel-YOUR_TUNNEL_NAME`

- Change `tunnel-YOUR_TUNNEL_NAME` to wathever you like.

![Image of Cloudflared](/img/cloudflared/tunnel.png)

6. `cd /opt/appdata/cloudflared`</br></br>
   `wget https://raw.githubusercontent.com/dockserver/dockserver/863a2a0dacaf1a9f076d236f1f918dbbed138865/traefik/templates/cloudflared/config.yaml`</br></br>
   `nano config.yaml`

- Edit `config.yaml` and add the TUNNEL_UUID.

#### CONFIG

```yaml
# Cloudflared
tunnel: TUNNEL_UUID 
credentials-file: /home/nonroot/.cloudflared/TUNNEL_UUID.json

# NOTE: You should only have one ingress tag, so if you uncomment one block comment the others

# forward all traffic to Reverse Proxy w/ SSL
#ingress:
  #- service: https://${SERVERIP}:443
    #originRequest:
      #originServerName: dns-cloudflare.acme
      
#forward all traffic to Reverse Proxy w/ SSL and no TLS Verify
ingress:
  - service: https://traefik:443
    originRequest:
      noTLSVerify: true

#ingress:
#  - hostname: ssh.domain.com
#    service: ssh://SSHIP:PORT
#  - service: https://traefik:443
#    originRequest:
#      noTLSVerify: true
# forward all traffic to reverse proxy over http
#ingress:
#  - service: http://REVERSEPROXYIP:PORT
```

#### CONFIG VALUES
|Setting   |Default|Description|
|----------|-------|-----------|
|`tunnel`    |`null` |TUNNEL_UUID retrieved in STEP 6.|
|`credentials-file`    |`null` |TUNNEL_UUID retrieved in STEP 6.|

Example: 

```yaml
# Cloudflared
tunnel: a8fc25aa-xxxx-450b-8c59-xxxxxx 
credentials-file: /home/nonroot/.cloudflared/a8fc25aa-xxxx-450b-8c59-xxxxxx.json

# NOTE: You should only have one ingress tag, so if you uncomment one block comment the others

# forward all traffic to Reverse Proxy w/ SSL
#ingress:
  #- service: https://${SERVERIP}:443
    #originRequest:
      #originServerName: dns-cloudflare.acme
      
#forward all traffic to Reverse Proxy w/ SSL and no TLS Verify
ingress:
  - service: https://traefik:443
    originRequest:
      noTLSVerify: true
.
.
.
```

7. `docker run -it --rm -v /opt/appdata/cloudflared:/home/nonroot/.cloudflared/ cloudflare/cloudflared:latest tunnel route dns tunnel-YOUR_TUNNEL_NAME your_domain.com`

- Change `tunnel-YOUR_TUNNEL_NAME` to the name you choosed in STEP 5.
- Change `your_domain.com` to your domain you gave access to in STEP 4.

![Image of Cloudflared](/img/cloudflared/created.png)



![Image of Cloudflared](/img/cloudflared/record.png)

Et voilà! Your tunnel has been created.

**IMPORTANT** - If you already have records for your apps, you need to change the target to the tunnel target.

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support