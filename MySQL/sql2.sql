-- 지난 시간 복습
SELECT * FROM employees.titles;
USE employees;
SELECT * FROM titles;
SELECT first_name FROM employees;
SELECT first_name, last_name, gender FROM employees;
SELECT first_name as '성', last_name as '이름', gender as '성별' FROM employees;
SHOW databases;
SHOW tables;
-- 
# 가지고 있는 테이블 정보도 같이 보기
SHOW table status;
# 특정 테이블의 열 정보 확인
DESCRIBE employees; # DESC employees; 와 같음

# new sqldb import (cmd)

USE sqldb;
SHOW tables;
# where절 기본
SELECT * FROM usertbl;
SELECT userID, name FROM usertbl WHERE name = '김경호';
SELECT userID, name, birthYear FROM usertbl WHERE birthYear >= 1970;
SELECT userID, name, height FROM usertbl WHERE height >= 180;

-- 2교시
# 조건문 섞어 쓰기: AND, IN, LIKE
SELECT userID, name, birthYear, height FROM usertbl WHERE birthYear>=1970 && height >= 180;
# BETWEEN: 구간 조회 (AND, IN, LIKE)
# 연속적인 값인 경우
SELECT name, height FROM usertbl WHERE height BETWEEN 180 AND 190;
# 이산적인 값의 조건: IN(value1, value2)
SELECT name, addr FROM usertbl WHERE addr IN('경남', '전남', '전북');
# 문자열 내용 검색: LIKE (~같으면): %는 개수 상관 없이, _는 1개의 문자가 같으면 출력
SELECT name, height FROM usertbl WHERE name LIKE '김%'; # 김
SELECT name, height FROM usertbl WHERE name LIKE '김경_'; # 김

## 서브 쿼리
# 김경호보다 키 큰 사람 찾기 --> 김경호의 키를 서브 쿼리로 불러오기
SELECT height FROM usertbl WHERE name ='김경호';
SELECT name, height FROM usertbl
WHERE height > (SELECT height FROM usertbl WHERE name ='김경호');
# 주소가 경남인 사람의 키보다 크거나 같은 사람 찾기
SELECT name, height FROM usertbl
WHERE height >= (SELECT height FROM usertbl WHERE addr='경남'); # 단일 비교만 가능함 --> ANY, ALL, SOME -> 복수 비교할 때 사용

##  ANY, ALL, SOME, 
# ANY: 기준 중에 하나라도 만족하면 조회
SELECT name, height FROM usertbl
WHERE height >= ANY(SELECT height FROM usertbl WHERE addr='경남');
# ALL: 전부 다 만족하면 조회 (OR)
SELECT name, height FROM usertbl
WHERE height >= ALL(SELECT height FROM usertbl WHERE addr='경남');
# IN: 입력된 값 중에서 하나라도 일치하는 것이 있으면 조회
SELECT name, height FROM usertbl
WHERE height IN(SELECT height FROM usertbl WHERE addr='경남');
SELECT name, height FROM usertbl
WHERE height = ANY(SELECT height FROM usertbl WHERE addr='경남');
# NOT IN
SELECT name, height, addr FROM usertbl
WHERE height NOT IN(SELECT height FROM usertbl WHERE addr='경남');

## GROUP BY 절, 집계 함수 -> 항상 집계 함수와 사용
SELECT * FROM buytbl;
SELECT userID, SUM(amount) FROM buytbl GROUP BY userID;
SELECT userID, COUNT(userID) FROM buytbl GROUP BY userID;
SELECT userID as '사용자 아이디', SUM(amount) as '총구매금액' FROM buytbl GROUP BY userID;
# 전체 구매자가 구한 물품 금액의 평균
SELECT userID as '사용자 아이디', AVG(amount*price) as '평균금액' FROM buytbl GROUP BY userID;
# COUNT(컬럼) -> Null 미포함, COUND(*): Null값 포함
SELECT COUNT(DISTINCT userID) FROM buytbl;
SELECT COUNT(groupName) FROM buytbl;

## HAVING: GROUP BY에서 사용되는 조건절
SELECT userID as '사용자아이디', SUM(amount) as '총구매금액' FROM buytbl
GROUP BY userID
HAVING SUM(amount) > 10;

## ROLL UP: 총합 또는 중간 합계가 필요한 경우 사용 (소합계)
SELECT num, groupName, SUM(price*amount) as '총구매금액'
FROM buytbl
GROUP BY groupName, num
WITH ROLLUP;

-- 3교시
## JOIN: 두 개의 테이블을 서로 묶어서 하나의 결과를 만들어 내는 것 (INNER JOIN/OUTER JOIN/CROSS JOIN/SELF JOIN)
SELECT * FROM buytbl;
SELECT * FROM usertbl;
# INNER JOIN
SELECT * FROM buytbl
INNER JOIN usertbl
ON buytbl.userID = usertbl.userID
WHERE buytbl.userID = 'JYP';
# OUTER JOIN: 조인의 조건에 만족하지 않는 행까지 결과에 포함
# 유저정보기준 구매정보를 뽑아보자.
# 유저id, 제품명, 주소, 전화번호 / FROM 먼저 실행이 되기 때문에 별칭 사용 가능
SELECT u.userID AS '사용자', b.prodName AS '제품명', u.addr AS '주소', CONCAT(u.mobile1, u.mobile2) AS '연락처' FROM usertbl u
LEFT OUTER JOIN buytbl b
ON u.userID = b.userID
ORDER BY u.userID DESC; # ASC: 오름차순, DESC: 내림차순
# CROSS JOIN: 전체 경우의 수를 다 만들어 줌
USE employees;
SELECT COUNT(*) AS '데이터 수' FROM employees
CROSS JOIN titles;
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM titles;
# SELF JOIN -> 계층형일 때.. (거의 사용 안함)
