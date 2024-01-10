CREATE DATABASE sqldb_;
USE sqldb_;
SHOW DATABASES;

# INSERT
CREATE TABLE testTbl(id int, userName char(3), age int);
INSERT INTO testTbl VALUES(1, '홍길동', 25);
SELECT * FROM testTbl;

INSERT INTO testTbl VALUES('나나', 25); # 안됨
INSERT INTO testTbl(id, userName) VALUES(3, '나나'); # 됨
INSERT INTO testTbl(age, userName, id) VALUES(26, '하니', 4);
SELECT * FROM testTbl;

# AUTO_INCREMENT -> PK에만 사용 가능
CREATE TABLE testTbl2(id int auto_increment primary key, userName char(3), age int);
INSERT INTO testTbl2 values(NULL, '지민', 25);
INSERT INTO testTbl2(userName, age) values('길동', 22);
INSERT INTO testTbl2(age, userName) values(21, '유나');
SELECT * FROM testTbl2;

# AUTO_INCREMENT 입력값을 100부터 시작
ALTER TABLE testTbl2 auto_increment=100;
INSERT INTO testTbl2 VALUES(NULL, '찬미', 23);
SELECT * FROM testTbl2;

# AUTO_INCREMENT 증가값 지정
CREATE TABLE testTbl3(id int auto_increment primary key, userName char(3), age int);
ALTER TABLE testTbl3 auto_increment=1000;
SET @@auto_increment_increment=3; # 서버변수 설정 -> 3만큼 올라감
INSERT INTO testTbl3 VALUES(NULL, '나연', 20);
INSERT INTO testTbl3 VALUES(NULL, '정연', 18);
SELECT * FROM testTbl3;

# 대량의 샘플데이터 생성
# varchar = 공간 동적 할당. 속도 느림 / char 공간 정적 할당. 속도 빠름
CREATE TABLE testTbl4(id int, Fname varchar(50), Lname varchar(50));
-- 서브 쿼리: 쿼리문 안에 쿼리
INSERT INTO testTbl4
SELECT emp_no, first_name, last_name
FROM employees.employees;
SELECT * FROM testTbl4;

# 테이블 값 업데이트 하기
# WHERE - 조건절: 어디에서 가져올거야
SELECT * FROM testTbl4 WHERE Fname='Kyoichi'; -- testTbl4에서 Fname='Kyoichi'라는 사람의 정보만 조회
UPDATE testTbl4 SET Lname ='없음' WHERE Fname='Kyoichi';
SELECT * FROM testTbl4 WHERE Fname='Kyoichi';

# SAVEPOINT, COMMIT, ROLLBACK
SELECT * FROM testTbl4 WHERE Fname='Aamer';
SAVEPOINT svpt1; -- savepoint 저장
DELETE FROM testTbl4 WHERE Fname='Aamer' LIMIT 5; -- 5행 삭제
SELECT * FROM testTbl4 WHERE Fname='Aamer';
ROLLBACK TO svpt1;
SELECT * FROM testTbl4 WHERE Fname='Aamer';

# AUTO COMMIT 설정
SELECT @@autocommit;

# 데이터 조회 SELECT
SELECT * FROM employees.titles; # -> 현재는 sqldb_가 활성화되어있기 때문에, "database.table_name" 형태로 조회를 함
USE employees;
SELECT * FROM titles; # -> employees 데이터베이스가 활성화 되어있으므로, 그냥 "table_name"으로 조회 가능
# 테이블의 특정 열만 조회하기
SELECT first_name, last_name, gender FROM employees;
# ALIAS 별칭 사용하기
SELECT first_name AS '성', last_name AS '이름', gender AS '성별' FROM employees;


