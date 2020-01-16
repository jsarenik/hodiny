#!/busybox/sh

export PATH=/busybox
echo "Content-Type: text/html; charset=UTF-8"
echo

eval $(echo "$QUERY_STRING"|awk -F'&' '{for(i=1;i<=NF;i++){print $i}}')
MYTZ=$(/busybox/httpd -d "$tz")

TIMESTAMP=$(/busybox/timestamp)
HMSTS=$(echo $TIMESTAMP | /busybox/sed 's/......$//')
MLS=$(echo $TIMESTAMP | /busybox/sed -E 's/.*(..)....$/\1/')
CURDS="+%H*360000+%M*6000+%S*100+$MLS"
CURDS=$(TZ=$MYTZ /busybox/date -d "@$HMSTS" $CURDS | /busybox/bc)

echo "var curds = $CURDS;"
echo "var dtest = new Date();"
