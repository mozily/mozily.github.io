---
layout: post  
comments: true    
title: docker 를 사용한 laravel 설치 방법
tags: [docker, laravel]
---

## dockerfile 만들기

```
FROM php:7.4-fpm

# php extension install
RUN apt-get update
RUN apt-get install -y libzip-dev unzip
RUN docker-php-ext-install zip

# composer install
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# create laravel project
WORKDIR /var/www/html
RUN composer create-project --prefer-dist laravel/laravel mylaravel
```

## 내장 서버로 laravel 실행 하기

```
docker run -it --rm --name laravel_server -p 8000:8000 future_laravel php ./mylaravel/artisan serve --host 0.0.0.0

docker run -it --rm --name laravel_server -v /home/mozily/laravel:/var/www/html/future_manager -p 8000:8000 future_laravel /bin/bash
```

## Laravel 설정



## 참고자료

[Laravel 8.X 설치하기](https://laravel.kr/docs/8.x/installation)
[docker container에서 laravel 설치 및 실행하기](https://medium.com/sjk5766/docker-container%EC%97%90%EC%84%9C-laravel-%EC%84%A4%EC%B9%98-%EB%B0%8F-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0-cd9ed211927e)