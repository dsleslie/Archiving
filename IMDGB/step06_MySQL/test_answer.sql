-- 문제 1. SQL 쿼리에서 state와 city가 중복값이 없도록 조회하세요. (state, city 오름차순)
-- DB명 : classicmodels
-- Table명 : customers
 
USE classicmodels;

SELECT DISTINCT
	state
    , city
FROM
	customers
WHERE 
	state IS NOT NULL
ORDER BY
	state
    , city
;

-- 문제 2. 다음과 같이 건당 매출액을 구하세요 (컬럼명 상이시 -5점 감점 처리)
-- DB명 : classicmodels
-- Table명 : orders, orderdetails
SELECT 
	YEAR(orderdate) 연도별
    , COUNT(DISTINCT A.ordernumber) AS 구매자수
    , SUM(priceeach * quantityordered) AS 매출액
    , SUM(priceeach * quantityordered) / COUNT(DISTINCT A.ordernumber) ATV
FROM orders A
LEFT JOIN orderdetails B USING(ordernumber)
GROUP BY 1
ORDER BY 1
;

-- 문제 3. 북미지역 매출액과 비북미지역 매출액을 구하세요!! (컬럼명 및 출력값 다를 경우 -5점 감점 처리)
-- DB명 : classicmodels
-- Table명 : orders, orderdetails, customers
SELECT 
	CASE WHEN country IN ('USA', 'Canada') THEN "북미지역"
		ELSE "비북미지역" END AS 지역구분
    , SUM(B.priceeach * B.quantityordered) 매출액
FROM 
	orders A 
LEFT JOIN orderdetails B
	ON A.ordernumber = B.ordernumber
LEFT JOIN customers C 
	ON A.customernumber = C.customernumber
GROUP BY 1
ORDER BY 1
;

-- 문제 4. 다음과 같이 이탈고객, 마케팅대상고객, 비이탈고객의 명수를 구한다. 
-- 테이블명 : orders
USE classicmodels;
SELECT
	CASE WHEN DIFF >= 90 THEN "이탈고객" 
		 WHEN DIFF >= 45 THEN "마케팅대상고객"
    	ELSE "비이탈고객" 
	END AS 이탈유무
    , COUNT(DISTINCT customernumber) AS 명수
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
ORDER BY 2 DESC
;

-- 문제 5. Top5 국가 및 매출 구하기 (컬럼명 및 출력값 순서 다를 경우 -5점 감점 처리)
-- DB명 : classicmodels
-- Table명 : 수업 때 생성한 stat 테이블 참조 (단, stat_rnk는 참조하지 않는다. 참조 시 0점 처리)
SELECT * 
FROM (
	SELECT 
		country 
		, SALES
		, DENSE_RANK() OVER(ORDER BY SALES DESC) RNK
	FROM stat
) A
WHERE RNK BETWEEN 1 AND 5
;

-- 문제 6. 다음과 같이 여성의 연령대별 생존율을 구한다.  (컬럼명 및 출력값 순서 다를 경우 -5점 감점 처리)
-- DB명 : titanic
-- Table명 : titanic

USE titanic;

SELECT 
	FLOOR(AGE/10)*10 AGEBAND
    , SEX
    , COUNT(PASSENGERID) N_PASSENGERS
    , SUM(SURVIVED) N_SURVIVED
    , SUM(SURVIVED)/COUNT(PASSENGERID) SURVIVED_RATE
FROM titanic
GROUP BY 1,2
HAVING SEX = 'female'
;

-- 문제 7. 아래와 같이 Department별 1-5순위 생성하되 Bottoms만 출력하세요.  
-- DB명 : dataset2
-- TABLE명 : dataset2
USE dataset2;
SELECT *
FROM (
	SELECT 
		*
		, ROW_NUMBER() OVER(PARTITION BY `Department Name` ORDER BY AVG_RATE) RNK
	FROM (
		SELECT 
			`Department Name`
			, `Clothing ID`
			, AVG(Rating) AVG_RATE
		FROM dataset2
		GROUP BY 1, 2
	) A
) A
WHERE RNK <= 5 AND
	`Department Name` = 'Bottoms'
;
