#!/bin/sh

./genmin.sh
rsync -av \
  --exclude=public/cgi-bin/timeapi \
  --exclude=public/cgi-bin/timeapi2 \
  --delete . singer:web/clock.zone/
