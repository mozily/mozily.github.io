---
layout: post  
comments: true    
title: docker 를 사용한 laravel 설치 방법
tags: [docker, laravel]
---

# Laravel 디렉토리 구조

> Laravel 8 버전을 기준으로 디렉토리 구조를 작성 하였음

**/app**  
작업자가 개발하는 애플리케이션 소스코드를 저장돼 있음  
model, controller 등을 설정해야 하기 때문에 작업자가 여기서 작업을 많이 하게 됨  

**/bootstrap**  
Laravel 프레임워크가 시작될때 필요한 파일들이 저장되어 있음 (사용자가 수정할 필요 없음)  

**/config**  
auth, database, session, mail 등 프레임워크에 대한 설정 파일이 있음  

**/database**  
database 의 스키마를 관리하는 migration  
초기 데이터를 설정하는 seeds 데이터  
모델에 데이터를 입력하기 위한 factories  

**/public**  
모든 request 들에 대한 진입점 역할과 index.php 파일이 있음  

**/resources**  
css, js, lang 같은 리소스 들과 view 코드들이 있음

**/routes**  
web.php : RESTFul api 가 아닐때 사용하는 라우팅 정보가 저장 된 곳  
api.php : RestFul api 일때 사용하는 라우팅 정보가 저장 된 곳  
console.php : 파일의 클로저 기반의 명령어들을 정의해 놓을 수 있는 파일  
channels.php : 애플리에키션에서 지원하는 모든 이벤트 브로드캐스팅 채널을 등록하는 파일  

**/storage**  
app : 애플리케이션에 의해서 만들어진 파일을 저장하는 디렉토리  
framework : 프레임워크가 생성한 파일들과 캐시를 저장하는 디렉토리  
logs : 애플리케이션의 로그 파일들을 저장하는 디렉토리  

**/tests**  
자동화된 테스트가 포함되어 있음  
PHPUnit 테스트 예제를 보고 애플리케이션의 테스트 케이스를 구현 하면 됨  

```
php vendor/bin/phpunit
PHPUnit 9.4.2 by Sebastian Bergmann and contributors.
..                                                                  2 / 2 (100%)
Time: 00:00.100, Memory: 18.00 MB
OK (2 tests, 2 assertions)
```

**/vendor**  
composer 를 이용해서 의존성 있는 패키지를 설치한 디렉토리
 
---

# artisan

```
php artisan list

Laravel Framework 8.12.3

Usage:
  command [options] [arguments]

Options:
  -h, --help            Display this help message
  -q, --quiet           Do not output any message
  -V, --version         Display this application version
      --ansi            Force ANSI output
      --no-ansi         Disable ANSI output
  -n, --no-interaction  Do not ask any interactive question
      --env[=ENV]       The environment the command should run under
  -v|vv|vvv, --verbose  Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug

Available commands:
  clear-compiled       Remove the compiled class file
  down                 Put the application into maintenance / demo mode
  env                  Display the current framework environment
  help                 Displays help for a command
  inspire              Display an inspiring quote
  list                 Lists commands
  migrate              Run the database migrations
  optimize             Cache the framework bootstrap files

  --------- 생략 --------------------------------------------------------------------
1
 schema
  schema:dump          Dump the given database schema
 session
  session:table        Create a migration for the session database table
 storage
  storage:link         Create the symbolic links configured for the application
 stub
  stub:publish         Publish all stubs that are available for customization
 vendor
  vendor:publish       Publish any publishable assets from vendor packages
 view
  view:cache           Compile all of the application's Blade templates
  view:clear           Clear all compiled view files
```

php artisan migrate  
php artisan db:seed  
php artisan serve --host 0.0.0.0  

---

# Laravel Javascript & CSS 스캐폴딩

```
apt-get update
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install nodejs
node -v
npm -v

composer global require laravel/installer
$HOME/.composer/vendor/bin/laravel new mylaravel
cd mylaravel
composer require laravel/ui

// Generate basic scaffolding
php artisan ui bootstrap
php artisan ui vue
php artisan ui react  

// Generate login / registration scaffolding
php artisan ui bootstrap --auth
php artisan ui vue --auth
php artisan ui react --auth

npm install
npm run dev
```

---

# node & npm 최신버전 설치

```
apt-get update
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install nodejs
node -v
npm -v

composer global require laravel/installer
$HOME/.composer/vendor/bin/laravel new mylaravel
```

---

# dockerfile 만들기

```
FROM php:7.4-fpm

# php extension install
RUN apt-get update
RUN apt-get install -y libzip-dev unzip
RUN docker-php-ext-install zip

# composer install
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
```

## 내장 서버로 laravel 실행 하기

```
# create laravel project
composer create-project --prefer-dist laravel/laravel mylaravel

docker run -it --rm --name laravel_server -p 8000:8000 future_laravel php ./mylaravel/artisan serve --host 0.0.0.0

docker run -it --rm --name laravel_server -v /home/mozily/laravel:/var/www/html/future_manager -p 8000:8000 future_laravel /bin/bash
```



## Laravel 설정

### 환경설정


# 참고자료

- [쉽게 배우는 라라벨 5 프로그래밍](https://www.lesstif.com/laravelprog/5-28606603.html)
- [[Laravel] 라라벨 설치하기 PHP7.0 + Nginx](https://blog.storyg.co/laravels/install-on-ubuntu16-with-php7-and-nginx)
- [Laravel 8.X 설치하기](https://laravel.kr/docs/8.x/installation)
- [simple laravel layouts using blade](https://scotch.io/tutorials/simple-laravel-layouts-using-blade)