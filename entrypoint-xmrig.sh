#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( $# == 1 ))
[[ -n "$1" ]]
exec 0<&-          # close stdin
exec 2>&1          # redirect stderr to stdout
renice -n -20 "$$" || : # max prio
/usr/local/bin/xmrig             \
-u "$1"                          \
-p docker                        \
-a cryptonightv7                 \
-o gulf.moneroocean.stream:10032 \
--keepalive                      \
--donate-level=0                 \
--cpu-priority 5                 \
--cpu-no-yield                   \
--nicehash                       \
--cuda                           \
--cuda-loader /usr/local/lib/libxmrig-cuda.so
#--pause-on-battery
#-c "/conf.d/$1.json"

