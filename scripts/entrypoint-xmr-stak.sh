#! /bin/bash
#! /usr/bin/env bash
set -euxo pipefail
(( ! UID ))
(( $# == 1 ))
[[ -n "$1" ]]
exec 0<&-          # close stdin
exec 2>&1          # redirect stderr to stdout
renice -n -20 "$$" || : # max prio
#/usr/local/bin/xmrig -c "/conf.d/$1.txt"
[[ -e "./$1.txt"    ]]
[[ -e "./pools.txt" ]]
/usr/local/bin/xmrig -c "./$1.txt"

