USE classicmodels;

-- 구매 지표 추출
-- 일자별 매출액  
-- 테이블 : orders, orderdetails 
SELECT 
	A.orderdate, 
    SUM(priceeach * quantityOrdered) AS 매출액
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1;

-- 월별 매출액
-- substr() : 문자열에서 원하는 부분만 가져오기
-- substr(컬럼, 위치, 길이)
-- 컬럼, 위치 : 시작 텍스트의 위치, 길이, 몇개의 텍스트를 가져오기 숫자 지정
SELECT SUBSTR('ABCDE', 2, 3);

SELECT 
	SUBSTR(A.orderdate, 1, 7) month, 
    SUM(priceeach * quantityOrdered) AS 매출액
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1;

-- 연도별 매출액 조회
SELECT 
	SUBSTR(A.orderdate, 1, 4) month, 
    SUM(priceeach * quantityOrdered) AS 매출액
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1;

-- 구매자 수, 구매 건수(일자별, 월별, 연도별)
SELECT 
	COUNT(ordernumber) NUM_ORD
    , COUNT(DISTINCT ordernumber)
FROM orders;

SELECT 
	orderdate
    , COUNT(ordernumber) NUM_ORD
    , COUNT(DISTINCT ordernumber)
FROM orders
GROUP BY 1;

-- 인당 매출액 (연도별)
SELECT 
	SUBSTR(A.orderdate, 1, 4) AS 연도
    , COUNT(DISTINCT A.customernumber) AS 구매자수
    , SUM(priceeach * quantityOrdered) AS 매출액
    , SUM(priceeach * quantityOrdered) / COUNT(DISTINCT A.customernumber) AS AMV
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1;

-- 건당 구매 금액(ATV, Average Transaction Value)
-- 1건의 거래는 평균적으로 얼마의 매출을 발생 시키는가? 
SELECT 
	SUBSTR(A.orderdate, 1, 4) AS 연도
    , COUNT(DISTINCT A.ordernumber) AS 구매건수
    , SUM(priceeach * quantityOrdered) AS 매출액
    , SUM(priceeach * quantityOrdered) / COUNT(DISTINCT A.ordernumber) AS ATV
FROM orders A
LEFT JOIN orderdetails B
ON A.ordernumber = B.ordernumber
GROUP BY 1;

-- 셀프조인 (orders)
SELECT 
	A.customernumber
    , A.orderdate
    , B.customernumber
    , B.orderdate
FROM orders A
LEFT JOIN orders B
ON A.customernumber = B.customernumber AND
	SUBSTR(A.orderdate, 1, 4) = SUBSTR(A.orderdate, 1, 4)
;

SELECT C.COUNTRY,
SUBSTR(A.ORDERDATE,1,4) YY,
COUNT(DISTINCT A.CUSTOMERNUMBER) BU_1,
COUNT(DISTINCT B.CUSTOMERNUMBER) BU_2,
COUNT(DISTINCT B.CUSTOMERNUMBER)/COUNT(DISTINCT A.CUSTOMERNUMBER)
RETENTION_RATE
FROM CLASSICMODELS.ORDERS A
LEFT
JOIN CLASSICMODELS.ORDERS B
ON A.CUSTOMERNUMBER = B.CUSTOMERNUMBER AND SUBSTR(A.ORDERDATE,1,4)
= SUBSTR(B.ORDERDATE,1,4)-1
LEFT
JOIN CLASSICMODELS.CUSTOMERS C
ON A.CUSTOMERNUMBER = C.CUSTOMERNUMBER
GROUP
BY 1,2
;

SELECT MAX(orderdate) MX_ORDER
FROM orders;

-- 2005-6-1일을 기준으로 각 고객의 마지막 구매일이 며칠 소요되었는지 구해보자
SELECT customernumber, MAX(orderdate) MX_order
FROM orders
GROUP BY 1;

-- DATEDIFF()
SELECT 
	customernumber
    , MX_ORDER 
    , '2005-06-01'
    , DATEDIFF('2005-06-01', MX_ORDER) DIFF
FROM (
	SELECT customernumber, MAX(orderdate) MX_order
	FROM orders
	GROUP BY 1
) A 
;

-- DIFF 90일 이상인 경우를 비활동고객, churn이라 가정하자
SELECT * 
	, CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE
FROM (
	SELECT 
		customernumber
		, MX_ORDER 
		, '2005-06-01'
		, DATEDIFF('2005-06-01', MX_ORDER) DIFF
	FROM (
		SELECT customernumber, MAX(orderdate) MX_order
		FROM orders
		GROUP BY 1
	) A 
) AA
;

-- 계산 
-- DIFF 90일 이상인 경우를 비활동고객, churn이라 가정하자
SELECT 
	CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE
    , COUNT(DISTINCT CUSTOMERNUMBER) N_CUS
FROM (
	SELECT 
		customernumber
		, MX_ORDER 
		, '2005-06-01'
		, DATEDIFF('2005-06-01', MX_ORDER) DIFF
	FROM (
		SELECT customernumber, MAX(orderdate) MX_order
		FROM orders
		GROUP BY 1
	) A 
) AA
GROUP BY 1
;

SELECT 69 / (69 + 29);