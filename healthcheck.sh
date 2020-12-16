#! /usr/bin/env bash
set -euxo pipefail

ps auxww | grep -q cpuminer
#curl --fail http://localhost:4048 || exit 1
nmap -p 4048 localhost | grep '^4048/tcp *open'

