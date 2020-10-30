---
layout: post  
comments: true    
title: Jekyll 에서 Liquid 문법 사용하기
tags: [jekyll, liquid]
---

# Liquid 란?

Liquid 는 [Shopify](https://shopify.com) 에서 만들었다
> shopify 는 오프라인 마켓을 온라인으로 옮겨주는 비지니스 플랫폼 솔루션을 제공 해주는 회사 이다  
  
Ruby 를 이용한 오픈소스 템플릿 언어 이다  
2006년 부터 shopify 에서 상용 서비스에 주력으로 사용 했다  
현재는 shopify 이외의 다른 서비스에도 사용 되고 있고 가장 대표적으로 Jekyll 에서 사용하고 있다  

---

# Liquid 문법

Liquid 는 Object, Tag, Filter 이렇게 3개의 카테고리로 분류 할 수 있다  

## Object

```
{%- raw -%}
{{ page.title }}
{% endraw %}
```

Liquid 는 object 를 통해서 컨텐츠에 접근 할 수 있다  

```
{{ page.title }}
```
  
예제의 Liquid 문법이 실행 되면 위와 같은 output 이 나온다  

Liquid Object 는 String, Number, Boolean, Nil, Array 등의 타입을 가질 수 있다  

## Tag

**Escape**

Liquid 문법으로 변환된 상태가 아니라 코드를 그대로 보여주고 싶을때는 아래 처럼 사용한다  

```
{{ "{% raw"}} %}
{%- raw -%}
{{ page.title }}
{% endraw %}
{{ "{% endraw"}} %}
```

**변수**

```
{%- raw -%}
{% assign foo = "bar" %}
{{ foo }}
{% endraw %}
```

**주석**  

```
{%- raw -%}
{% comment %}
주석으로 작성할 내용
{% endcomment %}
{% endraw %}
```

**조건문 (if/elsif/else, case/when)**

```
{%- raw -%}
{% if page.title == "test" %}
    this page is test
{% elsif page.title == "haha" %}
    this page is haha
{% else %}
    this page is default
{% endif %}

{% case page.title %}
    {% when "test" %}
        this page is test
    {% when "haha" %}
        this page is haha
    {% else %}
        this page is fefault
{% endcase %}
{% endraw %}
```

**반복문 (for)**

```
{%- raw -%}
{% for i in (0..4) %}
    {{ i }}
{% endfor %}
{% endraw %}
```

## Filter

Liquid 에서는 데이터를 가공하기 위한 여러가지 filter 를 제공 한다  
[Liquid filter document](https://shopify.github.io/liquid/filters/abs) 를 참고 하자  

---

# Jekyll 에서 Liquid 문법 사용하기

위에서 언급 했던 것 처럼 Jekyll 에서는 Liquid 문법을 지원하고 있다  
단순히 html 만 가지고는 페이지를 만든다면 코드량이 많아지겠지만 Liquid 문법을 이용하면 몇줄의 코드 만으로 다양한 페이지 구현이 가능하게 된다    

## Tags 페이지 만들기

```
{%- raw -%}
<div class="tags">
    <ul class="label">
        {% for tag in site.tags %}
        <li>
            <a href="#{{ tag[0] }}">
                <span>#{{ tag[0] }}</span>
                <span class="count">{{ tag[1] | size }}</span>
            </a>
        </li>
        {% endfor %}
    </ul>

    {% for tag in site.tags %}
    <h2 id="{{ tag[0] }}">
        #{{ tag[0] }}
    </h2>
    <ul class="tag">
        {% for post in tag[1] %}
        {% if post.title != null %}
        <li>
            {% if post.link %}
            <a href="{{ post.link }}">
                {% else %}
                <a href="{{ site.baseurl }}{{ post.url }}">
                    {% endif %}
                    {{ post.title }}
                </a>
                <time>{{ post.date | date: "%Y-%m-%d" }}</time>
        </li>
        {% endif %}
        {% endfor %}
    </ul>
    {% endfor %}
</div>
{% endraw %}
```

## Archive 페이지 만들기

```
{%- raw -%}
<div id="archives-layout">
<div id="archives"></div>
{% assign year = "" %}
{% for post in site.posts %}
    {% capture post_year %}{{ post.date | date: "%Y" }}{% endcapture %}
    {% if year != post_year %}
        {% capture year %}{{ post.date | date: "%Y" }}{% endcapture %}
        <section class="c-archive--time-section">
            <h1 class="c-archive section-year">
                {{ year }}
            </h1>
            <div class="c-archive section-list">
            {% for sub_post in site.posts %}
                {% capture sub_year %}{{ sub_post.date | date: "%Y" }}{% endcapture %}
                {% if year == sub_year %}
                <div class="c-archive section-list-item">
                    <a href="{{ site.baseurl }}{{ sub_post.url }}" class="archive-title">{{ sub_post.title }}</a>
                    <p class="archive-date">{{ sub_post.date | date: "%m-%d" }}</p>
                </div>
                {% endif %}
            {% endfor %}
            </div>
        </section>
        <br>
    {% endif %}
{% endfor %}
</div>
{% endraw %}
```

# 참고자료
- [https://shopify.github.io/liquid](https://shopify.github.io/liquid)