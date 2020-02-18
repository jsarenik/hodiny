#!/bin/sh

./genmin.sh
rsync -av --delete . hd:web/clock.zone/
