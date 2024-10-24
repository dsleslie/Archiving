/*
여러 줄 주석
*/
-- 한 줄 주석

-- 간단 체크
SELECT * FROM classicmodels.employees;

-- 데이터 베이스 이거 쓰겠다. 위에 처럼 하면 여러개 불러올 때 다 써야하니 귀찮기 때문
USE classicmodels; 
Select * from employees;

/* SQL 기본 문법
SELECT  컬럼 
FROM 테이블명
WHERE 조건절
GROUP BY 범주 컬럼
HAVING 그룹바이 이후 조건절 (Group by 없이는 사용 불가)
ORDER BY 값 정렬
*/

-- lastName만 출력하자
SELECT lastname From employees;
-- 해당 테이블의 정보를 제공 DESC: Describe, 중간중간에 출력하자
DESC employees;
-- 일반적으로 쿼리 작성 시 추천 방법
SELECT
	lastName      -- 주석 달기도 편하다. 여기에다 컬럼 설명을 쓸 수 있다.
    , firstName   -- , 를 저렇게 찍는게 보기 편하다.
    , jobTitle
FROM
	employees
;

-- SELECT만 사용 without Table
-- 파이썬 코드 예시 : print(1+1)
-- As: Alias
SELECT 1+1 as 결과;
-- 문자열 처리 메서드 중 하나: 오른쪽 공백을 제거하는 메서드
SELECT RTRIM('barbar        ')
-- 현재 날짜 구하기
SELECT now();
SELECT curdate();
-- 글자 이어 붙이는 함수
SELECT concat('cherin',' ','nam') as 'name';
-- order by: 컬럼 정렬
DESC customers;

SELECT 
	salesRepEmployeeNumber
    , contactLastName
    , contactFirstName
From
	customers
ORDER BY 
	salesRepEmployeeNumber ASC -- DESC 내림차순
	, contactLastName ASC
;
-- order by 할 떄랑 where 읽는 순서 다르다.
-- order by
-- From ==> Select ==> orderby 를 읽는다.
-- where
-- From ==> Where ==> Select ==> order by 를 읽는다.
SELECT
	lastName
    , firstName
    , jobTitle AS 직급 
From
	employees
Where
	jobTitle = 'Sales Rep'; -- 직급 = 'Sales 조회 안됨. 순서가 안맞음.
    
-- and, or
SELECT
	lastName
    , firstName
    , jobTitle AS 직급 
    , officeCode
From
	employees
Where
	jobTitle = 'Sales Rep' AND
    officeCode=1
; -- 시험 낼거임.


SELECT
	lastName
    , firstName
    , jobTitle AS 직급 
    , officeCode
From
	employees
Where
	jobTitle = 'Sales Rep' OR 
    officeCode=1

ORder by officeCode ASC
; -- 시험 낼거임.



