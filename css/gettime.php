#!/busybox/sh

export PATH=/busybox
echo "Content-Type: text/html; charset=UTF-8"
echo

eval $(echo "$QUERY_STRING"|awk -F'&' '{for(i=1;i<=NF;i++){print $i}}')
MYTZ=$(/busybox/httpd -d "$tz")
test -n "$1" && MYTZ=$1

TIMESTAMP=$(/busybox/timestamp)
HMSTS=$(echo $TIMESTAMP | /busybox/sed 's/......$//')
HMS=$(TZ=$MYTZ /busybox/date -d "@$HMSTS" +%H:%M:%S)
H=$(echo $HMS | /busybox/cut -d: -f1)
M=$(echo $HMS | /busybox/cut -d: -f2)
S=$(echo $HMS | /busybox/cut -d: -f3)
MLS=$(echo $TIMESTAMP | /busybox/sed -E 's/.*(..)....$/\1/')
CURDS=$(($H * 360000 + $M * 6000 + $S * 100 + $MLS))

/busybox/cat <<EOF
var curds = $CURDS;
var dtest = new Date();
EOF 
