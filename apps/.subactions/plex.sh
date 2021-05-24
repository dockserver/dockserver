#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Copyright (c) 2020, MrDoob
# All rights reserved.
####################################
typed=plex
container=$($(command -v docker) ps -aq --format '{{.Names}}' | grep -x ${typed})
runningcheck=$($(command -v docker) container inspect -f '{{.State.Running}}' ${typed})
if [[ $runningcheck == "true" ]];then
   if [[ $container == ${typed} ]];then
      docker=${typed}
      for i in ${docker}; do
          $(command -v docker) exec $i rm -rf /beignet
          $(command -v docker) exec $i bash -c "apt update && apt -y install cmake pkg-config python ocl-icd-dev libegl1-mesa-dev"
          $(command -v docker) exec $i bash -c "apt update && apt -y install libxfixes-dev libxext-dev llvm-7-dev clang-7 libclang-7-dev ocl-icd-opencl-dev libdrm-dev"
          $(command -v docker) exec $i bash -c "apt update && apt -y install  libtinfo-dev libedit-dev zlib1g-dev build-essential git"
          $(command -v docker) exec $i git clone --branch comet-lake https://github.com/rcombs/beignet.git 1>/dev/null 2>&1
          $(command -v docker) exec $i bash -c "mkdir /beignet/build/ && cd /beignet/build && cmake -DLLVM_INSTALL_DIR=/usr/lib/llvm-7/bin .. && make -j8 && make install"
          $(command -v docker) restart $i
      done
   fi
fi
#EOF