#!/busybox/sh

export PATH=/busybox
echo "Content-Type: text/javascript"
echo

eval $(echo "$QUERY_STRING" | grep -o '[a-zA-Z][[:alnum:]]*=[-[:alnum:]/_+%]\+')
MYTZ=$(httpd -d "$tz")

TIMESTAMP=$(timestamp)
HMSTS=$(echo $TIMESTAMP | sed 's/......$//')
MLS=$(echo $TIMESTAMP | sed -E 's/.*(..)....$/\1/')
CURDS="+%H*360000+%M*6000+%S*100+$MLS"
CURDS=$(TZ=$MYTZ date -d "@$HMSTS" $CURDS | bc)

echo "var dtest=new Date(), curds=$CURDS;"
