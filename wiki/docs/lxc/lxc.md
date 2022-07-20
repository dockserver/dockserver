# **LXC CONTAINER**

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

## How to install DockServer on a Proxmox LXC container

This guide will take you through how to prepare Proxmox to install DockServer on an LXC.

##### **Key Points**

- This guide assumes you already have Proxmox installed and working. These instructions arw working on 6.4-6
- Do not use Debian as the Linux image. Networking is shocking and dies after a day or so due to NIC namespace. This guide was written for Ubuntu 20.04
- Apparmour must be disabled and deleted. If not, Authelia will fail at the password hashing stage.
- Your LXC must be a privileged container. Unpriviliged containers do not allow GPU passthrough which is needed for Plex transcoding.
- If you have local drives that you wish to mount, there are a couple of extra lines required in the xxx.conf file.
- These are the settings that I have set which I have found work well. Your own millage will vary depending on your setup.

##### **Guide**

1. Download Ubuntu template. Recommended version is Ubunto 20.04 Standard.
1. Create a new LXC container:
   1. **General** tab:
      1. Give the container a name in the 'Hostname' field.
      1. Remove the tick from 'Unprivileged container'.
      1. Set the password and confirm the password you wish to use for CLI access.
   1. **Template** tab:
      1. Choose the Ubuntu template.
   1. **Root Disk** tab:
      1. Set the disk size high enough to handle all DockServer apps. Allow room for expansion. I personally have this set to 500Gb.
   1. **CPU** tab:
      1. Add the number of cores that you want assigned to the LXC. Remember, you will probably have Plex installed in Docker, along with multiple other apps all demanding processing power. I personally have this set to 6 cores.
   1. **Memory** tab:
      1. Set the memory and swap size accordingly. Bear in mind the previous comment regarding number of CPU cores. I personally have this set to 8192MiB for both Memory and Swap.
   1. **Network** tab:
      1. Uncheck 'Firewall'.
      1. 'IPv4' and 'IPv6' - I set these both of these to DHCP and then reserve the MAC address in my routers DHCP server.
   1. **DNS** tab:
      1. Leave this tab alone.
   1. **Confirm** tab - check your settings and select 'Finish'.

##### **IMPORTANT NOTE - DO NOT START THE CONTAINER YET!**

Before starting the container, you need to set the following on the Options, Features tab:

1. Nesting
1. CIFS
1. NFS
1. Fuse

##### **GPU Passthrough**

Run the steps on the following guide to pass through the GPU (my own system is an Intel GPU so I followed each step exactly without any changes and everything worked):
https://forums.plex.tv/t/pms-installation-guide-when-using-a-proxmox-5-1-lxc-container/219728

NOTE: the above steps worked for Proxmox 6 however with changes to cgroup to cgroup2, the lxc conf file stated:
```
lxc.cgroup.devices.allow = c 226:0 rwm
lxc.cgroup.devices.allow = c 226:128 rwm
lxc.cgroup.devices.allow = c 29:0 rwm
lxc.autodev: 1
lxc.hook.autodev:/var/lib/lxc/100/mount_hook.sh
```
Changes this to:
```
lxc.cgroup2.devices.allow: a
227 lxc.cap.drop:
228 lxc.cgroup2.devices.allow: c 226:0 rwm
229 lxc.cgroup2.devices.allow: c 226:128 rwm
230 lxc.cgroup2.devices.allow: c 29:0 rwm
231 lxc.autodev: 1
232 lxc.hook.autodev: /var/lib/lxc/112/mount_hook.sh
```
Be mindful of the last line - change this to your correct container number rather than 112!

##### **Mounting external NFS Drives**

1. In _Datacenter_, _Storage_ add your NFS external drives.
1. Open a shell from the node.
1. Replace 120 with the container number:
   ```sh
   nano /etc/pve/lxc/120.conf
   ```
1. Add the following line('s) as appropriate to the drives you wish to gain access to:
   ```sh
   mp0: /mnt/pve/Media,mp=/mnt/Media
   ```
   ```sh
   mp1: /mnt/pve/Pictures,mp=/mnt/Pictures
   ```
   ```sh
   mp2: /mnt/pve/Music,mp=/mnt/Music
   ```

You can now start the container

---

##### **How to Disable and Delete Apparmour:**

Once the container is up and running and you have logged in:

1. Stop Apparmour service:
   ```sh
   systemctl stop apparmor
   ```
1. Disable Apparmor from starting on system boot:
   ```sh
   systemctl disable apparmor
   ```
1. Remove Apparmor package and dependencies:
   ```sh
   apt remove --assume-yes --purge apparmor
   ```

Now your LXC is ready to continue the install of DockServer

---

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our <a href="https://discord.gg/FYSvu83caM">
  <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
  </a> for Support
