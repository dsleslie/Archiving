USE mydata;

SELECT * FROM dataset3;

-- 국가별, 상품별 구매자 수 및 매출액
SELECT 
	country
    , stockcode
    , COUNT(DISTINCT customerid) BU
    , SUM(quantity * unitprice) SALES
FROM dataset3
GROUP BY 1, 2
ORDER BY 3 DESC, 4 DESC;

-- 특정 상품 구매자가 많이 구매한 상품
-- 장바구니 분석
-- (1) 가장 많이 판매된 Top2 상품을 (2) 모두 구매한 고객이 (3) 구매한 상품 코드 조회

-- 먼저 상품별로 판매된 갯수 
SELECT 
	stockcode
    , SUM(quantity) QTY 
FROM dataset3
GROUP BY 1;

SELECT *
	, ROW_NUMBER() OVER(ORDER BY QTY DESC) RNK
FROM 
(
	SELECT 
		stockcode
		, SUM(quantity) QTY 
	FROM dataset3
	GROUP BY 1
) A
;

-- StockCode 1위, 2위 인 것만 뽑자
SELECT stockcode
FROM (
	SELECT *
		, ROW_NUMBER() OVER(ORDER BY QTY DESC) RNK
	FROM 
	(
		SELECT 
			stockcode
			, SUM(quantity) QTY 
		FROM dataset3
		GROUP BY 1
	) A
) A
WHERE RNK IN (1, 2)
;

-- 가장 많이 판매된 2개 상품을 모두 구매한 구매자가 구매한 상품
-- 첫번째 할일, 고객별로 각각의 상품을 구매했다면 1, 그렇지 않으면 0이 출력되도록 쿼리 
CREATE TABLE mydata.BU_LIST AS 
SELECT customerid
FROM dataset3 
GROUP BY 1
HAVING MAX(CASE WHEN stockcode = '84077' THEN 1 ELSE 0 END) = 1
	AND MAX(CASE WHEN stockcode = '85123A' THEN 1 ELSE 0 END) = 1
;

SELECT * FROM BU_LIST;

SELECT *
FROM dataset3
WHERE customerid IN (SELECT customerid FROM BU_LIST)
	AND stockcode NOT IN ('84077', '85123A');
    
-- 코호트 분석
-- 첫번째 구매일을 구하는 것
SELECT customerid, MIN(invoicedate) MNDT
FROM dataset3
GROUP BY 1
;

-- 각 고객의 주문 일자, 구매액 조회
SELECT customerid, invoicedate, unitprice * quantity AS sales
FROM dataset3;

-- 이 두개의 데이터를 JOIN 
SELECT * FROM
(
	SELECT customerid, MIN(invoicedate) MNDT
	FROM dataset3
	GROUP BY 1
) A 
LEFT JOIN 
(
	SELECT customerid, invoicedate, unitprice * quantity AS sales
	FROM dataset3
) B
ON A.customerid = B.customerid
;

SELECT 
	SUBSTR(MNDT, 1, 7) MM
    , timestampdiff(MONTH, MNDT, invoicedate) AS DATEDIFF
    , COUNT(DISTINCT A.customerid) BU
    , SUM(sales) sales
FROM
(
	SELECT customerid, MIN(invoicedate) MNDT
	FROM dataset3
	GROUP BY 1
) A 
LEFT JOIN 
(
	SELECT customerid, invoicedate, unitprice * quantity AS sales
	FROM dataset3
) B
ON A.customerid = B.customerid
GROUP BY 1, 2
;

-- 고객 세그먼트
-- RFM : 가장 최근 구입 시기 / 빈도수 / 매출
-- 거래의 최근성을 나타내는 지표

SELECT customerid, max(invoicedate) mxdt -- 마지막 구매일자
FROM dataset3
GROUP BY 1;

 SELECT MAX(invoicedate) FROM dataset3;
 
 -- 2011-12-02로부터의 시간차이
 SELECT 
	customerid
	, datediff('2011-12-01', mxdt) recency
FROM (
	SELECT customerid, max(invoicedate) mxdt -- 마지막 구매일자
	FROM dataset3
	GROUP BY 1
) A
;

-- Frequency, Monetary
SELECT 
	customerid
    , COUNT(DISTINCT invoiceNo) frequency
    , SUM(quantity * unitprice) monetary
FROM dataset3
GROUP BY 1
;

SELECT 
	customerid
	, datediff('2011-12-02', mxdt) recency
    , frequency
    , monetary
FROM (
	SELECT 
		customerid
        , max(invoicedate) mxdt -- 마지막 구매일자
		, COUNT(DISTINCT invoiceNo) frequency
		, SUM(quantity * unitprice) monetary
	FROM dataset3
	GROUP BY 1
) A
ORDER BY 2 ASC
;

-- LTV
-- RETENTION RATE / AMV 

-- 2010년 구매자 중에서 2011년에도 구매한 고객의 비율
SELECT 
	COUNT(B.customerid) / COUNT(A.customerid) RETENTION_RATE
FROM
(
	SELECT DISTINCT customerid
    FROM dataset3
    WHERE SUBSTR(invoicedate, 1, 4) = '2010'
) A
LEFT JOIN
(
	SELECT DISTINCT customerid
    FROM dataset3
    WHERE SUBSTR(invoicedate, 1, 4) = '2011'
) B
ON A.customerid = B.customerid
;

-- AMV = 전체 매출액 / 구매 고객수
SELECT SUM(unitprice * quantity) / COUNT(DISTINCT customerid) AMV
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011'
;

-- 2011년의 구매자 수 계산 : 765
SELECT COUNT(DISTINCT customerid) N_BU
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011'
;

-- 2011년 매출액 + 2011년 구매자의 예상 매출액 합하면 
-- 2011년 구매자의 LTV 계산
SELECT 765 * 0.3509; -- 2012년의 예상 고객수 268명

SELECT 268 * 690; -- 2012년 예상 매출액

SELECT SUM(unitprice * quantity) SALES_2011
FROM dataset3
WHERE SUBSTR(invoicedate, 1, 4) = '2011';

SELECT 184920 + 528535; -- 생애 매출
SELECT 713455 / 765; -- 2011년 고객의 LTV

