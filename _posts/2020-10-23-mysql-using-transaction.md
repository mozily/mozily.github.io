---
layout: post  
comments: true    
title: mysql 의 transaction, isolation level
tags: [mysql, transaction, isolation, lock]
---  

## Transaction

transaction 은 데이터의 상태를 변화 시키기 위한 작업의 단위를 말한다  
가장 적절한 transaction 에 대한 설명은 "은행업무" 케이스 인것 같다   

A 가 B 에게 10만원을 입금하는 상황  

```
# transaction 시작
mysql> START TRANSACTION;

# A 의 계좌에 -10만원
mysql> UPDATE BANKBOOK SET money = money - 100000 WHERE user = 'A';

# B 의 계좌에 +10만원
mysql> UPDATE BANKBOOK SET money = money + 100000 WHERE user = 'B';

# 작업한 transaction 을 적용
mysql> COMMIT;
```

위의 2가지의 작업은 하나의 transaction 으로 묶어서 처리 할 수 있다  

---  

## ACID

ACID 란 안전한 데이터 처리를 위한 transaction 의 성질을 말하며, 각각의 앞 글자를 따서 ACID 라고 부른다  

**Atomicity (원자성)**  
transaction 을 완전히 수행 하거나, 혹은 하나도 실행되지 않음을 말한다 (모아니면 도)    
A 계좌에서는 -10만원이 됐는데 B 계좌에서는 +10만원이 안됐다면 원자성에 위배 되는 것이다  

**Consistency (일관성)**  
transaction 작업이 성공적으로 수행 됐다면 언제나 일관성 있는 DB의 상태로 유지 되어야 한다  
말이 너무 어려울수 있는데 transaction 작업이 끝나도 필드타입이나 제한 사항들이 그대로 유지 돼야 한다는 것이다  

**Isolation (독립성)**  
transaction 작업이 수행되는 동안에 다른 transaction 의 작업이 끼어들지 못하게 보장 하는 것이다  

**Durability (지속성)**  
transaction 작업이 성공적으로 수행 됐다면 해당 데이터는 영구적으로 반영 되어야 한다  

---

## Isolation level

isolation level 이란 동시에 여러 transaction 이 실행 될때 각각의 transaction 이 서로 어느정도 수준으로 격리 돼 있는지를 나타낸다  
  
```
mysql> SHOW VARIABLES WHERE VARIABLE_NAME='tx_isolation';
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| tx_isolation  | REPEATABLE-READ |
+---------------+-----------------+
1 row in set (0.01 sec)
```

mysql 의 default isolation level 은 REPEATABLE READ 이다


**READ UNCOMMITTED**  

```
mysql> SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
mysql> SHOW VARIABLES WHERE VARIABLE_NAME='tx_isolation';
+---------------+------------------+
| Variable_name | Value            |
+---------------+------------------+
| tx_isolation  | READ-UNCOMMITTED |
+---------------+------------------+
1 row in set (0.00 sec)
```

다른 transaction 이 commit 되지 않은 데이터에 접근 가능  
dirty read, non-repeatable read, phantom read 발생  
lock 이 발생하지 않는다.  

**READ COMMITTED**  

```
mysql> SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
mysql> SHOW VARIABLES WHERE VARIABLE_NAME='tx_isolation';
+---------------+----------------+
| Variable_name | Value          |
+---------------+----------------+
| tx_isolation  | READ-COMMITTED |
+---------------+----------------+
1 row in set (0.00 sec)
```

다른 transaction 은 commit 된 데이터에만 접근 가능  
non-repeatable read, phantom read 발생  
lock 이 발생하지 않는다.  

**REPEATABLE READ**  

```
mysql> SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
mysql> SHOW VARIABLES WHERE VARIABLE_NAME='tx_isolation';
+---------------+-----------------+
| Variable_name | Value           |
+---------------+-----------------+
| tx_isolation  | REPEATABLE-READ |
+---------------+-----------------+
1 row in set (0.00 sec)
```

mysql innoDB storage engine 의 default isolation level  
phantom read 발생  
record lock, gap lock 발생  

**SERIALIZABLE**  

```
mysql> SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
mysql> SHOW VARIABLES WHERE VARIABLE_NAME='tx_isolation';
+---------------+--------------+
| Variable_name | Value        |
+---------------+--------------+
| tx_isolation  | SERIALIZABLE |
+---------------+--------------+
1 row in set (0.00 sec)
```

최고수준의 격리 단계 이지만 성능은 좋지 않다  
read 트러블이 발생하지 않음  
shared lock 발생

---

## Isolation level 에 따른 read 트러블  

**Dirty read**  

```
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 100000 |
|   2 | B    |      0 |
+-----+------+--------+

# T1
mysql> START TRANSACTION;
mysql> UPDATE BANKBOOK SET money = money + 100000 WHERE user = 'A';

# T2
mysql> SELECT * FROM BANKBOOK WHERE user = 'A';
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 200000 |
|   2 | B    |      0 |
+-----+------+--------+
2 rows in set (0.00 sec)
```

T1 이 transaction 을 걸고 데이터를 변경 하고 있다  
변경한 데이터들은 아직 commit 되지 않아서 캐시 에만 반영 돼 있다  
이 상태에서 다른 transaction 인 T2 가 commit 되지 않은 데이터를 읽는 것을 dirty read 라고 한다  

**Non-Repeatable read**

```
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 100000 |
|   2 | B    |      0 |
+-----+------+--------+

# T1
mysql> START TRANSACTION;
mysql> SELECT * FROM BANKBOOK;
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 100000 |
|   2 | B    |      0 |
+-----+------+--------+
2 rows in set (0.00 sec)

# T2
mysql> START TRANSACTION;
mysql> UPDATE BANKBOOK SET money = money + 100000 WHERE user = 'A';
mysql> COMMIT;

# T1
mysql> SELECT * FROM BANKBOOK;
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 200000 |
|   2 | B    |      0 |
+-----+------+--------+
2 rows in set (0.00 sec)

mysql> 
```

T1 이 데이터를 읽었는데 T2 가 해당 데이터를 변경하고 commit 했다  
이때 다시 T1 이 해당 데이터를 읽으면 이전에 읽었던 데이터와 다시 읽은 데이터가 달라진다  
위처럼 하나의 transaction 안에서 반복적으로 동일한 데이터를 조회 할때  
데이터가 달라지는 것을 non-repeatable read 라고 한다  

**Phantom read**

```
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 100000 |
|   2 | B    |      0 |
+-----+------+--------+

# T1
mysql> START TRANSACTION;
mysql> INSERT INTO BANKBOOK(user, money) VALUES('C', 200000);

# T2
mysql> START TRANSACTION;
mysql> SELECT * FROM BANKBOOK;
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 100000 |
|   2 | B    |      0 |
|   3 | C    | 200000 | 
+-----+------+--------+

# T1
mysql> ROLLBACK;
```

T1 이 transaction 상태에서 데이터를 추가 했다. (C를 추가 함)  
T2 가 데이터를 읽었다. (이때는 C가 존재함)  
T1 이 transaction 을 롤백 했다  
T2 입장에서는 C 의 데이터에 대해서 phantom read 가 된것이다    
  
---

## mysql engine

mysql 은 테이블별로 engine 을 설정할수 있다, default 는 innoDB 이다  

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

대표적으로 사용하는 2개의 engine 에 대해서만 비교 해보자  

**MyISAM**  
mysql 5.5,4 까지 default engine  
transaction 미지원  
select 속도가 빠르다  
table lock 을 사용하기 때문에 insert, update 속도가 느리다    
데이터의 변경 보다는 읽기가 많은 작업에 적합  

**InnoDB**  
mysql 5.5.5 부터 default engine  
transaction 지원  
row lock 을 사용하기 때문에 insert, update 속도가 빠르다    
데이터 변경이 잦은 작업에 적합  

--- 

## AUTO COMMIT
  
쿼리를 이용한 데이터 변경 작업을 즉시 반영하는 상태를 말한다.  
auto commit 을 끄게 되면 commit 혹은 rollback 을 만나기 전까지 실행하는 query 들이 하나의 transaction 으로 묶인다.  

```
# autocommit 옵션 여부 체크
mysql> SELECT @@AUTOCOMMIT;

# autocommit 값 세팅
mysql> SET @@AUTOCOMMIT=FALSE;
```

---

## lock 이 적용되는 요소에 따른 분류

InnoDB 에서 transaction 을 사용할때 다양한 lock 이 걸릴수 있다  
아래에 언급된 lock 들은 transaction 이 끝나기 전까지만 유효하기 때문에 테스트를 위해서는 auto commit 옵션을 꺼야 한다  

**Shared lock** (S-lock)  
row 에 걸리는 row lock  
select 를 할때 발생하는 read lock  

**Exclusive lock** (X-lock)  
row 에 걸리는 row lock  
update, delete 할때 발생하는 write lock  

**Intention lock** (IS-lock, IX-lock)  
table 에 걸리는 table lock  
"테이블의 row 에 lock 이 걸릴 것 이다" 라고 미리 선언하는 느낌  
아래와 같은 상황에서 Intention lock 이 걸릴수 있음  
1. locking read 를 사용 할 경우  
- SELECT .. LOCK IN SHARE MODE (mysql 8.0 부터는 FOR SHARE 로 변경 됨)  
  - row 에 S-lock 을 걸기 전에 table 에 IS-lock 을 건다  
- SELECT .. FOR UPDATE  
  - row 에 X-lock 을 걸기 전에 table 에 IX-lock 을 건다  
2. alter table, drop table 같은 DDL 이 실행 될 경우  

---

## lock 이 적용되는 상황에 따른 분류

**Record lock**  
index record 에 lock 을 거는 것  
locking read 를 할때 발생 한다.
```
# BANKBOOK 테이블의 idx 1번에 S-lock 을 건다. 
mysql> SEELCT * FROM BANKBOOK WHERE idx = 1 LOCK IN SHARE MODE;

# BACKBOOK 테이블의 idx 1번에 X-lock 을 건다.
mysql> SELECT * FROM BANKBOOK WHERE idx = 1 FOR UPDATE;
```  

**Gap lock**  
index record 와 index record 사이(gap)의 공간에 걸리는 lock    
- 첫번째 index record 미만 영역
- index record 와 index record 사이 영역
- 마지막 index record 초과 영역  

같은 query 로 select 를 두번 했을때 같은 결과를 보장 해준다 (phantom read 방지)

```
# T1
mysql> START TRANSACTION;
mysql> SELECT * FROM BANKBOOK WHERE idx BETWEEN 2 AND 5 FOR UPDATE;

# T2
mysql> INSERT INTO BANKBOOK(idx, user, money) VALUES(3, 'D', 100000); 
```
위와 같은 상황에서 T1 이 잡은 gap lock 에 의해 T1 가 commit 되기 전까지 gap lock 이 잡히게 된다  

**Next-key lock**  
Record lock 과 Gap lock 이 합쳐진 복합적인 lock  
row 의 값을 변경할 경우 해당 row 에는 record lock 이 걸리고, 해당 row 부터 다음 row 의 사이에는 gap lock 이 걸린다  

**Insert intention lock**  
row 를 insert 하기전 발생하는 특수한 형태의 gap lock  
locking read 처럼 명시적으로 발생하지 않고, insert 가 실행 될때 묵시적으로 발생하는 lock
insert 를 하기위에 X-lock 을 걸기전 insert intention lock 을 먼저 건다  
여러개의 transaction 이 gap 안에서 서로 다른 위치에 insert 를 수행 할때 대기하지 않도록 하기 위해 사용    

```
+-----+------+--------+
| idx | user | money  |
+-----+------+--------+
|   1 | A    | 100000 |
|   5 | B    | 200000 | 
+-----+------+--------+

# T1
mysql> START TRANSACTION;
mysql> INSERT INTO BANKBOOK(idx, user, money) VALUES(4, 'C', 300000);

# T2
mysql> START TRANSACTION;
mysql> INSERT INTO BANKBOOK(idx, user, money) VALUES(3, 'D', 400000);

# T3
mysql> START TRANSACTION;
mysql> INSERT INTO BANKBOOK(idx, user, money) VALUES(2, 'E', 500000);
```

만약 gap lock 을 사용 했더라면  
> T1 의 insert 에서 1 ~ 4 에 gap lock 이 설정 된다   
> T2 의 insert 에서 T1 이 건 gap lock 에 의해 대기상태가 된다    
> T3 의 insert 에서 위와 같은 이유로 대기상태가 된다  

Insert intention lock 을 사용 한다면 (실제 InnoDB 의 동작 방식)  
> T1 의 insert 에서 1 ~ 4 에 insert intention lock 이 설정 된다  
> T2 의 insert 에서 T1 이 insert intention lock 을 걸긴 했지만 pk 가 겹치지 않기 때문에 바로 실행 된다  
> T3 의 insert 에서 위와 같은 이유로 바로 실행 된다  

**Auto-increment lock**  
transaction 이 여러개 실행 될때 table 의 auto_increment 필드 값을 중복되지 않게 증가 시키기 위해 사용  

---

## lock 상태 체크

lock wait 상태일때 lock 상태를 조회 방법   
```
mysql> SELECT * FROM information_schema.INNODB_TRX;
+--------+-----------+---------------------+-----------------------+---------------------+------------+---------------------+--------------------------------------------------+---------------------+-------------------+-------------------+------------------+-----------------------+-----------------+-------------------+-------------------------+---------------------+-------------------+------------------------+----------------------------+---------------------------+---------------------------+------------------+----------------------------+
| trx_id | trx_state | trx_started         | trx_requested_lock_id | trx_wait_started    | trx_weight | trx_mysql_thread_id | trx_query                                        | trx_operation_state | trx_tables_in_use | trx_tables_locked | trx_lock_structs | trx_lock_memory_bytes | trx_rows_locked | trx_rows_modified | trx_concurrency_tickets | trx_isolation_level | trx_unique_checks | trx_foreign_key_checks | trx_last_foreign_key_error | trx_adaptive_hash_latched | trx_adaptive_hash_timeout | trx_is_read_only | trx_autocommit_non_locking |
+--------+-----------+---------------------+-----------------------+---------------------+------------+---------------------+--------------------------------------------------+---------------------+-------------------+-------------------+------------------+-----------------------+-----------------+-------------------+-------------------------+---------------------+-------------------+------------------------+----------------------------+---------------------------+---------------------------+------------------+----------------------------+
| 194074 | LOCK WAIT | 2020-10-19 19:41:11 | 194074:13798:3:6      | 2020-10-19 19:42:59 |          2 |                  14 | SELECT * FROM BANKBOOK WHERE idx >= 4 FOR UPDATE | starting index read |                 1 |                 1 |                2 |                  1136 |               2 |                 0 |                       0 | REPEATABLE READ     |                 1 |                      1 | NULL                       |                         0 |                         0 |                0 |                          0 |
| 194073 | RUNNING   | 2020-10-19 19:40:54 | NULL                  | NULL                |          3 |                  13 | select * FROM information_schema.INNODB_TRX      | NULL                |                 0 |                 1 |                2 |                  1136 |               1 |                 1 |                       0 | REPEATABLE READ     |                 1 |                      1 | NULL                       |                         0 |                         0 |                0 |                          0 |
+--------+-----------+---------------------+-----------------------+---------------------+------------+---------------------+--------------------------------------------------+---------------------+-------------------+-------------------+------------------+-----------------------+-----------------+-------------------+-------------------------+---------------------+-------------------+------------------------+----------------------------+---------------------------+---------------------------+------------------+----------------------------+
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

---

# 참고자료
- [https://ko.wikipedia.org/wiki/ACID](https://ko.wikipedia.org/wiki/ACID)
- [MySQL InnoDB lock & deadlock 이해하기](https://www.letmecompile.com/mysql-innodb-lock-deadlock)