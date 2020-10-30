#!/bin/sh
#
# ipfs daemon should be running on the machine
# where this script is run

DNS=clock.bublina.eu.org

SPFTRC=$HOME/.spf-toolsrc
# Read TOKEN
test -r $SPFTRC && . $SPFTRC
test -n "$TOKEN" || { echo "TOKEN not set! Exiting." >&2; exit 1; }

idsfile=$(mktemp /tmp/cloudflare-ids-XXXXXX)
zonefile=$(mktemp /tmp/cloudflare-zone-XXXX)

trap "rm -f $idsfile $zonefile $zonefile-data" EXIT
a="/$0"; a=${a%/*}; a=${a:-.}; a=${a#/}/; BINDIR=$(cd $a; pwd)
for cmd in jq grep
do
  type $cmd >&2 || exit 1
done

updateremote() {
  ssh $1 "ipfs pin add $2 && ipfs pin rm $3"
}

dnslinkget() {
  PARENT=${2:-${1#*.}}
  NS=$(dig -t NS +short $PARENT)
  dig +short TXT _dnslink.$1 @$NS \
    | sed -E 's/"dnslink=(.*)"/\1/g'
}

dnslinkset() {
  APIURL="https://api.cloudflare.com/client/v4"
  apicmd() {
    CMD=${1:-'GET'}
    test -n "$1" && shift
    REST=${1:-'/zones'}
    test -n "$1" && shift
    curl -X $CMD ${APIURL}${REST} \
      -s \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type:application/json" \
      "$@"
  }

  DOMAIN_ID=$(apicmd GET /zones | jq -r '.result | .[] | .name + ":" + .id' \
      | grep $DOMAIN) \
    || exit 1
  DOMAIN_ID=$(echo $DOMAIN_ID | cut -d: -f2)

  apicmd GET "/zones/$DOMAIN_ID/dns_records?type=TXT" \
    | jq -r '.result | .[] | .name + ":" + .id' > $idsfile

  name=_dnslink.$1
  content=dnslink=$2
  id_to_change=$(grep "^$name" $idsfile | cut -d: -f2)

  echo -n "Changing $name with id $id_to_change... "
  cat > $zonefile-data <<EOF
{"type":"TXT","name":"$name","content":"$content"}
EOF
  test -n "$DEBUG" && cat $zonefile-data

  apicmd PUT "/zones/$DOMAIN_ID/dns_records/$id_to_change" \
    --data @${zonefile}-data | jq .success | grep -q true \
    && echo OK || echo error
}

OLDREF=$(dnslinkget $DNS)
NEWREF=$(ipfs add --nocopy -Qr public)
test "${OLDREF##*/}" = "$NEWREF" && { echo "No change"; exit 1; }

ipfs pin rm $OLDREF
for i in $(seq 3)
do
  updateremote node$i $NEWREF $OLDREF
done
dnslinkset $DNS /ipfs/$NEWREF
