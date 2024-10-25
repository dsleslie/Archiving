-- 서브쿼리
-- 테이블명 : employees, offices
-- USA에 근무하는 employee 찾고 싶음
SELECT * FROM employees;
SELECT * FROM offices;

-- 풀어가는 방식
-- 메인쿼리, 서브쿼리 가 있다
-- 메인쿼리를 정의 내려야 한다
-- 메인쿼리: 직원 찾기 : lastname, firstname, email employee 테이블alter
-- 서브쿼리: USA를 찾자 , officies에서
SELECT
	lastname
    , firstname
    , email
FROM
	employees
;
-- 이 위가 메인쿼리
SELECT * FROM offices WHERE country = 'USA';
-- 이게 서브쿼리. 연결만 하면 됨. -> 연결하려면 둘다 있는 키 값인 officeCode로 연결
SELECT officeCode FROM offices WHERE country = 'USA';
-- 아래는 수동으로 구한 거
SELECT 
	lastname
	,firstname
    , email 
FROM employees 
WHERE officecode IN (1,2,3);	
-- 서브쿼리로 합쳐보자
SELECT 
	lastname
	,firstname
    , email 
FROM employees 
WHERE officecode IN (
	SELECT officeCode FROM offices WHERE country = 'USA'
)
;
-- 메인 쿼리, 서브쿼리를 구분하는 게 문제임.

-- 문제: 최소금액의 결제를 한 고객 찾기
-- 테이블명: Payments
-- 함수 : MIN()
-- 메인쿼리: customerNumber
-- 서브쿼리: 최소 금액 결제
SELECT customerNumber, checkNumber, amount FROM payments;
SELECT MIN(amount) FROM Payments;
-- 두개의 쿼리 합치기
SELECT customerNumber, checkNumber, amount FROM payments 
WHERE amount = (SELECT MIN(amount) FROM Payments);

-- amount의 평균보다 더 초과해서 구매한 고객 조회
SELECT 
	customerNumber
    , checkNumber
    , amount 
FROM payments 
WHERE amount > (SELECT 
					AVG(amount) 
                    FROM Payments
	)
; -- 여기다가 주석 달면 된다

-- 주문갯수가 50개 초과인, 주문번호와 주문날짜를 구하시오
-- 테이블명: orders, orderdetails
-- 메인쿼리: 주문번호, 주문 날짜 출력
-- 서브쿼리 : 주문갯수 50개 초과
SELECT orderNumber
	, orderdate 
FROM orders
WHERE orderNumber 
IN (
	SELECT orderNumber 
	FROM orderdetails 
	where quantityOrdered > 50
)
;
SELECT orderNumber FROM orderdetails where quantityOrdered > 50;
-- JOIN으로 하는 방법
SELECT DISTINCT A.ordernumber, orderdate, B.quantityOrdered
FROM orders A
JOIN orderdetails B ON A.orderNumber = B.orderNumber
WHERE B.quantityOrdered > 50;

-- 메인쿼리 : 주문번호와 주문날짜 출력
SELECT 
	ordernumber, orderdate
FROM orders
WHERE ordernumber IN (
	SELECT ordernumber FROM orderdetails WHERE quantityOrdered > 50
)
;

-- 문제: 주문을 아예 하지 않은 고객명 조회
-- 테이블 명: customers, orders
-- HINT : NOT IN 연산자 사용
-- 메인쿼리: 고객명 조회
-- 서브쿼리: 주문 하지 않은 고객명
SELECT 
	customerName 
FROM 
	customers 
WHERE 
	customerNumber 
	NOT IN 
    (
    SELECT 
		customerNumber 
	FROM 
		orders
)
;

-- 주문을 한 고객 만 조회
SELECT DISTINCT customernumber from orders;
-- 강사님
SELECT 
	customerName 
FROM 
	customers 
WHERE 
	customerNumber 
	NOT IN 
    (SELECT DISTINCT customernumber from orders
	)
;

-- 인라인 뷰, FROM 절 서브쿼리
-- 임시 테이블 생성? 이런 느낌으로 접근
-- 각 주문의 최대, 최소, 평균을 한꺼번에 표시하고 싶다
SELECT
	ordernumber, count(ordernumber) AS items
FROM orderdetails
GROUP BY ordernumber
;

SELECT
	MAX(주문건수), MIN(주문건수), AVG(주문건수) AS 평균주문건수
FROM (
	SELECT
	ordernumber, count(ordernumber) AS 주문건수
	FROM orderdetails
	GROUP BY ordernumber
) a
;

-- 예제
-- 가장 비싼 생산품 5개를 출력하세요
-- FROM절 서브쿼리 활용
-- productName, buyPrice
-- HINT: ORDER BY절 활용
SELECT * FROM products;
SELECT 
	productName
    , buyPrice 
FROM (
	SELECT *
    FROM products
    ORDER BY buyPrice DESC
    
) A
LIMIT 5 -- 위에섭 부터 5개만 출력
;

-- 예제
-- 각 제품의 평균 주문 수량 찾기
-- FROM 절 서브쿼리 사용
-- 출력값: productCode, avgQuantity
-- 조건: avgQuantity 내림차순 정렬
SELECT * FROM products;
SELECT 
	productCode
    , AVG(quantityOrdered) AS avgQuantity
FROM 
	orderdetails
GROUP BY productCode
ORDER BY avgQuantity DESC
;

-- from 절 서브쿼리로..
SELECT *
FROM
	(SELECT 
		productCode
		, AVG(quantityOrdered) AS avgQuantity
	FROM 
		orderdetails
	GROUP BY productCode
	) A
ORDER BY avgQuantity DESC
;


/* 윈도우 함수 
*/
-- 매출 Top5 국가 및 매출 -- 문제 낸다. --1023씩 한건 똑같이 낸다.
-- 국가별 매출
-- CREATE TABLE classicmodels.stat AS
SELECT 
	C.country
    , SUM(B.priceEach * B.quantityOrdered) AS sales
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

-- 등수를 매겨보자 -- RANK 윈도우 함수 적용
CREATE TABLE classicmodels.stat_rnk AS 
SELECT 
	country
    , SALES
    , dense_rank() OVER(ORDER BY SALES DESC) RNK
FROM stat
;
-- 매출 top 5 뽑기
-- BETWEEN 연산자 활용
SELECT * FROM stat_rnk
WHERE RNK BETWEEN 1 AND 5;

SELECT * FROM stat_rnk
LIMIT 5;

-- 예제
-- 테이블 생성 : product_sales
-- 출력값 : SELECT * FROM product_sales
-- 미국시장만 조회
-- productname sales 
-- 1952 ~~ 78860.11
CREATE TABLE classicmodels.product_sales AS
SELECT 
	D.productname
    , SUM(B.priceEach * B.quantityOrdered) AS sales
FROM 
	orders A
LEFT JOIN orderdetails B
	ON A.ordernumber = B.ordernumber
LEFT JOIN customers C 
	ON A.customerNumber = C.customerNumber
LEFT JOIN products D
	ON B.productcode = D.productcode
WHERE C.country = 'USA'
GROUP BY 1
;

SELECT * FROM product_sales;
SELECT
	*
    , ROW_NUMBER() OVER(ORDER BY SALES DESC) RNK
FROM product_sales
LIMIT 5
; -- 인라인 뷰(조인문), 윈도우 함수  조합으로 코드를 작성한 것

-- Churn Rate(%) 구하기
-- 이 테이블의 마지막 구매일 확인
SELECT MIN(orderdate) AS mx_order
FROM orders
;

SELECT MAX(orderdate) AS mx_order
FROM orders
;

-- 2005-06-01을 기준으로 마지막 구매일과의 차이 일자 구하기
-- 각 고객의 마지막 구매일을 구할 수 있음
SELECT
	customernumber
    , MAX(orderdate) mx_order
FROM
	orders
GROUP BY 1
;

-- 2005-06-01을 기준으로 
-- 각 고객의 마지막 구매일을 구할 수 있음
SELECT
	customernumber
    , MAX(orderdate) mx_order
FROM
	orders
GROUP BY 1
;

SELECT DATEDIFF('2005-06-01', '2004-11-25');

SELECT 
	customerNumber
    , mx_order
    , '2005-06-01'
    , DATEDIFF('2005-06-01', mx_order) DIFF
FROM (
SELECT
	customernumber
    , MAX(orderdate) mx_order
FROM
	orders
GROUP BY 1
) A
;

-- DIFF 90일 이상이면, 이탈했다고 본다 하자
-- 90일 이상이면 이탈고객, 그 외는 비이탈고객
-- 문제 나온다.
SELECT *
	, CASE WHEN DIFF >= 90 THEN "이탈고객" 
			ELSE "비이탈고객" 
		END AS 이탈유무
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
;
-- 갯수 구하기
SELECT
	CASE WHEN DIFF >= 90 THEN "이탈고객" 
			ELSE "비이탈고객" 
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

USE etc;
CREATE TABLE sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);

INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

SELECT * FROM sales;

-- SUM() <- 집계함수
SELECT SUM(sale) FROM sales;
SELECT fiscal_year, SUM(sale) FROM sales GROUP BY 1;

-- 윈도우 함수 사용
-- 윈도우 함수 궁극적 목적  : 누적합
-- partiion by, order by 등 어떻게 하느냐에 따라 다 값 다르다.
SELECT
	fiscal_year
    , sales_employee
    , sale
 --   , SUM(sale) OVER (PARTITION BY fiscal_year) total_sales
--	  , SUM(sale) OVER (PARTITION BY fiscal_year ORDER BY sale) total_sales_2
--		, SUM(sale) OVER (ORDER BY fiscal_year) total_sales_3
FROM
	sales
;

SELECT 
	fiscal_year
    , sales_employee
    , sale
    -- , SUM(sale) OVER (PARTITION BY fiscal_year) total_sales
    -- , SUM(sale) OVER () total_sales
    -- , SUM(sale) OVER (PARTITION BY fiscal_year ORDER BY sale) total_sales
    -- , SUM(sale) OVER (ORDER BY fiscal_year) total_sales
    , SUM(sale) OVER (order BY fiscal_year ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 복잡스럽다
    , SUM(sale) OVER (order BY fiscal_year ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS 복잡스럽다2
    , SUM(sale) OVER (order BY fiscal_year ROWS BETWEEN 1 Preceding AND 1 FOLLOWING) AS 복잡스럽다3
FROM 
	sales
;

-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
/*
UNBOUNDED PRECEDING: 처음부터 
*/
-- 이게 뭔데 
-- windowing 절의 구조
-- 어렵네.. ㅇㅋㅇㅋ
-- 이걸 활용해서 인라인뷰 넣으면 뭐 쓸 수 있대...

-- LAG() ==> pandas shift 메서드와 유사
SELECT
	fiscal_year
    , sales_employee
    , sale
    , LAG(sale, 1, 0) OVER (PARTITION BY sales_employee 
							ORDER BY fiscal_year) "이전연도"
FROM 
	sales
;