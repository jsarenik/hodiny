#!/busybox/sh

a="/$0"; a=${a%/*}; a=${a:-.}; a=${a#/}/; HERE=$(cd $a; pwd)
export PATH=/busybox/old:/busybox

echo "Content-Type: text/html; charset=UTF-8"
echo

test "$QUERY_STRING" != "" \
  && eval $(echo "$QUERY_STRING" \
    | grep -o '[a-zA-Z][[:alnum:]]*=[-[:alnum:]/_+%]\+')

# Shell router
R=${REQUEST_URI%/*}
R=${R##*/}
# So far we handle following REQUEST_URIs:
### /more/digital -> digital.sh
### /analog -> analog.sh
### /tools/timestamptodate -> timestamptodate.sh
. $HERE/$R.sh
