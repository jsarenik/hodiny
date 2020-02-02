#!/busybox/sh

echo "Content-Type: text/javascript"
echo

echo $(/busybox/timestamp | /busybox/sed -E 's/(...)$/\.\1/')
