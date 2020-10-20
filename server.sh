#!/bin/bash

docker run --rm --volume="$PWD:/srv/jekyll" -e TZ=Asia/Seoul -p 4000:4000 -it jekyll/jekyll:4 jekyll serve --drafts
