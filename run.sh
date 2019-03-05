#! /bin/bash
set -exo nounset

[ $# -eq 1 ] || exit 1
T="`sed 's#/$##' <<< "$1"`"

trap "sudo docker rmi -f $T" 0

./systemctl.sh $T
sudo docker run -ti $T /bin/sh
