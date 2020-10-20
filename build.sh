#!/bin/bash

docker run --rm --volume="$PWD:/srv/jekyll" -e TZ=Asia/Seoul -it jekyll/jekyll:4 jekyll build --drafts
