#! /bin/bash
#! /usr/bin/env bash
set -euxo pipefail
(( ! UID ))
(( $# == 1 ))
[[ -n "$1" ]]
[[ -f "/conf.d/$1.json" ]]
exec 0<&-          # close stdin
exec 2>&1          # redirect stderr to stdout
renice -n -20 "$$" || : # max prio
/usr/local/bin/cpuminer -c "/conf.d/$1.json"

