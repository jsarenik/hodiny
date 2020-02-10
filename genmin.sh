#!/bin/sh

u() {
  uglifyjs $1 -m -c --source-map --output ${1%%.js}.min.js
}

u css/index.js
