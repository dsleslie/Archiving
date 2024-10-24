USE classicmodels;
SELECT 
	status
FROM 
	orders
GROUP BY 
	status
;

-- DISTINCT
SELECT
	status
    , COUNT(*) -- count(*): status 숫자 세는 거
FROM
	orders
GROUP BY
	status
;

-- 테이블명 : orderdetails
SELECT * FROM orderdetails;

SELECT
	orderNumber
    , quantityOrdered * priceEach AS 매출액 -- 컬럼끼리 계산 가능
FROM
	orderdetails;
    
-- 주문번호당, 총매출액, 평균매출액을 구하세요
SELECT *
FROM orderdetails;

SELECT productCode
	, orderLineNumber
    , SUM(quantityOrdered * priceEach) AS 총매출액
    , AVG(quantityOrdered * priceEach) AS 평균매출액
    , stddev_samp(quantityOrdered * priceEach) AS 표준편차
    , var_samp(quantityOrdered * priceEach) AS 분산
FROM 
	orderdetails
GROUP BY 
	productCode
    , orderLineNumber
ORDER BY
	productCode
    , orderLineNumber
;

-- HAVING
-- 순서 : FROM ==> WHERE ==> GROUP BY ==> HAVING ==> SELECT ==> ...
-- 위에 있는 코드에서 HAVING 절 추가
-- orderLineNumber에서 1만 별도로 조회

SELECT productCode
	, orderLineNumber
    , SUM(quantityOrdered * priceEach) AS 총매출액
    , AVG(quantityOrdered * priceEach) AS 평균매출액
    , stddev_samp(quantityOrdered * priceEach) AS 표준편차
    , var_samp(quantityOrdered * priceEach) AS 분산
FROM 
	orderdetails
GROUP BY 
	productCode
    , orderLineNumber
HAVING
	orderLineNumber = 1 
    AND 총매출액 >= 10000
ORDER BY
	productCode
    , orderLineNumber
;


-- 테이블명 : orderdetails
-- 출력값 
-- ordernumber 주문갯수 매출액 
-- 10100       151    10223.83 
-- 조건 : 주문갯수 700개 이상만 조회
-- 주문번호 : 10222
SELECT * FROM orderdetails;
SELECT 
	ordernumber
    , 
FROM 
	orderdetails
;