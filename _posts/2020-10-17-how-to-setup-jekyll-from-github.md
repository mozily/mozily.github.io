---
layout: post
comments: true
title: github 에서 jekyll 를 이용해 blog 만들기 (작성중)
tags: jekyll
---

# jekyll 가 뭔가요?

## jekyll theme

# github 에서 jekyll 설치

## github.io 프로젝트 생성

본인의 github 에서 본인아이디.github.io 라는 이름의 repository 를 생성 한다.  
> ex) mozily.github.io  
> public 으로 설정하고, Add a README file 선택, Create repository  

원래 라면 프로젝트를 생성 하는것 만으로 https://본인id.github.io 에 접속이 가능해야 한다.  

## github 와 black lives matter

github 에서는 2020년 10월을 기점으로 default branch name 을 master 에서 main 으로 변경 됐는데  
최근 미국에서 큰 이슈가 됐었던 black lives matter 운동의 영향이라고 생각 된다.  
그렇기 때문에 현재 생성한 githubid.github.io repository 의 default branch 는 main 이다.  

![](https://drive.google.com/uc?export=download&id=1zu8QmJ8sciBsfW3kt6RbQ9nwsrOXxFEB)
> Settings > Options > Github Pages 항목을 보자

2020년 10월 17일 기준 아직 source 부분은 master 로 적용 돼 있기 때문에 정상적으로 페이지가 뜨지 않는다.  

2가지 플랜이 있다.  
1. github 정책에 따라 master 를 사용하지 않기로 하고, Source 부분의 branch 를 master -> main 으로 변경한다.  
2. master branch 를 추가 하고 default branch 를 master 로 변경하고, main 을 삭제한다.  

기본적으로 github.io 는 설정한 branch 에 push 가 되면 내부적인 build 과정을 거치고 페이지가 업로드 된다.  
push 를 해도 바로 반영 되는게 아니니 1분 정도 여유를 두고 기다리도록 하자.  

### github page 의 제약사항

[github page usage limits document](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages/about-github-pages#usage-limits)

github page 는 일반적인 유저라면 쉽게 걸리지 않는 제약사항을 가지고 있습니다.  
1. github page 의 repository 는 1GB 를 초과 할 수 없습니다.  
2. github page 사이트는 1GB 를 초과 할 수 없습니다.  
3. github page 는 월 기준 100GB 의 트래픽을 넘길수 없습니다.  
4. github page 는 1시간에 10번 까지만 build 할 수 있습니다.  

위의 제약이 싫다면 github premium 을 쓰면 되지만, 일반적인 블로그 운영이라면 제약사항을 초기하기 힘들것 같다.   

## 생성한 github.io 에 jekyll 테마 적용

