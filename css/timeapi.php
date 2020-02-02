#!/busybox/sh

echo "Content-Type: text/javascript"
echo

T=$(/busybox/timestamp | /busybox/sed -E 's/(...)$/\.\1/')
echo "var server = $T; var dtest = new Date();"
