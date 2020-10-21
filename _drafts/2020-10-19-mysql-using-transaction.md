---
layout: post  
comments: true    
title: mysql 의 transaction, isolation level
tags: [mysql, transaction]
---  

## Transaction

transaction 은 데이터의 상태를 변화 시키기 위한 작업의 단위를 말한다.  
가장 적절한 transaction 에 대한 설명은 "은행업무" 케이스 인것 같다.   

A 가 B 에게 10만원을 입금하는 상황  

```
# A 의 계좌에 -10만원
UPDATE BANKBOOK SET money = money - 100000 WHERE user = A;

# B 의 계좌에 +10만원
UPDATE BANKBOOK SET money = money + 100000 WHERE user = B;
```

위의 2가지의 작업은 하나의 transaction 으로 묶어서 처리 할 수 있다.  

---  

## ACID

ACID 란 안전한 데이터 처리를 위한 transaction 의 성질을 말하며, 각각의 앞 글자를 따서 ACID 라고 부른다.  

**Atomicity (원자성)**  
transaction 을 완전히 수행 하거나, 혹은 하나도 실행되지 않음을 말한다. (모아니면 도)    
A 계좌에서는 -10만원이 됐는데 B 계좌에서는 +10만원이 안됐다면 원자성에 위배 되는 것이다.  

**Consistency (일관성)**  
transaction 작업이 성공적으로 수행 됐다면 언제나 일관성 있는 DB의 상태로 유지 되어야 한다.  
말이 너무 어려울수 있는데 transaction 작업이 끝나도 필드타입이나 제한 사항들이 그대로 유지 돼야 한다는 것이다.  

**Isolation (독립성)**  
transaction 작업이 수행되는 동안에 다른 transaction 의 작업이 끼어들지 못하게 보장 하는 것이다.  

**Durability (지속성)**  
transaction 작업이 성공적으로 수행 됐다면 해당 데이터는 영원히 반영 되어야 한다.  

---

## Isolation level

isolation level 이란 동시에 여러 transaction 이 실행 될때 각각의 transaction 서로 어느정도 수준으로 격리 돼 있는지를 나타낸다.  
본격적으로 isolation level 에 대해서 보기 전에 먼저 동시성 문제에 따른 read 트러블 유형에 대해서 알아 보자  

**dirty read**  
![그림으로 넣자]()
T1이 변경한 데이터가 아직 캐시에만 반영 됐고 commit 되지 않은 상태에서 T2 가 해당 데이터를 읽는 행위  
이때 T1이 데이터를 다시 롤백하면 T2가 읽은 데이터는 잘못된 데이터가 된다.  

**unrepeatable read**
![그림으로 넣자]()
T1이 데이터를 읽었는데 T2가 해당 데이터를 변경 또는 삭제 하고 commit 했다.  
이때 다시 T1이 해당 데이터를 읽으면 이전에 읽었던 데이터와 다시 읽은 데이터가 서로 다른 데이터가 된다.  

**phantom read**
![그림으로 넣자]()
T1이 특정 조건으로 데이터를 읽었다. T2는 T1이 검색한 조건중 일부 데이터를 추가 또는 삭제 했다.  
이때 다시 T1이 같은 조건으로 데이터를 읽는 다면 이전에 읽었던 데이터는 추가 또는 삭제 됐을 것 이다.  
여기서 다시 T2가 작업 내용을 commit 하지 않고 rollback 한다면 T1은 존재하지 않는 데이터를 읽게 된 것이다.  

**READ UNCOMMITTED**
- 다른 transaction 이 commit 되지 않은 데이터에 접근 가능
- insert, update, delete 후 commit 이나 rollback 에 상관없이 현재의 데이터를 읽어온다.
- dirty read 가 발생할 수 있으니 주의가 필요  
  - 다른 transaction 이 데이터를 읽었는데 해당 데이터가 rollback 되는 경우  
- lock 이 발생하지 않는다.

**READ COMMITTED**
- 다른 transaction 은 commit 된 데이터에만 접근 가능
- 
 - 다른 transaction 이 데이터를 읽고 난 뒤에 해당 데이터가 commit 되는 경우
- lock 이 발생하지 않는다.

**REPEATABLE READ**
- mysql innoDB storage engine 의 default isolation level  
- dirty read 가 발생하지 않는다 
- record lock, gap lock 발생

**SERIALIZABLE**
- shared lock
  
---

### mysql 의 isolation 확인

```
mysql> SHOW VARIABLES WHERE VARIABLE_NAME='tx_isolation';
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| tx_isolation  | REPEATABLE-READ |
+---------------+-----------------+
1 row in set (0.01 sec)
```

## mysql engine

mysql 은 테이블별로 engine 을 설정할수 있다, x버전 이후 default 는 innoDB 이다.  

```
mysql> SHOW CREATE TABLE TB_TEST \G
*************************** 1. row ***************************
       Table: TB_TEST
Create Table: CREATE TABLE `TB_TEST` (
  `idx` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `amount` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
1 row in set (0.00 sec)
```

### myisam

transaction 미지원  

### innodb

transaction 지원  
row lock 사용

read lock : shared lock
write lock : exclusive lock

read 끼리의 경쟁은 하지 않지만, write 에 대한 경쟁은 제한
read, read : 경쟁 x
read, write : 경쟁
write, read : 경쟁
write, write : 경쟁

default isolation level 은 REPEATABLE  

## locking select

transaction 이 끝나기 전까지만 lock 이 유효하기 때문에 locking select 를 하기 위해서는 auto commit 옵션을 꺼야 한다.

### AUTO COMMIT 이란?

DML 을 이용한 데이터 변경 작업을 즉시 반영하는 상태를 말한다.  
AUTO COMMIT 을 끄게 되면 commit 혹은 rollback 을 만나기 전까지 실행하는 DML 이 하나의 transaction 으로 묶인다.  

```
# autocommit 옵션 여부 체크
mysql> SELECT @@AUTOCOMMIT;

# autocommit 값 세팅
mysql> SET @@AUTOCOMMIT=FALSE;
```

### FOR UPDATE

transaction 이 끝날 때까지 select 로 가져온 row 에 대한 다른 세션의 select, update, delete 를 호출 하지 못하게 한다.

```
mysql> SELECT * FROM TB_TEST WHERE idx = 2 FOR UPDATE
```
> "데이터를 수정하기 위해 SELECT 하는 것이니 다른 사람들은 이 데이터를 건드리지 마세요"  

### LOCK IN SHARE MODE

mysql 8.0 이상 부터는 FOR SHARE 로 변경 됐고, LOCK IN SHARE MODE 도 하위 호환을 위해 동작 한다.  
transaction 이 끝날 때까지 select 한 row 의 값이 변경 되지 않는걸 보장 한다.  
transaction 이 끝나기 전까지만 유효 하기 때문에 auto commit 옵션을 꺼야 한다.  

```
mysql> SELECT * FROM TB_TEST WHERE idx = 2 LOCK IN SHARE MODE
```
> 

## lock

### row-level lock

테이블의 row 마다 걸리는 lock  

- Shared lock (S lock, Read lock)
  - 기존적으로 select 쿼리는 lock 을 사용하지 않음
    - SELECT ... FOR SHARE 등 일부 쿼리는 row 에 S lock 사용
- Exclusive lock (X lock, Write lock)
  - SELECT ... FOR UPDATE, UPDATE, DELETE 등의 수정 쿼리가 발생하면 row 에 X lock 을 사용

### record lock

DB index record 에 걸리는 lock  
이미 존재하는 row 가 변경되는걸 방지

### gap lock

DB index record 들의 사이에 걸리는 lock  
gap 이라는 표현은 index record 와 index record 사이의 공간 이라고 보면 된다.  
- 첫번째 index record 미만 영역
- index record 와 index record 사이 영역
- 마지막 index record 초과 영역
새로운 row 가 추가 되는걸 방지

2개의 mysql session 을 준비 한뒤 아래와 같이 실험 해 보았다.

**session 1**
```
mysql> SELECT * FROM TB_TEST;
+-----+---------+---------+--------+
| idx | user_id | item_id | amount |
+-----+---------+---------+--------+
|   1 |     100 |    1001 |      1 |
|   2 |     200 |    1001 |      1 |
|   3 |     300 |    1001 |      1 |
|   4 |     100 |    1002 |      1 |
|   5 |     200 |    1002 |      1 |
|   6 |     300 |    1002 |      1 |
|   7 |     400 |    1001 |      1 |
+-----+---------+---------+--------+
7 rows in set (0.00 sec)

mysql> START TRANSACTION;
mysql> UPDATE TB_TEST SET amount = 2 WHERE idx = 4;
1 rows in set (0.00 sec)
```

**session 2**
```
mysql> SELECT * FROM TB_TEST WHERE idx < 3 FOR UPDATE;
+-----+---------+---------+--------+
| idx | user_id | item_id | amount |
+-----+---------+---------+--------+
|   1 |     100 |    1001 |      1 |
|   2 |     200 |    1001 |      5 |
+-----+---------+---------+--------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM TB_TEST WHERE idx <= 3 FOR UPDATE;
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction

mysql> SELECT * FROM TB_TEST WHERE idx >= 4 FOR UPDATE;
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction

mysql> SELECT * FROM TB_TEST WHERE idx > 4 FOR UPDATE;
+-----+---------+---------+--------+
| idx | user_id | item_id | amount |
+-----+---------+---------+--------+
|   5 |     200 |    1002 |      2 |
|   6 |     300 |    1002 |      1 |
|   7 |     400 |    1001 |     11 |
+-----+---------+---------+--------+
3 rows in set (0.00 sec)
```

**session 1**
```
mysql> COMMIT;
```

위의 테스트 에서는 session 1 번이 transaction 을 걸고 idx 4번에 대한 amount 필드를 update 한뒤 아직 commit 하지 않았다.  
session 2번은 locking select 를 이용해서 range query 를 실행 했다.  
이때 데이터를 조회 할수 있는 범위는 idx < 3 과 idx > 4 였다. 즉 3과 4가 포함된 range 검색은 lock wait 상태가 됐다.  

lock wait 상태일때 lock 상태를 조회 해 보았다.  
```
mysql> SELECT * FROM information_schema.INNODB_TRX;
+--------+-----------+---------------------+-----------------------+---------------------+------------+---------------------+-------------------------------------------------+---------------------+-------------------+-------------------+------------------+-----------------------+-----------------+-------------------+-------------------------+---------------------+-------------------+------------------------+----------------------------+---------------------------+---------------------------+------------------+----------------------------+
| trx_id | trx_state | trx_started         | trx_requested_lock_id | trx_wait_started    | trx_weight | trx_mysql_thread_id | trx_query                                       | trx_operation_state | trx_tables_in_use | trx_tables_locked | trx_lock_structs | trx_lock_memory_bytes | trx_rows_locked | trx_rows_modified | trx_concurrency_tickets | trx_isolation_level | trx_unique_checks | trx_foreign_key_checks | trx_last_foreign_key_error | trx_adaptive_hash_latched | trx_adaptive_hash_timeout | trx_is_read_only | trx_autocommit_non_locking |
+--------+-----------+---------------------+-----------------------+---------------------+------------+---------------------+-------------------------------------------------+---------------------+-------------------+-------------------+------------------+-----------------------+-----------------+-------------------+-------------------------+---------------------+-------------------+------------------------+----------------------------+---------------------------+---------------------------+------------------+----------------------------+
| 194074 | LOCK WAIT | 2020-10-19 19:41:11 | 194074:13798:3:6      | 2020-10-19 19:42:59 |          2 |                  14 | SELECT * FROM TB_TEST WHERE idx >= 4 FOR UPDATE | starting index read |                 1 |                 1 |                2 |                  1136 |               2 |                 0 |                       0 | REPEATABLE READ     |                 1 |                      1 | NULL                       |                         0 |                         0 |                0 |                          0 |
| 194073 | RUNNING   | 2020-10-19 19:40:54 | NULL                  | NULL                |          3 |                  13 | select * FROM information_schema.INNODB_TRX     | NULL                |                 0 |                 1 |                2 |                  1136 |               1 |                 1 |                       0 | REPEATABLE READ     |                 1 |                      1 | NULL                       |                         0 |                         0 |                0 |                          0 |
+--------+-----------+---------------------+-----------------------+---------------------+------------+---------------------+-------------------------------------------------+---------------------+-------------------+-------------------+------------------+-----------------------+-----------------+-------------------+-------------------------+---------------------+-------------------+------------------------+----------------------------+---------------------------+---------------------------+------------------+----------------------------+
```


```
# 현재 mysql 서버에 접속된 세션들의 상태를 확인
mysql> SHOW FULL PROCESSLIST;

# lock 이 걸려 있는 프로세스를 강제로 죽여서 lock 풀기
mysql> kill [id];

# lock 을 걸고 있는 프로세스 정보
mysql> SELECT * FROM information_schema.INNODB_TRX;

# 현재 lock 이 걸려서 대기중인 정보
mysql> SELECT * FROM information_schema.INNODB_LOCK_WAITS;

# lock을 건 정보
mysql> SELECT * FROM information_schema.INNODB_LOCKS;
```

# 참고자료
- https://ko.wikipedia.org/wiki/ACID