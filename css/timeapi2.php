#!/busybox/sh

echo "Content-Type: text/html; charset=UTF-8"
echo

echo $(/busybox/timestamp | /busybox/sed -E 's/(...)$/\.\1/')
