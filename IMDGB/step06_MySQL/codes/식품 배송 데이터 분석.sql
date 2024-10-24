USE instacart;

SELECT * FROM aisles;
SELECT * FROM departments;
SELECT * FROM order_products__prior;
SELECT * FROM orders;
SELECT * FROM products;

SHOW TABLES;

-- 전반적인 현황 : 전체 주문 건수 
SELECT COUNT(DISTINCT ORDER_ID) 
FROM orders;

-- 전반적인 현황 : 전체 구매자수 
SELECT COUNT(DISTINCT USER_ID) 
FROM orders;

-- 전반적인 현황 : 상품별 주문 건수 
-- 테이블 : order_products__prior
DESC products;
DESC order_products__prior;

SELECT * 
FROM order_products__prior A
LEFT JOIN products B
ON A.product_id = B.product_id
;

SELECT B.product_name
	, COUNT(DISTINCT A.order_id) 
FROM order_products__prior A
LEFT JOIN products B
ON A.product_id = B.product_id
GROUP BY 1
ORDER BY 2 DESC
;

-- 장바구니에 가장 먼저 넣는 상품 10개
-- 첫번째로 넣는 제품군 10개를 뽑아보자 
DESC order_products__prior;
SELECT * FROM order_products__prior;

SELECT 
	PRODUCT_ID
    , CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END order_1st
FROM order_products__prior;


SELECT 
	PRODUCT_ID
    , SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) order_1st 
FROM order_products__prior
GROUP BY 1
ORDER BY 2 DESC;

SELECT *
	, ROW_NUMBER() OVER(ORDER BY order_1st DESC) RNK
FROM (
	SELECT 
		PRODUCT_ID
		, SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) order_1st 
	FROM order_products__prior
	GROUP BY 1
) A;

-- 상위 10개만 추출
SELECT * 
FROM (
	SELECT *
		, ROW_NUMBER() OVER(ORDER BY order_1st DESC) RNK
	FROM (
		SELECT 
			PRODUCT_ID
			, SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) order_1st 
		FROM order_products__prior
		GROUP BY 1
	) A
) A
WHERE RNK BETWEEN 1 AND 10
;

SELECT * FROM products
WHERE product_id IN (
	SELECT product_id
	FROM (
		SELECT *
			, ROW_NUMBER() OVER(ORDER BY order_1st DESC) RNK
		FROM (
			SELECT 
				PRODUCT_ID
				, SUM(CASE WHEN add_to_cart_order = 1 THEN 1 ELSE 0 END) order_1st 
			FROM order_products__prior
			GROUP BY 1
		) A
	) A
	WHERE RNK BETWEEN 1 AND 10
)
;

-- 시간별 주문 건수
-- 테이블 : orders
SELECT * FROM orders;

SELECT 
	order_hour_of_day
	, COUNT(DISTINCT order_id) f 
FROM orders
GROUP BY 1
ORDER BY 1
;

-- 첫 구매 후 다음 구매까지 걸린 평균 일수 
SELECT * FROM orders;
SELECT AVG(days_since_prior_order) AVG_RECENCY
FROM orders
WHERE order_number = 2; -- 유저의 2번째 주문 건을 의미

-- 주문 건당 평균 구매 상품 수 (UPT: Unit Per Transaction)
SELECT COUNT(product_id) / COUNT(DISTINCT order_id) UPT
FROM order_products__prior;

-- 인당 평균 주문 건수
-- 전체 주문 건수를 구매자 수로 나누어 인당 평균 주문 건수 계산 

SELECT COUNT(DISTINCT order_id) / COUNT(DISTINCT user_id) AVG_F
FROM orders;

-- 재 구매율이 가장 높은 상품 10개
-- 재 구매율을 기준으로 순위 계산
-- 테이블 : order_products__prior
-- (1) 상품별 재구매율 계산 
SELECT 
	product_id
    , SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) / COUNT(*) RET_RATIO
FROM order_products__prior
GROUP BY 1
;

-- (2) 재구매율 기준으로 순위 생성
SELECT *
	, DENSE_RANK() OVER(ORDER BY RET_RATIO DESC) DRNK
FROM (
	SELECT 
		product_id
		, SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) / COUNT(*) RET_RATIO
	FROM order_products__prior
	GROUP BY 1
) A
;

-- (3) Top 10 상품 추출
SELECT * 
FROM (
	SELECT *
		, DENSE_RANK() OVER(ORDER BY RET_RATIO DESC) DRNK
	FROM (
		SELECT 
			product_id
			, SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) / COUNT(*) RET_RATIO
		FROM order_products__prior
		GROUP BY 1
	) A
) A 
WHERE DRNK BETWEEN 1 AND 10
;

-- 
SELECT *
	, ROW_NUMBER() OVER(ORDER BY F DESC) RNK
FROM (
	SELECT USER_ID
		, COUNT(DISTINCT ORDER_ID) F
	FROM orders
	GROUP BY 1
) A
;
-- 전체 고객수 3159명 
CREATE TEMPORARY TABLE instacart.USER_QUANTILE AS 
SELECT *
	, CASE WHEN RNK BETWEEN 1 AND 316 THEN '1분위'
		WHEN RNK BETWEEN 317 AND 632 THEN '2분위'
        WHEN RNK BETWEEN 633 AND 948 THEN '3분위'
        WHEN RNK BETWEEN 949 AND 1264 THEN '4분위'
        WHEN RNK BETWEEN 1265 AND 1580 THEN '5분위'
        WHEN RNK BETWEEN 1581 AND 1895 THEN '6분위'
        WHEN RNK BETWEEN 1896 AND 2211 THEN '7분위'
        WHEN RNK BETWEEN 2212 AND 2527 THEN '8분위'
        WHEN RNK BETWEEN 2528 AND 2843 THEN '9분위'
        WHEN RNK BETWEEN 2844 AND 3159 THEN '10분위'
		END quantile
FROM (
	SELECT *
		, ROW_NUMBER() OVER(ORDER BY F DESC) RNK
	FROM (
		SELECT USER_ID
			, COUNT(DISTINCT ORDER_ID) F
		FROM orders
		GROUP BY 1
	) A
) A
;

SELECT quantile
	, SUM(F) F
FROM user_quantile
GROUP BY 1;

-- 전제 주문 건수 계산
-- 각 분위 수의 주문 건수를 전체 주문 건수로 나누면 비율 
SELECT SUM(F) FROM user_quantile;

SELECT quantile
	, SUM(F)/3220 F 
FROM user_quantile
GROUP BY 1;

-- 상품 분석
-- 재 구매를 많이 하는 상품 찾고, 상품의 판매 특성 확인
-- 상품별 재구매 비중(%)과 주문 건수 계산 
SELECT 
	product_id
    , SUM(reordered) / SUM(1) reorder_rate
    , COUNT(DISTINCT order_id) F
FROM order_products__prior
GROUP BY product_id
ORDER BY reorder_rate DESC
;

-- 주문건수가 10건 이하인 상품 제외
SELECT 
	product_id
    , SUM(reordered) / SUM(1) reorder_rate
    , COUNT(DISTINCT order_id) F
FROM order_products__prior
GROUP BY product_id
HAVING COUNT(DISTINCT ORDER_ID) > 10
;

-- 제품명 구하기
SELECT 
	A.product_id
    , B.product_name
    , SUM(reordered) / SUM(1) reorder_rate
    , COUNT(DISTINCT order_id) F
FROM order_products__prior A
LEFT JOIN products B
ON A.product_id = B.product_id
GROUP BY A.product_id, B.product_name
HAVING COUNT(DISTINCT ORDER_ID) > 100
ORDER BY 3 DESC;