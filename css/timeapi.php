#!/busybox/sh

echo "Content-Type: text/html; charset=UTF-8"
echo

T=$(/busybox/timestamp | /busybox/sed -E 's/(...)$/\.\1/')
echo "var server = $T; var dtest = new Date();"
