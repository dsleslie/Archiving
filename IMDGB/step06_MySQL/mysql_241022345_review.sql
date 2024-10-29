-- 1022
USE classicmodels; -- 데이터베이스 이동

SELECT 
	* 
FROM 
	employees
; -- 데이터베이스 내 사용할 테이블 선언

/* SQL 기본문법
SELECT 컬럼
FROM 테이블명
WHERE 조건절
GROUP BY 범주 컬럼
HAVING 그룹바이 이후 조건절 (GROUP BY 없이는 사용 안함)
ORDER BY 값 정렬
*/

-- 테이블 내 특정 컬럼만 출력
SELECT
	lastname
    , firstName
    , jobTitle
FROM
	employees
;

-- 테이블 정보 제공
DESC employees;

-- python의 print처럼 SELECT 사용
-- table 없이 사용하면 된다.
SELECT 1+1;


-- 간단 sql 함수 몇가지
SELECT RTRIM('blahblah         ');  -- 오른쪽 공백을 없애준다.
SELECT now(); 						-- 현재 날짜, 시, 분, 초 
SELECT curdate();					-- 현재 날짜
SELECT concat('Merry', ' ', 'Christmas'); -- 글자를 이어 붙이는 함수

-- 읽는 순서
-- order by
-- From ==> Select ==> orderby 를 읽는다.
-- where
-- From ==> Where ==> Select ==> order by 를 읽는다.
SELECT * FROM employees;
SELECT
	lastName
    , firstName
    , jobTitle AS 직급
FROM
	employees
WHERE
	jobTitle = 'Sales Rep'
;
    
SELECT
	lastName
    , firstName
    , jobTitle AS 직급
FROM
	employees
WHERE
	jobTitle REGEXP '^Sales'
; -- 정규표현식으로 Sales로 시작하는 것 전부 조회했다

-- and, or
SELECT
	lastName
    , firstName
    , jobTitle AS 직급
    , officeCode
FROM
	employees
WHERE
	jobTitle = 'Sales Rep' AND officeCode=1
; -- 시험 낸대요.

SELECT
	lastName
    , firstName
    , jobTitle AS 직급
    , officeCode
FROM
	employees
WHERE
	jobTitle = 'Sales Rep' OR officeCode=1
ORDER BY officeCode ASC
; -- 시험낸대
    
-- 1023
USE classicmodels;
SELECT
	status
FROM
	orders
GROUP BY
	status
;

-- DISTINCT: 중복을 제거
SELECT
	DISTINCT status
FROM
	orders
;

-- GROUP BY: COUNT()
SELECT
	status
    , COUNT(*) -- COUNT(*)는 각 그룹(status 값)에 속하는 모든 행(*)의 개수를 계산
FROM 
	orders
GROUP BY
	status
;

SELECT
	status
    , COUNT(*) -- COUNT(*)는 각 그룹(status 값)에 속하는 모든 행(*)의 개수를 계산
FROM 
	orders

; -- group by 없으면 에러난다.


SELECT
    COUNT(*) 
FROM 
	orders

;  

SELECT
    SUM(1) 
FROM 
	orders

; --

SELECT
	*
FROM
	orders
;


-- 컬럼 만들기
SELECT * FROM orderdetails;
SELECT
	orderNumber
    , quantityOrdered * priceEach AS 매출액
FROM
	orderdetails
;
    
    
    
