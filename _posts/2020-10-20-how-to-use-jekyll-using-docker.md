---
layout: post
comments: true
title: Docker 를 이용해서 Jekyll 를 사용하는 방법
tags: [jekyll, docker]
---

# Introduction

지난 "[Github 에서 Jekyll 를 이용해 블로그 만들기]({% post_url 2020-10-17-how-to-setup-jekyll-from-github %})" 포스트에서 jekyll 를 이용한 github page 를 만들어 봤다.    

포스팅 몇개 올려보니 아래와 같이 불편한 부분이 생겼다.  
- local 에서 작성한 markdown 과 github page 에서 jekyll 로 build 된 페이지가 미묘하게 다르다.  
- 만들어진 테마를 가져왔어도 수정하고 싶은 부분들이 여기저기 생긴다. (댓글, 메뉴, 레이아웃 등)  
- 위의 사항들을 수정하고 확인하기 위해서는 github page 에 push 하고 페이지가 반영 되기 까지 약 1분 정도를 기다려야 한다.  

이런 불편함들을 해소 하기 위해서 local 에 jekyll 을 설치 하기로 마음 먹었다.  
local 에서 build 하고 작성한 포스트와 변경한 레이아웃 등을 확인한 뒤 최종적으로 github page 에 push 하려는 계획이다.

# 환경세팅

## github page 다운로드

```bash
git clone https://github.com/{userid}
```   

## docker 를 이용한 jekyll build

```bash
docker run --rm --volume="$PWD:/srv/jekyll" -e TZ=Asia/Seoul -it jekyll/jekyll:4 jekyll build --drafts
```

## .gitignore 파일 세팅

gitignore 에 build 해서 나온 cache 와 _site 정보 추가  
> local 에서는 build 된 페이지만 확인하고 github page 에서 build 하기 위함  
> local 에서 빌드한 결과물을 올리고 싶다면 _site 는 gitignore 에 추가하지 말것  

```text
.idea
/.jekyll-cache/Jekyll/Cache/
/_site/
```

## docker 를 이용한 jekyll 블로그 확인

```bash
docker run --rm --volume="$PWD:/srv/jekyll" -e TZ=Asia/Seoul -p 4000:4000 -it jekyll/jekyll:4 jekyll serve --drafts
```

위의 명령을 실행 하면 아래 처럼 jekyll server 가 실행 된다.  

```text
ruby 2.7.1p83 (2020-03-31 revision a0c7c23c9c) [x86_64-linux-musl]
Configuration file: /srv/jekyll/_config.yml
            Source: /srv/jekyll
       Destination: /srv/jekyll/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
                    done in 1.011 seconds.
                    Auto-regeneration may not work on some Windows versions.
                    Please see: https://github.com/Microsoft/BashOnWindows/issues/216
                    If it does not work, please upgrade Bash on Windows or run Jekyll with --no-watch.
 Auto-regeneration: enabled for '/srv/jekyll'
    Server address: http://0.0.0.0:4000/
  Server running... press ctrl-c to stop.
```

server address 를 보면 http://0.0.0.0:4000 으로 접근 가능하다고 나온다.  
http://localhost:4000 으로 접속해서 페이지를 확인 하자.  

서버가 올라가 있는 상태에서는 코드를 수정하면 바로바로 페이지에 반영 된다.  

```text
Regenerating: 1 file(s) changed at 2020-10-20 13:57:07
            _drafts/2020-10-20-how-to-use-jekyll-using-docker.md
            ...done in 0.8102454 seconds.
```