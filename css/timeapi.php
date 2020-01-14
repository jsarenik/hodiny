#!/bin/sh

export PATH=/busybox
echo "Content-Type: text/html; charset=UTF-8"
echo

T=$(timestamp | tr -d . | cut -b -14 | sed -E 's/(.)$/\.\1/g')

cat <<EOF
var server = $T; var dtest = new Date();
EOF
