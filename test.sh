#! /usr/bin/env bash
set -euxo pipefail
(( ! $UID ))
(( ! $# ))
case $# in
  0)
    ARGS=default
    ;;
  *)
    ARGS="$@"
    ;;
esac

[[ -n "$DOCKER_TAG" ]]
[[ "$DOCKER_TAG" = native  ]] ||
[[ "$DOCKER_TAG" = generic ]] ||
exit 0

/usr/local/bin/entrypoint ${ARGS[@]} &
P="$!"
#sleep 31
sleep 19
kill "$P"
wait -n "$P" || :

