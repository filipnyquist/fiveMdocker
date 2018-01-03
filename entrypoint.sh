#!/bin/bash
sleep 2

cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`


# Update FiveM server
echo "Checking for update...."
masterfolder="https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
newestfxdata="$(curl $masterfolder | grep '<a href' | tail -1 | awk -F[\>\<] '{print $3}')"
latestfromdisk=$(cat "latestver.cache")
if [ ! ${latestfromdisk} == ${newestfxdata} ]; then
  echo "Not running latest version, updating!"
  rm -R fxdata && \
  cd fxdata && \
  wget ${masterfolder}${newestfxdata}fx.tar.xz && \
  tar xf fx.tar.xz && \
  rm ./fx.tar.xz && \
  cd .. && \
  chmod -R 777 ./fxdata && \
  echo ${newestfxdata} > latestver.cache
  echo "Done updating, starting server..."
fi

# Run the Server
${STARTUP}
