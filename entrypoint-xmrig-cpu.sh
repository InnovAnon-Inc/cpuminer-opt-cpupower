#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( $# == 1 ))
[[ -n "$1" ]]
exec 0<&-          # close stdin
exec 2>&1          # redirect stderr to stdout
renice -n -20 "$$" || : # max prio
/usr/local/bin/xmrig             \
-c "/conf.d/$1.json"
#-u "$1"                          \
#-p docker                        \
#-a cryptonightv7                 \
#-o gulf.moneroocean.stream:10032 \
#--keepalive                      \
#--rig-id=docker                  \
#--donate-level=0                 \
#--cpu-priority 5                 \
#--cpu-no-yield                   \
#--nicehash                       \
#--randomx-init=`nproc`           \
#--randomx-mode=fast              \
#--randomx-1gb-pages
##--pause-on-battery

