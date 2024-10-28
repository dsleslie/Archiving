/*
---- 제출파일명 변경 : sql_test_241028_수강생명.sql ----
*/

-- 문제 1. SQL 쿼리에서 state와 city가 중복값이 없도록 조회하세요. (state, city 오름차순)
-- DB명 : classicmodels
-- Table명 : customers
USE classicmodels;

SELECT * FROM customers;
SELECT
	DISTINCT state
			, city
FROM 
	customers;

-- 문제 2. 다음과 같이 건당 매출액을 구하세요 (컬럼명 상이시 -5점 감점 처리)
-- DB명 : classicmodels
-- Table명 : orders, orderdetails
USE classicmodels;
SELECT * FROM orders, orderdetails;



-- 문제 3. 북미지역 매출액과 비북미지역 매출액을 구하세요!! (컬럼명 및 출력값 다를 경우 -5점 감점 처리)
-- DB명 : classicmodels
-- Table명 : orders, orderdetails, customers
USE classicmodels;
SELECT * FROM 


-- 문제 4. 다음과 같이 이탈고객, 마케팅대상고객, 비이탈고객의 명수를 구한다. 
-- 테이블명 : orders
USE classicmodels;
SELECT
	CASE WHEN DIFF >= 60 THEN "이탈고객" 
		 WHEN DIFF BETWEEN 15 AND 59 THEN "비이탈고객"
			ELSE "마케팅대상고객" 
		END AS 이탈유무
	,COUNT(DISTINCT customernumber) AS 명수
FROM (
	SELECT 
		customernumber
		, mx_order
		, '2005-06-01'
		, DATEDIFF('2005-06-01', mx_order) AS DIFF
	FROM (
		SELECT 
			customernumber
			, MAX(orderdate) mx_order
		FROM 
			orders
		GROUP BY 1
	) A
) A
GROUP BY 1
;


-- 문제 5. Top5 국가 및 매출 구하기 (컬럼명 및 출력값 순서 다를 경우 -5점 감점 처리)
-- DB명 : classicmodels
-- Table명 : 수업 때 생성한 stat 테이블 참조 (단, stat_rnk는 참조하지 않는다. 참조 시 0점 처리)
USE classicmodels;
CREATE TABLE classicmodels.stat AS
SELECT 
	C.country
    , SUM(B.priceEach * B.quantityOrdered) AS SALES
FROM
	orders A
LEFT JOIN orderdetails B
	ON A.ordernumber = B.ordernumber
LEFT JOIN customers C
	ON A.customerNumber = C.customerNumber
GROUP BY 1
ORDER BY 2 DESC
;
SELECT * FROM stat;
CREATE TABLE classicmodels.stat_ranking AS 
SELECT 
	country
    , SALES
    , rank() OVER(ORDER BY sales DESC) AS RNK
FROM stat
;

-- 매출 top 5 뽑기
-- BETWEEN 연산자 활용
SELECT * FROM stat_ranking
WHERE RNK BETWEEN 1 AND 5;

-- 매출 top 5 뽑기
-- LIMIT 활용
SELECT * FROM stat_ranking
LIMIT 5;


-- 문제 6. 다음과 같이 여성의 연령대별 생존율을 구한다.  (컬럼명 및 출력값 순서 다를 경우 -5점 감점 처리)
-- DB명 : titanic
-- Table명 : titanic
USE titanic;
SELECT * FROM titanic;
SELECT
	FLOOR(AGE/10) * 10 AS AGEBAND
    , Sex AS SEX
	, COUNT(PassengerID) AS N_PASSENGERS
    , SUM(SURVIVED) AS N_SURVIVED
    , SUM(SURVIVED) / COUNT(PassengerID) AS SURVIVED_RATE
FROM titanic
WHERE Sex = 'female'
GROUP BY 1, 2
ORDER BY 1, 2
;



-- 문제 7. 아래와 같이 Department별 1-5순위 생성하되 Bottoms만 출력하세요.  
-- DB명 : dataset2
-- TABLE명 : dataset2
USE dataset2;
SELECT * FROM dataset2;

CREATE TABLE dataset2.stat AS
SELECT 
	`Department Name`
    , `Clothing ID` 
	, AVG(Rating) AS AVG_RATE
FROM dataset2
WHERE 
	`Department Name` = 'Bottoms'
GROUP BY 1, 2
ORDER BY 2 ASC
;

SELECT * FROM stat;
CREATE TABLE dataset2.stat_ranking AS 
SELECT 
	*
    , row_number() OVER(ORDER BY AVG_RATE ASC) AS RNK
FROM stat
;

SELECT * FROM stat_ranking
WHERE RNK BETWEEN 1 AND 5;

