#!/busybox/sh

echo "Content-Type: text/html; charset=UTF-8"
echo

cat <<EOF
$(/busybox/timestamp | /busybox/sed -E 's/(...)$/\.\1/')
EOF
