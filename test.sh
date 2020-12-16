#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( ! $# ))

[[ -n "$DOCKER_TAG" ]]
[[ "$DOCKER_TAG" = native  ]] ||
[[ "$DOCKER_TAG" = generic ]] ||
exit 0

/usr/local/bin/entrypoint default &
P="$!"
#sleep 31
sleep 19
kill "$P"
wait -n "$P" || :

