#!/bin/bash

sed -i '' -e 's/^!/(/' -e 's/.call(this);$/)();/' "$1" \
  && echo -n 'javascript:' > "$2" \
  && cat "$1" >> "$2"
