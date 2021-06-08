#!/bin/sh

./genmin.sh
rsync -av --delete . singer:web/clock.zone/
