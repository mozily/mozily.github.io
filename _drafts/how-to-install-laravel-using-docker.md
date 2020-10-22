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

# laravel install
WORKDIR /var/www/html
RUN composer create-project --prefer-dist laravel/laravel future_manager
```

```
docker run --name laravel_server -p 8000:8000 php:7.4-fpm tail -f /dev/null
docker exec -it laravel_server /bin/bash

docker run --name laravel_server -p 8000:8000 future_laravel php /var/www/html/future_manager/artsian serve
```