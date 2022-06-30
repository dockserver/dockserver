# **RAM rclone_cache**

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

## rclone_cache into ram

Since our servers usually have a lot of ram that is not used at all, there is a possibility to save some ssd memory by putting the rclone_cache into the ram.

# IMPORTANT! | Only for advanced Users

You should give rclone at least 50GB cache!
This tutorial is only recommended if you have at least 128GB RAM.

# Setup

For this we proceed as follows:

1. how much ram is available? in my example 128GB
1. the /dev/shm directory is the ram cache in linux, by default 1/2 of the ram
However, we can increase this.
1. `sudo nano /etc/fstab`
 add
`tmpfs /dev/shm tmpfs defaults,size=116g 0 0`

1. disable swap: `sudo swapoff -a`
1. `sudo nano /opt/appdata/system/mount/mount.env`

1. change `TMPRCLONE=/ram_cache`
1. change `VFS_CACHE_MAX_SIZE=80G`

1. reboot machine `sudo reboot -n`
1. check if /mnt/unionfs get still mounted, if not redeploy mount app ( `sudo mountpoint /mnt/unionfs/` & `sudo docker log mount` )

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

* Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
