#!/bin/bash

cat ~/note/default.note | sed 's/\(^[^#].*\)/\${color #ddddff}×\$color \1/g' | sed 's/\(^#\)\(.*\)/${color yellow}\2/g'
