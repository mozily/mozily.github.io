#!/bin/bash

if [ "$1" == "-d" ]; then
  docker run --rm --name jekyll_server --volume="$PWD:/srv/jekyll" -e TZ=Asia/Seoul -p 4000:4000 -it -d jekyll/jekyll:4 jekyll serve --drafts
else
  docker run --rm --name jekyll_server --volume="$PWD:/srv/jekyll" -e TZ=Asia/Seoul -p 4000:4000 -it jekyll/jekyll:4 jekyll serve --drafts
fi
