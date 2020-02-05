#!/bin/sh

uglifyjs css/index.js > css/index.min.js
rsync -av --delete . hd:clock.zone/
