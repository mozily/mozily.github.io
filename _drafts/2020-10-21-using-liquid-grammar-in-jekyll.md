---
layout: post  
comments: true    
title: Jekyll 에서 Liquid 문법 사용하기
tags: [jekyll, liquid]
---

## Liquid 란?

Liquid 는 [Shopify](https://shopify.com) 에서 만들었다
> shopify 는 오프라인 마켓을 온라인으로 옮겨주는 비지니스 플랫폼 솔루션을 제공 해주는 회사 이다  
  
Ruby 를 이용한 오픈소스 템플릿 언어 이다  
2006년 부터 shopify 에서 상용 서비스에 주력으로 사용 했다  
현재는 shopify 이외의 다른 서비스에도 사용 되고 있고 가장 대표적으로 Jekyll 에서 사용하고 있다  


# Liquid 문법

Liquid 는 객체, 태그, 필터 이렇게 3개의 카테고리로 분류 할 수 있다  

## Liquid Object

```
{% raw %}
{{ page.title }}
{% endraw %}
```

## Liquid Tag

**Escape**

Liquid 문법으로 변환된 상태가 아니라 문법을 그대로 보여주고 싶을때 는 아래 처럼 escape 태그를 사용 한다  

```
{% raw %}
{{ page.title }}
{% endraw %}
```

**주석**  

```
{% raw %}
{% comment %}
주석으로 작성할 내용
{% endcomment %}
{% endraw %}
```

## Liquid Filter






# 참고자료
- [https://shopify.github.io/liquid](https://shopify.github.io/liquid)