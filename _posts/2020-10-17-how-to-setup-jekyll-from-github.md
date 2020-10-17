---
layout: post
comments: true
title: github 에서 jekyll 를 이용해 blog 만들기 (초안)
tags: jekyll
---

# github page 와 jekyll

## jekyll 가 뭔가요?

[jekyll 공식 사이트](https://jekyllrb.com/)

![](https://drive.google.com/uc?export=download&id=16VWOGHeUE1jRhcUwglKENLFHuITUngaD)

```
.
├── _config.yml
├── _data
│   └── members.yml
├── _drafts
│   ├── begin-with-the-crazy-ideas.md
│   └── on-simplicity-in-technology.md
├── _includes
│   ├── footer.html
│   └── header.html
├── _layouts
│   ├── default.html
│   └── post.html
├── _posts
│   ├── 2007-10-29-why-every-programmer-should-play-nethack.md
│   └── 2009-04-26-barcamp-boston-4-roundup.md
├── _sass
│   ├── _base.scss
│   └── _layout.scss
├── _site
├── .jekyll-metadata
└── index.html # can also be an 'index.md' with valid front matter
```

jekyll 는 구조화 되어 있는 프레임워크 위에 정해진 규칙에 의해 생성한 원복 텍스트 파일을 올리면  
변환기를 통해 우리가 정적 사이트를 구성하기 위해 필요한 파일을 만들어 준다.  
> 주로 원본 파일은 markdown 형식을 이용하고 있다.  

## github 는 소스코드 저장소 아닌가요?

github 는 git 을 이용하는 개발자들이 좀더 효율적으로 프로젝트를 관리하고 공유 할수 있도록 플랫폼 역할을 해주는 곳 이다.  
일반 사용자는 public repository 만 생성 할 수 있었으나 2018년 6월 4일 microsoft 의 인수 이후 일반 사용자도 private repository 를 생성 할 수 있게 됐다.  

![](https://drive.google.com/uc?export=download&id=1UbGGIZQotOp1Pw8BgUCQOOBNlR0798Qj)

github page 는 github 에서 제공 하는 정적 페이지 호스팅 서비스 이다.  
> html, jekyll 등을 지원 한다.  

github page 는 jekyll 을 내부 엔진으로 사용하고 있지만 여러가지 보안상의 이유로 jekyll plugin 은 사용할수 없다.  
만약 plugin 을 사용하고 싶다면 로컬 환경에 jekyll 를 세팅하고 plugin 을 설치 한후  
build 로 생성한 파일을 직접 push 하는 방식으로 사용 할 수 있다.  

# github 에서 jekyll 설치

## github.io 프로젝트 생성

본인의 github 에서 본인id.github.io 라는 이름의 repository 를 생성 한다.  
> ex) mozily.github.io  
> public 으로 설정하고, Add a README file 선택, Create repository  

원래 라면 프로젝트를 생성 하는것 만으로 https://본인id.github.io 에 접속이 가능해야 한다.  
그러나 지금은 404 not found 페이지가 뜨게 된다.  

## github 와 black lives matter

github 에서는 2020년 10월을 기점으로 default branch name 을 master 에서 main 으로 변경 했다.    
최근 미국에서 큰 이슈가 됐었던 black lives matter 운동의 영향이라고 생각 된다.  
그래서 현재 생성한 본인id.github.io repository 의 default branch 는 main 이다.  

![](https://drive.google.com/uc?export=download&id=1zu8QmJ8sciBsfW3kt6RbQ9nwsrOXxFEB)
> Settings > Options > Github Pages 항목을 보자

그런데 github pages 의 source 부분을 보면 기준 페이지가 master 로 돼 있다.    

2가지 플랜이 있다.  
1. github 정책에 따라 main branch 를 그대로 유지하고, source 부분의 branch 를 main 으로 변경한다.    
2. source 부분의 branch 를 master 로 그대로 유지하고, master branch 를 생성한다.  

### github page 의 제약사항

[github page usage limits document](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/about-github-pages#usage-limits)

github page 는 일반적인 유저라면 쉽게 걸리지 않는 제약사항을 가지고 있다.  
1. github page 의 repository 는 1GB 를 초과 할 수 없다.  
2. github page 사이트는 1GB 를 초과 할 수 없다.  
3. github page 는 월 기준 100GB 의 트래픽을 넘길수 없다.  
4. github page 는 1시간에 10번 까지만 build 할 수 있다.  

위의 제약이 싫다면 github premium 을 쓰면 되지만 일반적인 블로그 운영이라면 제약사항을 초과하기는 힘들 것 같다.  

## 생성한 github.io 에 jekyll 테마 적용

[jekyll theme 보러가기](https://github.com/topics/jekyll-theme)

github topics 에서 jekyll-theme 태그를 검색하면 여러가지 테마를 순위 별로 볼수 있다.   

![](https://drive.google.com/uc?export=download&id=1B7Z8LAI2Pgj37o5_wRWSwiDcCZi-wU1w)

테마 repository 에 접속해서 demo 사이트나 스크린샷 이미지를 보며 사용할 테마를 결정한다.  
테마 적용 방법은 크게 2가지로 나뉜다.  
1. _config.yml 파일만 복사해서 remote_theme 기능을 사용 하는 방법  
2. 테마 repository 를 fork 해서 사용 하는 방법  
> 기존 테마에서 다양한 커스터마이징을 하기 위해서 fork 해서 사용하는걸 추천 한다.  

### remote_theme 기능을 이용한 테마 적용 방법

현재 가장 star 가 많은 테마인 minimal-mistakes 로 예시를 들어 보겠다.  
[https://github.com/mmistakes/minimal-mistakes](https://github.com/mmistakes/minimal-mistakes)

적용 하고자 하는 테마의 _config.yml, index.html 파일을 내 repository 에 복사 한다.    

![](https://drive.google.com/uc?export=download&id=1ws3ZLpojbN-HxRzeKuYhU4d2ycNaIz5c)

복사한 _config.yml 내용에 아래의 코드를 추가 한다. (코드가 주석 상태라면 주석 해제)  
> remote_theme : mmistakes/minimal-mistakes  

복사한 _config.yml 내용중 아래의 코드를 수정 한다.  
> url : "https://본인id.github.io"  
> baseurl : ""  

### repository fork 를 이용한 테마 적용 방법

![](https://drive.google.com/uc?export=download&id=1jh21IX0aFeOnPqMBfoR7ilO_ZmRe2Snv)

minimal-mistakes repository 로 가서 fork 내 저장소로 복사 해 온다.  

![](https://drive.google.com/uc?export=download&id=1F0EBWhlmB_VYQrA2Yt37OHKlJkUWrmy7)

Repository name 을 본인id.github.io 로 변경한다.  
변경 후 _config.yml 에서 기호에 맞게 정보를 수정한다.  
> 이때 remote_theme 는 그대로 주석처리 해두면 된다.

# github page 에 포스팅 하기

## 작성방법

jekyll 에는 몇가지 규칙이 있다.  

|dir|description|
|--|--|
|_drafts|작성이 완료 되지 않은 포스트 초안을 저장하고 있음|
|_includes|header, navigation, footer 등 페이지를 구성할때 포함 시키는 페이지를 담고 있음|
|_layouts|liquid 필터를 이용해서 변수를 파싱하고 정적 페이지를 만들수 있는 정보를 담고 있음|
|_posts|%Y-%m-%d-포스트이름.md 형식으로 포스트를 작성해서 저장 하는 경로|
|_sass|생성된 페이지가 사용할 css 정보를 담고 있는 경로|

기본적인 디렉토리 구성은 위와 같고, 테마별로 조금더 추가 되는 경우도 있다.  

먼저 포스트를 작성할때는 _drafts 디렉토리에 날짜를 붙이지 않고 제목만 있는 상태로 md 파일로 포스트를 작성해서 올린다.  
_drafts 는 초안이 저장되는 폴더이기 때문에 기본적으로는 페이지가 생성되지 않는다.  

```bash
jekyll build --drafts
```

위처럼 --drafts 옵션을 넣어서 빌드하면 build 하는 날짜가 초안의 앞에 자동으로 붙어서 페이지가 생성 된다.  
초안 작업이 완료되면 포스트 파일앞에 날짜를 추가 하고 _posts 디렉토리로 옮기면 된다.  

기본적으로 github page 에서는 github page 의 source 로 설정된 branch 에 push 가 새롭게 되면  
자동으로 build 를 하고 github.io 에 생성한 정적 페이지를 배포 한다.  

push 하고 나서 약 1분 정도의 시간이 소요 될수 있으니 여유를 가지고 기다려 보자.  