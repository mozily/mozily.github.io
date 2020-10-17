---
layout: post
comments: true
title: vim nerdtree plugin 설치 및 tmux 세팅
tags: [linux, vim, nerdtree, tmux, ipad] 
---

# Introduction

ipad pro 4세대 + apple pencil 2세대 + ipad magic keyboard 를 구매 했다.  

# 설치 및 세팅

미리 관련 설정을 정리 해놓은 프로젝트를 다운받아 설치 할 예정  
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