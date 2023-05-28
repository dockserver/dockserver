#!/usr/bin/with-contenv bash
###########################################
# All rights reserved.                    #
# started from Zero                       #
# Docker owned dockserver                 #
# Docker Maintainer dockserver            #
###########################################
# Title:      LSPCI || IGPU & NVIDIA GPU  #
# Author(s):  dockserver                  #
# GNU:        General Public License v3.0 #
###########################################
# shellcheck disable=SC2003
# shellcheck disable=SC2006
# shellcheck disable=SC2207
# shellcheck disable=SC2012
# shellcheck disable=SC2086
# shellcheck disable=SC2196
# shellcheck disable=SC2046

GVID=$(id $(whoami) | grep -qE 'video' && echo true || echo false)
GCHK=$(grep -qE video /etc/group && echo true || echo false)
DEVT=$(ls /dev/dri 1>/dev/null 2>&1 && echo true || echo false)
IGPU=$(lspci | grep -i --color 'vga\|display\|3d\|2d' | grep -E 'ntel' 1>/dev/null 2>&1 && echo true || echo false)
NGPU=$(lspci | grep -i --color 'vga\|display\|3d\|2d' | grep -E 'NVIDIA' 1>/dev/null 2>&1 && echo true || echo false)
OSVE=$(
    . /etc/os-release
    echo $ID
)
DIST=$(
    . /etc/os-release
    echo $ID$VERSION_ID
)
VERS=$(
    . /etc/os-release
    echo $UBUNTU_CODENAME
)

igpuhetzner() {
    HMOD=$(ls /etc/modprobe.d/ | grep -qE 'hetzner' && echo true || echo false)
    ITEL=$(cat /etc/modprobe.d/blacklist-hetzner.conf | grep -qE '#blacklist i915' && echo true || echo false)
    IMOL1=$(cat /etc/default/grub | grep -qE '#GRUB_CMDLINE_LINUX_DEFAULT' && echo true || echo false)
    IMOL2=$(cat /etc/default/grub.d/hetzner.cfg | grep -qE '#GRUB_CMDLINE_LINUX_DEFAULT' && echo true || echo false)
    INTE=$(ls /usr/bin/intel_gpu_* 1>/dev/null 2>&1 && echo true || echo false)
    VIFO=$(command -v vainfo 1>/dev/null 2>&1 && echo true || echo false)

    if [[ $HMOD == "false" ]]; then exit; fi
    if [[ $ITEL == "false" ]]; then sed -i "s/blacklist i915/#blacklist i915/g" /etc/modprobe.d/blacklist-hetzner.conf; fi
    if [[ $IMOL1 == "false" ]]; then sed -i "s/GRUB_CMDLINE_LINUX_DEFAUL/#GRUB_CMDLINE_LINUX_DEFAUL/g" /etc/default/grub; fi
    if [[ $IMOL2 == "false" ]]; then sed -i "s/GRUB_CMDLINE_LINUX_DEFAUL/#GRUB_CMDLINE_LINUX_DEFAUL/g" /etc/default/grub.d/hetzner.cfg; fi
    if [[ $OSVE == "ubuntu" && $VERS == "focal" ]]; then
        if [[ $IMOL1 == "true" && $IMOL2 == "true" && $ITEL == "true" ]]; then sudo update-grub; fi
    else
        if [[ $IMOL1 == "true" && $IMOL2 == "true" && $ITEL == "true" ]]; then sudo grub-mkconfig -o /boot/grub/grub.cfg; fi
    fi
    if [[ $GCHK == "false" ]]; then groupadd -f video; fi
    if [[ $GVID == "false" ]]; then usermod -aG video $(whoami); fi
    if [[ $VIFO == "false" ]]; then $(command -v apt) install vainfo -yqq; fi
    if [[ $INTE == "false" && $IGPU == "true" ]]; then $(command -v apt) update -yqq && $(command -v apt) install intel-gpu-tools -yqq; fi
    endcommand
    if [[ $IMOL1 == "true" && $IMOL2 == "true" && $ITEL == "true" && $GVID == "true" && $DEVT == "true" ]]; then echo "Intel IGPU is working"; else echo "Intel IGPU is not working"; fi
}

nvidiagpu() {
    RCHK=$(ls /etc/apt/sources.list.d/ 1>/dev/null 2>&1 | grep -qE 'nvidia' && echo true || echo false)
    DREA=$(pidof dockerd 1>/dev/null 2>&1 && echo true || echo false)
    CHKN=$(ls /usr/bin/nvidia-smi 1>/dev/null 2>&1 && echo true || echo false)
    DCHK=$(cat /etc/docker/daemon.json | grep -qE 'nvidia' && echo true || echo false)

    ## bypass to check supported OS
    subos
    if [[ $RCHK == "false" ]]; then
        curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
        curl -s -L https://nvidia.github.io/libnvidia-container/$DIST/libnvidia-container.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    fi
    if [[ $CHKN != "true" ]]; then
        package_list="nvidia-container-toolkit nvidia-container-runtime"
        packageup="update upgrade dist-upgrade"
        for i in ${packageup}; do
            $(command -v apt) $i -yqq 1>/dev/null 2>&1
        done
        for i in ${package_list}; do
            $(command -v apt) install $i -yqq 1>/dev/null 2>&1
        done
    fi
    if [[ $DCHK == "false" ]]; then

    mkdir -p /etc/systemd/system/docker.service.d
    tee /etc/systemd/system/docker.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --host=fd:// --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
EOF
    systemctl daemon-reload && systemctl restart docker

    tee /etc/docker/daemon.json <<EOF
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
    pkill -SIGHUP dockerd
    fi

    if [[ $GVID == "false" ]]; then usermod -aG video $(whoami); fi
    if [[ $DREA == "true" ]]; then pkill -SIGHUP dockerd; fi
    endcommand
    if [[ $DREA == "true" && $DCHK == "true" && $CHKN == "true" && $DEVT != "false" ]]; then echo "nvidia-container-runtime is working"; else echo "nvidia-container-runtime is not working"; fi
}

subos() {
    NSO=$(curl -s -L https://nvidia.github.io/nvidia-docker/$DIST/nvidia-docker.list)
    NSOE=$(echo ${NSO} | grep -E 'Unsupported')
    if [[ $NSOE != "" ]]; then
        printf "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      NVIDIA ❌ ERROR
      NVIDIA don't support your running Distribution
      Installed Distribution = ${DIST}
      Please visit the link below to see all supported Distributionen
      NVIDIA ❌ ERROR
      ${NSO}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
        read -erp "Confirm Info | Type confirm & PRESS [ENTER]" input </dev/tty
        if [[ "$input" = "confirm" ]]; then clear && exit; else subos; fi
    fi
}
endcommand() {
    if [[ $DEVT != "false" ]]; then
        $(command -v chmod) -R 750 /dev/dri
    else
        echo ""
        printf "\033[0;31m You need to restart the server to get access to /dev/dri\033[0m\n"
        echo ""
        read -p "Type confirm when you have read the message: " input
        if [[ "$input" = "confirm" ]]; then exit; else endcommand; fi
    fi
}
while true; do
    if [[ $IGPU == "true" && $NGPU == "false" ]]; then
        igpuhetzner && break && exit
    elif [[ $NGPU == "true" && $IGPU == "true" ]]; then
        nvidiagpu && break && exit
    elif [[ $NGPU == "true" && $IGPU == "false" ]]; then
        nvidiagpu && break && exit
    else break && exit; fi
done
#"
