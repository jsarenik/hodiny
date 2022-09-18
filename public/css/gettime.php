#!/busybox/sh

export PATH=/busybox/old:/busybox
echo "Content-Type: text/javascript"
echo

test "$QUERY_STRING" != "" \
  && eval $(echo "$QUERY_STRING" \
    | grep -o '[a-zA-Z][[:alnum:]]*=[-[:alnum:]/_+%]\+')
test "$tz" = "" || MYTZ=$(httpd -d "$tz")

TIMESTAMP=$(timestamp)
HMSTS=${TIMESTAMP%??????}
MLS=${TIMESTAMP#${TIMESTAMP%??????}}
MLS=${MLS%????}
CURDS="+%H*360000+%M*6000+%S*100+$MLS"
CURDS=$(TZ=$MYTZ date -d "@$HMSTS" $CURDS | bc)

echo "var dtest=new Date(), curds=$CURDS;"
