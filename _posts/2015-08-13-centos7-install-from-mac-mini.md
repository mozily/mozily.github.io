---
layout: post  
comments: true    
title: mac mini 에서 centos 7.x 설치
tags: [linux, centos, mac-mini]
---

### Introduction

<img src='https://drive.google.com/uc?export=download&id=1iBsFoV-oI20eyg4ce6IFqu_drBmgTbE_' alt='mac mini server 2012 late'>

2012년 가을쯤 mac mini server 2012 late 버전을 구입 했다.
> i7-3세대, 2.3GHz, 쿼드코어
>
> RAM 8GB (기본 4GB 에서 추가)
>
> SSD 2TB (1TB X 2)

mac mini 에서 ssd 가 1개 (1TB) 더 추가 돼 있고, OS X Server 가 기본 제공 된다.
생각 보다 별거 없는 구성이라 살짝 허탈 하기도 했다.

처음에는 언제 어디서나 원격으로 xcode 로 개발을 할수 있으니 좋다 라며 만족고 썼지만 어느순간 본래의 목적 보다는 단순히 홈 미디어 서버로 전락 해 버렸다.
어느순간 ux 도 필요 없게 됐고, 서버에 올린 서비스만 필요하게 되면서 자연스럽게 os 교체를 생각하게 됐다.

주위에서는 비싸게 맥미니를 사서 뭐하는 거냐 라고 하지만 그 어떤 서버보다 조용 했고, 전기를 적게 먹었으며 안정적 이었다.
2020년 10월 기준 8년간 사용 했으며 uptime 최고 기록은 1년 6개월 정도 였던것 같다.

---

### CentOS 7.x 설치용 USB 준비

**설치할 centos 의 이미지 (iso) 를 준비 한다.**

[Centos 7.x 다운로드](http://isoredirect.centos.org/centos/7/isos/x86_64/)

평소 가벼운걸 선호 하기 때문에 minimal.iso 파일을 다운 받았다.

<font color='blue'>centos 7.5.1804 minimal 설치 가능</font>


<font color='red'>centos 7.6.1810 minimal 버전 설치 불가</font>
> 2019년 7월 기준 버그로 인해 설치용 USB 를 만들경우 에러가 발생함
>
> https://angrysysadmins.tech/index.php/2018/12/grassyloki/centos-7-failed-set-moklistrt/

<font color='blue'>centos 7.8.2003 minimal 설치 가능</font>

<font color='red'>centos 8.2.2004 minimal 버전 설치 불가</font>
> 2020년 9월 30일 기준 centos 8 버전 중에서 가장 최신 버전
>
> 설치 usb는 만들어 졌지만, 설치 과정에서 disk 파티션 설정 중 에러가 발생 함
>
> /boot/efi 파티션을 만들 수 없는 에러 ..
>
> rescue mode 로 들어가서 fdisk 로 파티션을 모두 날리고 설치 해봤지만 정상적으로 설치되지 않았음
>
> > boot disk 를 지정하지 않으면 설치가 가능하짐나 부팅시 정상적으로 centos 를 부팅 하지 못함
> >
> > boot disk 를 지정하면 /boot/efi 파디션을 만들다가 에러가 발생 함

**설치용 centos usb 제작**

이 작업을 위해서는 mac os 장비가 필요하다.

usb 를 알맞은 형식으로 포멧
- 런처패드 > 디스크 유틸리티 실행
- usb 에서 마우스 오른쪽  "지우기" 선택
- Mac OS 확장 (저널링) 선택 후 지우기 실행

터미널 실행
```bash
# hdiutil convert -format UDRW -o <생성될 dmg 파일 이름> <원본 iso 파일 경로와 이름>
hdiutil convert -format UDRW -o centos7.x.xxxx.dmg ./CentOS-7.x.xxx.iso

# external 로 꼽혀 있는 usb 번호를 확인 ex) /dev/disk2 (external, physical)
diskutil list

# mount 상태에서는 설치 usb 를 만들수 없음 (unmount 상태로 복사 할 예정)
# diskutil unmountDisk <마운트된 디스크 이름>
diskutil unmountDisk /dev/disk2

# 아래의 명령을 치면 5~10분 정도 반응이 없음, 느긋하게 기다릴것 (커피 한잔..)
# 완료 되면 "삽입한 디스크를 컴퓨터에서 읽을수 없어요" 라는 에러 팝업이 뜸 (정상이니 당황 노노)
sudo dd if=centos7.x.xxx.dmg of=/dev/disk2 bs=1m
```

---

### mac mini 에 centos 설치

준비된 USB 를 서버에 꼽고 재부팅

재부팅시 alt 키를 누르고 있으면 mac 의 부팅 관리자 메뉴가 뜨고, USB 를 선택

**centos 설치**

언어 선택
- 영어 /영어

소프트웨어 선택
- minimal install
- development tools

네트워크 & 호스트 옵션
- on 으로 설정하고 host name 을 원하는 이름으로 설정

날짜 시간 옵션
- Asia/Seoul 체크 후 network time on
- 네트워크를 먼저 설정하지 않으면 network time on 으로 변경 할 수 없음

파티션 옵션

|path|size|file system|format|
|--|--|--|--|
|/home|50 GB|LVM|ext4|
|/boot|1 GB|standard partition|ext4|
|/boot/efi|1 GB|standard partition|EFISystem Partition|
|swap|16 GB (메모리의 2배)|standard partition|swap|
|/|나머지|LVM|ext4|

<font color='blue'>위의 설정은 주관적인 설정이며 본인의 취향대로 바꿔도 상관 없음</font>

계정 패스워드 설정
- 설치중 root password, user creation 적용

**centos 설정**

selinux 보안설정 off

> 보안상 키는게 좋을것 같지만 제약이 많아져서 끄는 편
```bash
su -c "setenforce 0"
vi /etc/sysconfig/selinux
------------------------------
SELINUX=disabled
------------------------------
```

dns 설정

> [dnsever.com](https://kr.dnsever.com) : 적은 비용으로 dns 를 사용할수 있다.
>
> 일정 주기로 dnsever 로 서버의 도메인 주소를 날리면 dnsever 에서 알아서 dns 를 갱신 해준다.

```bash
crontab -e
------------------------------
*/5 * * * * wget -O - --http-user=<dnsever 유저ID> --http-passwd=<dnsever 유저PW> 'http://dyna.dnsever.com/update.php?host[<내서버 도메인>]' > /dev/null 2>&1
------------------------------
```

epel repository 추가

```bash
yum install -y epel-release
```

root 로 ssh 로그인 제한

```bash
vi /etc/ssh/sshd_config
------------------------------
permitRootLogin no
------------------------------

systemctl restart sshd.service
```

생성한 계정에 패스워드 입력 없이 root 전환 설정

```bash
vi /etc/sudoers
------------------------------
<계정이름> ALL=(ALL) NOPASSWD:ALL
------------------------------
```

기본 유틸리티 설치

```bash
yum install -y net-tools telnet wget git
yum groupinstall -y 'Development Tools'
```

---

### mac mini fan 동작 이슈

mac os 에서는 서버의 온도에 따라서 동적으로 fan 의 속도를 조절 해주는 프로그램도 있었는데 centos 에서는 cpu 온도가 올라가도 fan 의 rpm 이 그대로 유지된다.
어쩔수 없이 fan 을 돌려주는 스크립트를 작성 했다.

**시스템 온도 모니터링을 위한 sensors 패키지 설치**

> [apple sensor name](https://discussions.apple.com/thread/4838014) 참고

```bash
yum install -y lm_sensors

# 모두 yes 입력
sensors-detect

# 출력되는 센서 정보 확인
sensors
```

**팬 속도 컨트롤러 세팅**

```bash
yum install -y python-pip

# 아래의 python script 작성
vi mac_fan_control.py
```
```python
#!/usr/bin/env python

import sys, os, time
from daemon import Daemon

class MyDaemon(Daemon):
	FAN_PATH = "/sys/devices/platform/applesmc.768/fan1"
	TEMP_SENSOR_CORE_1 = "/sys/devices/platform/applesmc.768/temp5"
	TEMP_SENSOR_CORE_2 = "/sys/devices/platform/applesmc.768/temp15"

	def get_value(self, file_name):
		value_file = open(file_name, "r")
		value = int(value_file.readline())
		value_file.close()
		return value
		
	def set_value(self, file_name, value):
		os.system("echo " + str(value) + " | tee -a " + file_name)

	def get_rotation(self, temp):
		min_rotation = self.get_value(self.FAN_PATH + "_min")
		max_rotation = self.get_value(self.FAN_PATH + "_max")

		if min_rotation > max_rotation:
			min_rotation = max_rotation

		rotation = min_rotation

		if temp > 80000:
			rotation = max_rotation
		elif temp > 70000:
			rotation = 4000
		elif temp > 65000:
			rotation = 3500
		elif temp > 60000:
			rotation = 3000
		elif temp > 55000:
			rotation = 2500
		else:
			rotation = 1800

		if rotation > max_rotation:
			rotation = max_rotation

		return rotation

	def run(self):
		#default fan speed setting
		min_rotation = self.get_value(self.FAN_PATH + "_min")
		self.set_value(self.FAN_PATH + "_min", min_rotation)

		while True:
			# Temperature of the cores
			temp_core_1 = self.get_value(self.TEMP_SENSOR_CORE_1 + "_input")
			temp_core_2 = self.get_value(self.TEMP_SENSOR_CORE_2 + "_input")

			# <temp> as the hottest core
			if temp_core_1 > temp_core_2:
				temp = temp_core_1
			else:
				temp = temp_core_2
				
			# Compare temperatures und set the fan speed
			rotation = self.get_rotation(temp)
			self.set_value(self.FAN_PATH + "_min", rotation)

			# Wait x seconds
			time.sleep(5)

if __name__ == "__main__":
	daemon = MyDaemon('/var/run/mac_fan_control.pid')
	if len(sys.argv) == 2:
		if 'start' == sys.argv[1]:
			daemon.start()
		elif 'stop' == sys.argv[1]:
			daemon.stop()
		elif 'restart' == sys.argv[1]:
			daemon.restart()
		else:
			print "Unknown command"
			sys.exit(2)

		sys.exit(0)
	else:
	    print "usage: %s start|stop|restart" % sys.argv[0]
		sys.exit(2)
```

작성한 스크립트를 service 로 추가 및 실행

```bash
vi /lib/systemd/system/mac_fan_control.service
------------------------------
[Unit]
Description=Mac fan controller

[Service]
Type=forking
PIDFile=/var/run/mac_fan_control.pid
ExecStart=/usr/bin/python <python script 경로>/mac_fan_control.py start
ExecStop=/usr/bin/python <python script 경로>/mac_fan_control.py stop

[Install]
WantedBy=multi-user.target
------------------------------

systemctl enable mac_fan_control.service
systemctl start mac_fan_control.service
```