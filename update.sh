#!/bin/sh

./genmin.sh
rsync -av --delete . hd:clock.zone/
