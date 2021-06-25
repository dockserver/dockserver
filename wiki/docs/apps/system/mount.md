<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

## $i

* For the synstax to see

## rclone_cache into ram
Since our servers usually have a lot of ram that is not used at all, there is a possibility to save some ssd memory by putting the rclone_cache into the ram.

IMPORTANT!
You should give rclone at least 50GB cache!
This tutorial is only recommended if you have at least 128GB RAM.

For this we proceed as follows:
1. how much ram is available? in my example 128GB
2. the /dev/shm directory is the ram cache in linux, by default 1/2 of the ram
However, we can increase this.
3. vim /etc/fstab add
tmpfs /dev/shm tmpfs defaults,size=116g 0 0
:x
4. disable swap: swapoff -a
5. vim /opt/appdata/system/mount/mount.env
change TMPRCLONE=/ram_cache
change VFS_CACHE_MAX_SIZE=80G
6. reboot machine, check if /mnt/unionfs get still mounted, if not redeploy mount app

Translated with www.DeepL.com/Translator (free version)

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

* Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
