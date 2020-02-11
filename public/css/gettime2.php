#!/busybox/sh

export PATH=/busybox
echo "Content-Type: text/javascript"
echo

eval $(echo "$QUERY_STRING"|awk -F'&' '{for(i=1;i<=NF;i++){print $i}}')
MYTZ=$(httpd -d "$tz")

TIMESTAMP=$(timestamp)
HMSTS=$(echo $TIMESTAMP | sed 's/......$//')
MLS=$(echo $TIMESTAMP | sed -E 's/.*(..)....$/\1/')
CURDS="+%H*360000+%M*6000+%S*100+$MLS"
TZ=$MYTZ date -d "@$HMSTS" $CURDS | bc
