/* 
---- JOIN ---- 
*/ 

SELECT city, country FROM city 
INNER JOIN country 
ON city.country_id = country.country_id
WHERE country.country_id < 5
ORDER BY country, city;

-- 데이터베이스에 이탈리아 도시가 몇 개 있는지 세어보기
SELECT count(1) FROM city 
INNER JOIN country 
ON city.country_id = country.country_id 
WHERE country.country_id = 49
ORDER BY country, city;

-- 열 별칭
SELECT 
	first_name AS 'First Name'
    , last_name AS 'Last Name'
FROM actor 
LIMIT 5;

-- CONCAT()
SELECT CONCAT(first_name, ' ', last_name, ' played in ', title) AS movie
FROM actor 
JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
ORDER BY movie LIMIT 20;

-- ORDER BY 절은 movie의 결과 값을 오름차순으로 정렬하도록 요청
SELECT CONCAT(first_name, ' ', last_name, ' played in ', title) AS movie
FROM actor 
JOIN film_actor USING (actor_id)
JOIN film USING (film_id)
ORDER BY CONCAT(first_name, ' ', last_name, ' played in ', title) 
LIMIT 20;

SELECT actor_id AS id FROM actor WHERE first_name = 'ZERO';
SELECT actor_id id FROM actor WHERE first_name = 'ZERO';

-- 테이블 별칭
SELECT ac.actor_id, ac.first_name, ac.last_name, fl.title 
FROM actor AS ac 
INNER JOIN film_actor AS fla USING (actor_id)
INNER JOIN film AS fl USING (film_id)
WHERE fl.title = 'AFFAIR PREJUDICE'
;

-- 영화 테이블에 있는 두 개의 서로 다른 영화가 같은 제목을 가졌는지 확인
-- 각 테이블의 영화는 ID가 동일해선 안됨 
SELECT m1.film_id, m2.title
FROM film AS m1, film AS m2
WHERE m1.title = m2.title
	AND m1.film_id <> m2.film_id;
    
/* 
---- 데이터 집계 ---- 
---- DISTINCT ----
*/ 

SELECT first_name, last_name
FROM actor 
JOIN film_actor USING (actor_id)
LIMIT 5;

SELECT DISTINCT first_name, last_name
FROM actor 
JOIN film_actor USING (actor_id);

/* 
---- GROUP BY ----
*/ 

SELECT first_name FROM actor
WHERE first_name IN ('GENE', 'MERYL')
;


SELECT first_name FROM actor
WHERE first_name IN ('GENE', 'MERYL')
GROUP BY first_name
;

-- 각 배우의 출연작 수 집계
-- without group by
SELECT first_name, last_name, film_id
FROM actor 
INNER JOIN film_actor USING (actor_id)
ORDER BY first_name, last_name LIMIT 10;

-- with groupby
SELECT first_name, last_name, COUNT(film_id) AS num_films 
FROM actor
INNER JOIN film_actor USING (actor_id)
GROUP BY first_name, last_name
ORDER BY num_films DESC LIMIT 5;




/* 
---- HAVING 절 ----
*/ 

-- 집계 목적으로 출력 데이터를 그룹화 함
-- 배우가 40편 이상의 영화에 출연한 것 정의
SELECT first_name, last_name, COUNT(film_id)
FROM actor 
INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id, first_name, last_name
HAVING COUNT(film_id) > 40
ORDER BY COUNT(film_id) DESC;

-- 30회 이상 대여된 상위 5개 영화 목록 확인
SELECT title, COUNT(rental_id) AS num_rented 
FROM film INNER JOIN inventory USING (film_id)
INNER JOIN rental USING (inventory_id) 
GROUP BY title 
HAVING num_rented > 30
ORDER BY num_rented DESC LIMIT 5;

-- HAVING을 사용하면 안 되는 예시
-- 데이터가 많을수록 속도 저하
-- WHERE 절에 조건을 넣어 사용해야 함
SELECT first_name, last_name, COUNT(film_id) AS film_cnt 
FROM actor INNER JOIN film_actor USING (actor_id)
GROUP BY actor_id, first_name, last_name
HAVING first_name = 'EMILY' AND last_name = 'DEE'; -- 속도 비교

SELECT first_name, last_name, COUNT(film_id) AS film_cnt 
FROM actor INNER JOIN film_actor USING (actor_id)
WHERE first_name = 'EMILY' AND last_name = 'DEE'
GROUP BY actor_id, first_name, last_name;





/* 
---- 내부 조인 ----
*/ 

-- USING 절은 테이블 또는 결과 모두에 있고 
-- 행을 조인하거나 일치시키는 데 사용되는 하나 이상의 열을 정의
-- 일치하지 않는 행은 반환되지 않음 
-- film_actor 테이블에 일치하는 영화가 없는 
-- actor 테이블의 행은 결과 내용에 포함되지 않음

SELECT 
	first_name
    , last_name
    , film_id 
FROM actor 
INNER JOIN film_actor USING (actor_id)
LIMIT 20;

-- WHERE 절을 사용해 내부조인 쿼리 작성
SELECT first_name, last_name, film_id
FROM actor, film_actor
WHERE actor.actor_id = film_actor.actor_id
LIMIT 20;

-- USING 절 대신 ON 절 사용 
SELECT first_name, last_name, film_id
FROM actor 
INNER JOIN film_actor 
ON actor.actor_id = film_actor.actor_id 
LIMIT 20;

-- 데카르트 곱
SELECT COUNT(*) FROM actor, film_actor;

SELECT first_name, last_name, film_id
FROM actor INNER JOIN film_actor;

/* 
---- 통합 : UNION ----
*/ 

-- 데이터베이스의 모든 배우, 영화, 고객의 이름 출력시 UNION 문 사용 
SELECT first_name FROM actor
UNION 
SELECT first_name FROM customer
UNION
SELECT title FROM film;


-- 가장 많이 대여한 영화와 가장 적게 대여한 영화 5편의 목록 
-- UNION 연산자 사용 시 쉽게 수행 가능
(SELECT title, COUNT(rental_id) AS num_rented
 FROM film JOIN inventory USING (film_id)
 JOIN rental USING (inventory_id)
 GROUP BY title ORDER BY num_rented DESC LIMIT 5)
UNION
(SELECT title, COUNT(rental_id) AS num_rented
 FROM film JOIN inventory USING (film_id)
 JOIN rental USING (inventory_id)
 GROUP BY title ORDER BY num_rented ASC LIMIT 5
)
;

-- UNION vs UNION ALL
SELECT first_name FROM actor WHERE actor_id = 88
UNION
SELECT first_name FROM actor WHERE actor_id = 169;

SELECT first_name FROM actor WHERE actor_id = 88
UNION ALL
SELECT first_name FROM actor WHERE actor_id = 169;

-- 특정 영화에 대한 대여 정보와 대여 시간 나열
SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC
LIMIT 5;

-- UNION 연산 수행 시
-- 두개의 하위 쿼리 사용  
(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC
)
UNION ALL
(SELECT title, rental_date, return_date 
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC LIMIT 5
);

-- UNION 연산의 출력은 하위 쿼리가 정렬되어도 순서 미 보장
-- 따라서 마지막으로 ORDER BY DESC 사용
(SELECT title, rental_date, return_date
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC
)
UNION ALL
(SELECT title, rental_date, return_date 
FROM film JOIN inventory USING (film_id)
JOIN rental USING (inventory_id)
WHERE film_id = 998
ORDER BY rental_date ASC LIMIT 5
)
ORDER BY rental_date DESC;

-- 반환된 결과 수 제한하고 최종 결과 정렬하는 예
(SELECT first_name, last_name 
FROM actor 
WHERE actor_id < 5)
UNION 
(SELECT first_name, last_name FROM actor 
WHERE actor_id > 190)
ORDER BY first_name LIMIT 4;

SELECT first_name, last_name FROM actor
WHERE actor_id < 5 OR actor_id > 190
ORDER BY first_name LIMIT 4;

-- 왼쪽 조인과 오른쪽 조인
-- 왼쪽 테이블에 중요한 데이터가 존재함 확신
-- 오른쪽 테이블에는 데이터가 있는지 확신 불분명 할 때 사용 

SELECT 
	cat.name, COUNT(rental_id) cnt
FROM category cat LEFT JOIN film_category USING (category_id)
LEFT JOIN inventory USING (film_id)
LEFT JOIN rental USING (inventory_id)
LEFT JOIN customer cs ON rental.customer_id = cs.customer_id
GROUP BY 1
ORDER BY 2 DESC;

-- 이번에는 RIGHT JOIN을 실행해본다. 
-- NULL 값 출력되는 것 확인
SELECT title, rental_date
FROM rental RIGHT JOIN inventory USING (inventory_id)
RIGHT JOIN film USING (film_id)
ORDER BY rental_date;


/* 
---- 서브쿼리 ---- 
*/


-- NYC에 거주하는 고객들의 주문 번호 조회
USE classicmodels;

SELECT ordernumber
FROM orders
WHERE customerNumber IN (
	SELECT customernumber 
    FROM customers 
    WHERE city = 'NYC'
);

/* 
---- 서브쿼리 ---- 
*/



-- USA 사무실에서 근무하는 직원 조회 
SELECT * FROM employees;
SELECT * FROM offices;

SELECT 
    lastName, firstName
FROM
    employees
WHERE
    officeCode IN (SELECT 
            officeCode
        FROM
            offices
        WHERE
            country = 'USA');
            

-- 가장 많은 비용을 지출한 고객 조회 
SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount = (SELECT MAX(amount) FROM payments);
    
-- 전체 고객의 평균 구매보다 높은 구매 고객 조회 
SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount > (SELECT 
            AVG(amount)
        FROM
            payments);
            
-- 아직 주문을 하지 않은 고객 조회
-- 테이블 : customers
SELECT 
    customerName
FROM
    customers
WHERE
    customerNumber NOT IN (SELECT DISTINCT
            customerNumber
        FROM
            orders);
            
-- 주문 시 최대, 최소, 그리고 평균 구매수량
-- 테이블 : orderdetails
SELECT 
    MAX(items), 
    MIN(items), 
    FLOOR(AVG(items))
FROM
    (SELECT 
        orderNumber, COUNT(orderNumber) AS items
    FROM
        orderdetails
    GROUP BY orderNumber) AS lineitems;

-- 각 결제일까지 고객이 결제한 총 금액을 포함    
-- 사용 테이블 payments

SELECT * FROM payments;

SELECT 
    p.customerNumber,
    p.paymentDate,
    p.amount,
    (SELECT SUM(amount) 
     FROM payments 
     WHERE customerNumber = p.customerNumber 
     AND paymentDate <= p.paymentDate) AS totalAmountPaidToDate
FROM 
    payments p;
    
    
/* 
---- 윈도우 함수 ---- 
*/
-- buyprice 칼럼으로 순위 매기기
-- 테이블 : products 
SELECT 
	buyprice
	, ROW_NUMBER() OVER(ORDER BY buyprice) ROWNUMBER
    , RANK() OVER(ORDER BY buyprice) RNK
	, DENSE_RANK() OVER(ORDER BY buyprice) DENSERANK
FROM products;

-- products 테이블의 productline 별로 순위 매기기
SELECT 
	buyprice
    , productline
	, ROW_NUMBER() OVER(PARTITION BY productline ORDER BY buyprice) ROWNUMBER
    , RANK() OVER(PARTITION BY productline ORDER BY buyprice) RNK
	, DENSE_RANK() OVER(PARTITION BY productline ORDER BY buyprice) DENSERANK
FROM products;

CREATE TABLE mydata.tStaff
(
	name CHAR (15) PRIMARY KEY,
	depart CHAR (10) NOT NULL,
	gender CHAR(3) NOT NULL,
	joindate DATE NOT NULL,
	grade CHAR(10) NOT NULL,
	salary INT NOT NULL,
	score DECIMAL(5,2) NULL
);

USE mydata;
INSERT INTO tStaff VALUES ('김유신','총무부','남','2000-2-3','이사',420,88.8);
INSERT INTO tStaff VALUES ('유관순','영업부','여','2009-3-1','과장',380,NULL);
INSERT INTO tStaff VALUES ('안중근','인사과','남','2012-5-5','대리',256,76.5);
INSERT INTO tStaff VALUES ('윤봉길','영업부','남','2015-8-15','과장',350,71.25);
INSERT INTO tStaff VALUES ('강감찬','영업부','남','2018-10-9','사원',320,56.0);
INSERT INTO tStaff VALUES ('정몽주','총무부','남','2010-9-16','대리',370,89.5);
INSERT INTO tStaff VALUES ('허난설헌','인사과','여','2020-1-5','사원',285,44.5);
INSERT INTO tStaff VALUES ('신사임당','영업부','여','2013-6-19','부장',400,92.0);
INSERT INTO tStaff VALUES ('성삼문','영업부','남','2014-6-8','대리',285,87.75);
INSERT INTO tStaff VALUES ('논개','인사과','여','2010-9-16','대리',340,46.2);
INSERT INTO tStaff VALUES ('황진이','인사과','여','2012-5-5','사원',275,52.5);
INSERT INTO tStaff VALUES ('이율곡','총무부','남','2016-3-8','과장',385,65.4);
INSERT INTO tStaff VALUES ('이사부','총무부','남','2000-2-3','대리',375,50);
INSERT INTO tStaff VALUES ('안창호','영업부','남','2015-8-15','사원',370,74.2);
INSERT INTO tStaff VALUES ('을지문덕','영업부','남','2019-6-29','사원',330,NULL);
INSERT INTO tStaff VALUES ('정약용','총무부','남','2020-3-14','과장',380,69.8);
INSERT INTO tStaff VALUES ('홍길동','인사과','남','2019-8-8','차장',380,77.7);
INSERT INTO tStaff VALUES ('대조영','총무부','남','2020-7-7','차장',290,49.9);
INSERT INTO tStaff VALUES ('장보고','인사과','남','2005-4-1','부장',440,58.3);
INSERT INTO tStaff VALUES ('선덕여왕','인사과','여','2017-8-3','사원',315,45.1);

SELECT * FROM tStaff;

-- 윈도우 함수 순위
-- 집계함수() OVER(PARTITION BY 그룹핑기준 ORDER BY 정렬기준 ROWS | RANGE)
SELECT
    depart
    , SUM(salary)
FROM tStaff
GROUP BY depart;

-- 아래 쿼리를 확인한다. 
-- 각 직원이 받는 급여가 전체 총급여 대비 몇%에 해당하는지 확인한다. 
SELECT 
    name
    , depart
    , salary
    , ROUND(salary * 100.0 / SUM(salary) OVER(), 2) AS 월급비율 
    , SUM(salary) OVER() AS 총급여 
FROM tStaff;

-- 이번에는 부서월급총합을 구해본다. 서브쿼리로 구해본다. 
SELECT 
    name
    , depart
    , salary
    , (SELECT SUM(salary) FROM tStaff WHERE depart = A.depart) AS 부서월급총합
FROM tStaff A
ORDER BY depart;

-- 윈도우 함수를 활용해본다. 
SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER (PARTITION BY depart) AS 부서월급총합
FROM tStaff;

-- 직원 목록을 출력하면서 앞쪽 직원의 월급을 다 더한 누적 월급 계산하기. 
SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER (ORDER BY name) AS 누적월급
FROM tStaff;

-- 다음은 부서별 월급 누적 합계를 구한다. 
SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER (PARTITION BY depart ORDER BY name) AS 누적월급
FROM tStaff;

-- 연습문제 : 각 직원의 부서내 월급 비율을 구해 출력하라
SELECT 
    name
    , depart
    , salary
    , ROUND(salary * 100.0 / SUM(salary) OVER(PARTITION BY depart), 2) AS 부서월급비율
FROM tStaff;


-- 연습문제 : 부서별 평균 월급을 GROUP BY 절 없이 OVER절로 작성하라. 
SELECT depart, AVG(salary) FROM tStaff GROUP BY depart;
SELECT DISTINCT depart, AVG(salary) OVER (PARTITION BY depart) FROM tStaff;

-- 윈도우절 : 더 정밀한 범위 지정
-- 나보다 앞뒤로 각 1명씩까지의 월급 계산한다. 
SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER(ORDER BY name ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS 누적월급 
FROM tStaff;

-- 나부터 마지막 직원까지의 월급 총합을 구함
-- 아래쪽으로 내려올수록 뒤쪽의 직원 수가 줄어들기 때문에 월급 총합이 점점 감소함
SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER(ORDER BY name ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS 누적월급 
FROM tStaff;

-- PARTITION BY로 부서별 그룹핑을 한다.
-- 입사일 기준으로 나부터 2명 이후까지만의 합계를 구함
SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER(PARTITION BY depart ORDER BY joindate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS 누적월급 
FROM tStaff;

-- 월급순으로 정렬해보고 첫직원부터 현재행까지의 월급 총합을 구해 ROWS와 RANGE의 차이를 관찰해본다. 
SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER(ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 누적월급 
FROM tStaff;

SELECT 
    name
    , depart
    , salary
    , SUM(salary) OVER(ORDER BY salary RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 누적월급 
FROM tStaff;

-- 윤봉길과 같은 월급을 받는 사람이 없어서 ROWS 범위나 RANGE 범위나 똑같이 누적 월급이 3046이다. 
-- 그러나, 정몽주는 같은 월급을 받는 안창호가 있어 옵션에 따라 누적 월급이 달라진다. 
-- ROWS 옵션은 CURRENT ROW를 자기 자신까지만 취한다. 
-- RANGE 옵션은 같은 월급을 받는 뒤쪽행의 값까지 취한다. 
-- 그래서 정몽주의 월급 누적합에 안창호의 월급이 미리 더해지기 때문에 두개의 누적월급은 같다는 것을 확인할 수 있음 

-- RANK
-- 모든 직원을 월급순으로 내림차순 정렬하여 월급 순위를 매긴다. 
SELECT 
    RANK() OVER (ORDER BY salary DESC) AS 순위
    , A.* 
FROM tStaff A;

-- 순위는 월급순으로 매기되 출력은 성취도 오름차순으로 정렬 해본다. 
SELECT 
    RANK() OVER (ORDER BY salary DESC) AS 순위
    , A.* 
FROM tStaff A
ORDER BY score;

-- 영업부 직원만을 대상으로 순위를 매긴다. 
SELECT 
    RANK() OVER (ORDER BY salary DESC) AS 순위
    , A.* 
FROM tStaff A
WHERE depart = '영업부';

-- 다른부서까지 한꺼번에 그룹별로 순위를 매길 때는 OVER에 PARTITION BY절을 추가한다. 
SELECT 
    RANK() OVER (PARTITION BY depart ORDER BY salary DESC) AS 순위
    , A.* 
FROM tStaff A;

-- RANK 함수는 공동순위가 있으면 공동순위 만큼 건너뛰어 불연속적임. 
-- DENSE_RANK 함수를 사용한다. 
SELECT 
    DENSE_RANK() OVER (PARTITION BY depart ORDER BY salary DESC) AS 순위
    , A.* 
FROM tStaff A;

-- 성별 월급 순위를 계산하라
SELECT 
    RANK() OVER (PARTITION BY gender ORDER BY salary DESC) AS 순위
    , tStaff.* 
FROM tStaff;

-- DENSE_RANK, RANK, ROW_NUMBER
-- 성별 월급 순위를 계산하라
SELECT
	gender
    , salary
	, DENSE_RANK() OVER (ORDER BY salary DESC) AS drnk
    , RANK() OVER (ORDER BY salary DESC) AS rnk
    , ROW_NUMBER() OVER (ORDER BY salary DESC) AS rnum
FROM tStaff;

-- NTILE : 레코드의 집합을 n개의 영역으로 구분하고 소속 영역을 구한다. 
-- 월급순으로 정렬 후 4개의 그룹으로 나눈다. 
SELECT 
    NTILE(4) OVER (ORDER BY salary DESC) AS 구간
    , name
    , salary
FROM tStaff;

-- 성별로 그룹을 나눈 후 4분위수를 구한다. 
SELECT 
    NTILE(4) OVER (PARTITION BY gender ORDER BY salary DESC) AS 구간
    , name
    , gender
    , salary
FROM tStaff;

-- 성취도를 기준으로 5분할한 후 가운데 구간만 취한다. 
SELECT
    name
    , score
FROM (
    SELECT 
        NTILE(5) OVER(ORDER BY score DESC) AS 구간
        , tStaff.* 
    FROM tStaff
) S
WHERE S.구간 = 3;

-- 첫값, 마지막 값
-- FIRST_VALUE : 그룹 내의 첫값을 구한다. 
-- LAST_VALUE : 그룹 내의 마지막 값을 구한다. 단, LAST_VALUE가 인식하는 그룹은 지금까지 읽은 행 집합 의미, 자기 자신임. 
-- 전체 그룹에 대한 마지막 값을 구할 시 ROWS 옵션을 주어야 함. 

-- tStaff 테이블을 월급순으로 정렬함. 
SELECT
    name
    , salary
    , FIRST_VALUE(salary) OVER (ORDER BY salary) AS first
    , LAST_VALUE(salary) OVER (ORDER BY salary) AS midlast
    , LAST_VALUE(salary) OVER (ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND 
        UNBOUNDED FOLLOWING) AS last
FROM tStaff;

-- 이 그룹 내 최소값과 최대값이 정해진다. 
-- 이를 통해, 최소 월급보다는 얼마나 더 받는지, 최대 월급에는 얼마나 부족한지 알 수 있다. 
SELECT 
    name
    , salary
    , salary - FIRST_VALUE(salary) OVER (ORDER BY salary) AS 최저월급기준
    , LAST_VALUE(salary) OVER (ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND 
        UNBOUNDED FOLLOWING) - salary AS 최고월급기준
FROM tStaff
ORDER BY name;

-- 부서별로 비교할 시, PARTITION BY를 추가하면 된다. 
SELECT 
    name
    , depart
    , salary
    , salary - FIRST_VALUE(salary) OVER (PARTITION BY depart ORDER BY salary) AS 최저월급기준
    , LAST_VALUE(salary) OVER (PARTITION BY depart ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND 
        UNBOUNDED FOLLOWING) - salary AS 최고월급기준
FROM tStaff
ORDER BY depart, salary;
