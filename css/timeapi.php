#!/busybox/sh

echo "Content-Type: text/javascript"
echo

T=$(/busybox/timestamp | /busybox/sed -E 's/(...)$/\.\1/')
echo "var dtest=new Date(), server=$T;"
