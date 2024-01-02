create database sqldb;
use sqldb;
show databases;
show tables;

# insert
create table testTbl(id int, userName char(3), age int); # 엔티티타입
insert into testTbl values(1, '홍길동', 25);
select * from testTbl;

insert into testTbl values(2, '나나', 25); # 안됨 (자동으로 null 처리 하지 않음)
insert into testTbl(id, userName) values(2, '나나'); # 됨
insert into testTbl(userName, age, id) values('하니', 26, 3); # 됨
select * from testTbl;

# auto_increment -> PK에만 가능
create table testTbl2(id int auto_increment primary key, userName char(3), age int);
insert into testTbl2 values(NULL, '지민', 25);
insert into testTbl2(userName, age) values('길동', 22);
insert into testTbl2(age, userName)  values(21, '유나');
select * from testTbl2;

# auto_increment 입력값을 100부터 시작
alter table testTbl2 auto_increment=100;
insert into testTbl2 values(NULL, '찬미', 23);
select * from testTbl2;

# auto_increment 증가값 지정
create table testTbl3(id int auto_increment primary key, userName char(3), age int);
alter table testTbl3 auto_increment=1000;
set @@auto_increment_increment=3; #서버 변수 -> 3만큼 올라감
insert into testTbl3 values(NULL, '나연', 20);
insert into testTbl3 values(NULL, '정연', 18);
insert into testTbl3 values(NULL, '모모', 19);
select * from testTbl3;

# 대량의 샘플데이터 생성
# varchar -> 공간 동적 할당. 속도 느림 / char -> 공간 정적 할당. 속도 빠름
create table testTbl4(id int, Fname varchar(50), Lname varchar(50));

# 서브쿼리 (쿼리문 안에 쿼리)
insert into testTbl4
select emp_no, first_name, last_name
from employees.employees; # database.table

select * from testTbl4;

# commit - rollback
# where - 조건절: 어디에서 가져올거야
select * from testTbl4 where Fname='Kyoichi';
update testTbl4 set Lname = '없음' where Fname = 'Kyoichi';
select * from testTbl4 where Fname='Kyoichi';

select * from testTbl4 where Fname='Aamer';
# delete 는 rollback 가능
# commit;
savepoint svpt1;

delete from testTbl4 where Fname='Aamer' limit 5; # 5행 삭제
select * from testTbl4 where Fname='Aamer'; 

rollback to svpt1; 
select * from testTbl4 where Fname='Aamer'; 

# auto commit 설정 변경
select @@autocommit; # 세션을 시작할 때 커밋을 자동으로 하는 것 0:off
# 반영이 안됐으면, set autocommit=0;

# 데이터 조회 select
select * from employees.titles;
use employees;
select * from titles;

select first_name, last_name, gender from employees;
# alias 별칭
select first_name as '성', last_name as '이름', gender as '성별' from employees;



