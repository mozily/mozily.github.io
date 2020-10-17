---
layout: post
comments: true
title: windows 10 에 WSL2, Ubuntu, Docker 설치
tags: [linux, wsl2, docker] 
---

### 윈도우 버전 확인  
<img src='https://drive.google.com/uc?export=download&id=182NzrhGFSpTJERth6nkkyrhgqmf66qa6' alt='윈도우 사양'>

> 윈도우키 > 설정 > 시스템 > 정보 순으로 접근
> 제일 하단에 windows 사양 정보를 확인 (버전이 2004 이하라면 업데이트 필요)

### WSL 설치
<img src='https://drive.google.com/uc?export=download&id=1Cqu3v_ZefvHmr_ea5lZnyhnlehbA8LJG' alt='hiper-v 설정'>

> Hiper-V, Linux용 Windows 하위 시스템 체크 > 확인    

### WSL 2 Linux 커널 업데이트
[WSL 2 Linux 커널 업데이트 패키지 다운로드](https://docs.microsoft.com/ko-kr/windows/wsl/wsl2-kernel)

<img src='https://drive.google.com/uc?export=download&id=1C26A4kDt4oh5yVGEl22KE6Aues290MQL' alt='wsl2 linux kernel update'>

<img src='https://drive.google.com/uc?export=download&id=1V3X1h4bAd8ksSZOylR36HIa8q_Xk6HRX' alt='wsl2 linux kernel install'>

> "this update only applies to machines with the windows subsystem for linux" 
> 라는 팝업이 출력 된다면 기존에 설치된 프로그램이 있는지 확인 후 해당 프로그램 삭제 하고 다시 설치    

### 윈도우의 WSL 기본 버전을 2 로 변경    
> 윈도우 + R 로 명령줄을 실행하고 cmd 입력
> wsl --set-default-version 2 입력

WSL 2와의 주요 차이점에 대한 자세한 내용은 https://aka.ms/wls2 를 참조하세요. 
> 위처럼 메시지가 출력 된다면 정상적으로 wsl2 로 변경 되었다는 것 임  

WSL 2에 커널 구성 요소 업데이트가 필요합니다. 자세한 내용은 https://aka.ms/wsl2kerner을 참조 하십시오.
> 위처럼 메시지가 출력 된다면 wsl2-kernel 을 설치 하지 않아서 발생하는 에러 임  

### Ubuntu 20.04 LTS 설치  
  
<img src='https://drive.google.com/uc?export=download&id=1V1MOFgoSdGHHoXg5IaeqQ3j0Rg2kZnDq' alt='ubuntu 20.04 lts'>  
  
> 윈도우키 > microsoft store 클릭 > ubuntu 검색 > ubuntu 20.04 lts 클릭후 설치
> ubuntu 를 실행하고 최초 계정, 패스워드를 입력하면 완료
 
### docker desktop for windows 설치  
 
[docker desktop for windows 다운로드](https://hub.docker.com/editions/community/docker-ce-desktop-window)
> 위의 사이트에 접속해서 stable 버전 다운로드 
> edge 버전은 간혹 오작동을 하는 경우가 있음  
  
Configuration  
> Enable WSL 2 Windows Features : 체크  
> Add shortcut to desktop : 체크  
  
Docker Desktop 설정  
  
<img src='https://drive.google.com/uc?export=download&id=1fHfi3YnncJG9SIV2T_qg6BNP0zyt_Cm3' alt='docker settings general'>

<img src='https://drive.google.com/uc?export=download&id=1ecFUa8kb-ZZI6qBKPJVdGxcPCsDFVxIy' alt='docker settings resources'>

ubuntu 실행

```bash
docker version
```
 
docker 정보가 제대로 출력 되는지 체크
