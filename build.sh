#!/bin/bash

docker run --rm --volume="$PWD:/srv/jekyll" -it jekyll/jekyll:4 jekyll build
