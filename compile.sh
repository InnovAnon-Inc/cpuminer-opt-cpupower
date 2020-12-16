#! /usr/bin/env bash
set -euxo pipefail
(( $UID ))
(( ! $# ))

rm    -v -f config.status
chmod -v +x autogen.sh
./autogen.sh
 /configure.sh
make -j`nproc`

