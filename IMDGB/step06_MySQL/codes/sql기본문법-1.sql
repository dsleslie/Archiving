-- SELECT @@datadir;
SELECT * FROM performance_schema.users;

USE sakila; -- 현재 DB 선택
SELECT DATABASE(); -- 현재 데이터베이스가 활성화된 것 확인 
SHOW TABLES; -- sakila 데이터베이스를 구성하는 테이블 살펴보기
SHOW columns FROM actor; -- 테이블 필드명 탐색
DESC actor; -- 테이블 필드명 탐색

/* 
---- SELECT ---- 
*/
SELECT * FROM city;
SELECT city FROM city;
SELECT city, city FROM city;
SELECT name FROM sakila.language;

/* 
---- WHERE ---- 
*/

SELECT * FROM language WHERE name = 'English';
SELECT first_name FROM actor WHERE actor_id = 4;
SELECT city FROM city WHERE country_id = 15;
SELECT city FROM city WHERE city_id < 5;
SELECT language_id, name FROM language WHERE language_id <> 2;

SELECT first_name FROM actor WHERE first_name < 'B';
SELECT first_name FROM actor WHERE first_name < 'b';

-- Like 연산자
-- family라는 단어가 포함된 제목으로 영화를 검색하는 예시
SELECT title FROM film WHERE title LIKE '%family%';

-- 임의이 문자 한 개만 매칭 시 와일드카드 _ 사용
-- NAT로 시작하는 배우가 출연하는 모든 영화의 제목
SELECT actors, title FROM film_list WHERE actors LIKE 'NAT_%';

-- 패턴 시작 부분에 와일드가크드 %사용 비추천 
-- 검색 가능, 그러나 전체 테이블을 읽어야 하므로 테이블 행이 많을 경우 성능에 심각한 타격
SELECT title FROM film WHERE title LIKE '%day%';

-- AND, OR, NOT, XOR 조건 결합
-- Bool 연산자와 AND, OR, NOT, XOR 사용해 둘 이상의 조건 결합해 사용
SELECT title FROM film_list WHERE category LIKE 'Sci-Fi' 
	AND rating LIKE 'PG';
    
SELECT title FROM film_list WHERE category LIKE 'Children'
	OR category LIKE 'Family';
    
-- AND와 OR결합
-- PG 등급의 SF(Sci-Fi)나 가족 영화(Family) 장르의 영화를 원한다고 가정
SELECT title FROM film_list WHERE (category LIKE 'Sci-Fi' 
	OR category LIKE 'Family') AND rating LIKE 'PG';
    
SELECT (2+2) * 3;
SELECT 2+2*3;

-- 연산자의 순서 변경 예제
-- 값이 달라진다. 
SELECT * FROM city WHERE city_id = 3 OR city_id = 4 AND country_id = 60;
SELECT * FROM city WHERE country_id = 60 AND city_id = 3 OR city_id = 4;

-- NOT 연산자
SELECT language_id, name FROM language WHERE NOT (language_id = 2);
SELECT fid, title FROM film_list WHERE FID < 7 AND NOT (FID = 4 OR FID = 6);

-- 
SELECT title FROM film_list 
WHERE price BETWEEN 2 AND 4
AND (category LIKE 'Documentary' OR category LIKE 'Horror')
AND actors LIKE '%BOB%';

-- IN : 연산자를 사용하면 값이 값 목록의 어떤 값과 일치하는지 확인할 수 있다.
SELECT 
    officeCode, 
    city, 
    phone, 
    country
FROM
    classicmodels.offices
WHERE
    country IN ('USA' , 'France');


-- NOT IN 

SELECT 
    officeCode, 
    city, 
    phone
FROM
    classicmodels.offices
WHERE
    country NOT IN ('USA' , 'France')
ORDER BY 
    city;

-- BETWEEN 

SELECT 
    productCode, 
    productName, 
    buyPrice
FROM
    classicmodels.products
WHERE
    buyPrice BETWEEN 90 AND 100;

-- BETWEEN 날짜에도 적용 가능
-- CAST() : 데이터 형 변환 
SELECT 
   orderNumber,
   requiredDate,
   status
FROM 
   classicmodels.orders
WHERE 
   requireddate BETWEEN 
     CAST('2003-01-01' AS DATE) AND 
     CAST('2003-01-31' AS DATE);

-- HAVING-COUNT
USE classicmodels;

-- 주문건수가 4개 초과인 것만 조회
-- HAVING COUNT 활용
SELECT 
  customerName, 
  COUNT(*) order_count 
FROM 
  orders 
  INNER JOIN customers using (customerNumber) 
GROUP BY 
  customerName 
HAVING 
  COUNT(*) > 4 
ORDER BY 
  order_count;
  
  

/* 
---- ORDER BY ---- 
*/
SELECT name FROM customer_list 
ORDER BY name
LIMIT 5;

SELECT address, last_update FROM address 
ORDER BY last_update LIMIT 5;

-- 두 개 이상의 열로 정렬
SELECT address, district FROM address
ORDER BY district, address;

SELECT address, district FROM address
ORDER BY district ASC, address DESC
LIMIT 10;

-- LIMIT 절
SELECT name FROM customer_list LIMIT 10;

-- 첫번째 인수는 반환되는 첫번째 행 지정
-- 두번째 인수는 반환할 최대 행 수 지정
SELECT name FROM customer_list LIMIT 5, 5;

SELECT id, name FROM customer_list 
ORDER BY id LIMIT 10;

SELECT id, name FROM customer_list 
ORDER BY id LIMIT 10 OFFSET 5;

-- IS NULL
-- 영업 담당자가 없는 고객을 찾기 
SELECT 
    customerName, 
    country, 
    salesrepemployeenumber
FROM
    classicmodels.customers
WHERE
    salesrepemployeenumber IS NULL
ORDER BY 
    customerName;
    
-- IS NULL
-- 영업 담당자가 있는 고객 찾기 
SELECT 
    customerName, 
    country, 
    salesrepemployeenumber
FROM
    classicmodels.customers
WHERE
    salesrepemployeenumber IS NOT NULL
ORDER BY 
   customerName;
