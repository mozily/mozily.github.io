---
layout: post
comments: true
title: vim nerdtree plugin 설치 및 tmux 세팅
tags: [linux, vim, nerdtree, tmux, ipad] 
---

# Introduction

![](https://drive.google.com/uc?export=download&id=1XFQ7waW0D1gRg86r1ygPUKXZ4S67DOR3)

ipad pro 4세대 + apple pencil 2세대 + ipad magic keyboard 를 구매 했다.  
동영상, 게임, 웹서핑, 문서작성 등 생각보다 다양한 것들에 활용 하게 됐다.  
그러던 중 혹시 개발도!!? 라는 생각에 이것저것 찾아 보던 중  
역시 아직 ipad 에 ide 를 설치하기는 무리지만 vim 을 이용해서 그럴듯 하게 쓸수 있다는걸 알게 됐다.  

tmux 를 이용해서 화면을 분할하고 vim plugin 으로 syntax highlight 와 tree 메뉴를 적용 해봤다.

![](https://drive.google.com/uc?export=download&id=144Y4uvYRDefY4Z67R0Miy4V4jaMcQyMm)

제법 쓸만 해졌다.  
이제 남은건 내가 vim 에 익숙 해지는것??  

# 설치 및 세팅

미리 관련 설정을 정리 해놓은 프로젝트를 다운받아 설치 할 예정이다.  
프로젝트 다운로드 이후 본인의 기호에 맞게 config 를 수정 해서 사용 할수 있다.  

## vim development 다운로드 및 설정파일 복사

```bash
cd /tmp
git clone https://github.com/mozily/vim_development.git

# tmux configure
cp /tmp/vim_development/config/.tmux.config ~/.tmux.config

# vimrc configure
cp /tmp/vim_development/config/.vimrc ~/.vimrc

# vim plugin configure
mkdir ~/.vim
cp /tmp/vim_development/config/.ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py
```

## 동작 테스트

```bash
source ~/.bashrc

# tmux new -s <new session name>
tmux new -s mysession

# vim 실행후 command 모드에서 :PluginInstall 실행
vim -> :PluginInstall

# vim 실행후 command 모드에서 :GoInstallBinaries 실행
vi -> :GoInstallBinaries 
```

# 사용방법

## tmux command

|command|description|
|--|--|
|tmux -V|version check|
|tmux new -s <name>|create new session|
|ctrl + b, d|session log off|
|tmux ls|show tmux session list|
|tmux attach -t <name>|connection session|
|tmux + b, %|split screen vertically|
|tmux + b, "|split screen horizontal|
|tmux + b, move key|moving between split screens|
|ctrl + b, z|current screen zoom or zoom out|
|ctrl + b, c|create new tab|
|ctrl + d|close current screen|
|tmux kill-session -t <name>|delete session|

## vim extension NERDTree command

|command|description|
|--|--|
|:NERDTreeToggle|show & hide NERDTree|
|ctrl + w, move key|moving between split screens|
|NERDTree click, m, a|create new file|
|NERDTree click, m, m|move file|
|NERDTree click, m, d|delete file|
|NERDTree click, m, c|copy file|

## vim-go command

|command|description|
|--|--|
|:GoDef|method, variable, define position navigation|
|:GoImport|package import|
|:GoTest|unit test|
|:GoTestFunc|uint test|
|:GoBuild|package compile|
|:GoInstall|package install|
|:GoRun|run|
|:GoLint|go link tool|
|:GoPlay|upload go playground & make link|
