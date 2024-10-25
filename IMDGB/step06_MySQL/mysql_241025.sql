USE titanic;
SELECT * FROM titanic;

-- 중복값 확인
SELECT 
	COUNT(PassengerId) 승객수
    , COUNT(DISTINCT PassengerId) 중복승객수확인 
FROM titanic
;

-- 성별에 따른 승객수와 생존자수 구하세요
-- Column 확인 : 생존여부, 0 = 사망, 1 = 생존
-- 출력값
-- 성별   승객수    생존수
SELECT * FROM titanic;

SELECT 
	SEX as 성별
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존수
FROM titanic
GROUP BY Sex;

-- 성별탑승객수와 생존자수의 비중 구하기
SELECT 
	SEX as 성별
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존수
    , SUM(SURVIVED) / COUNT(PassengerID) AS 생존율
FROM titanic
GROUP BY Sex;


SELECT 
	SEX as 성별
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존수
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율 -- 반올림
FROM titanic
GROUP BY Sex;
-- 타이타닉 문제 나온다

-- 연령에 따른 생존율 살펴보기
-- 이런 경우 범주화 진행한다
-- pandas에서는 q cut? 
SELECT age FROM titanic;
-- SQL에서 연령대로 범주화
-- 1) CASE WHEN
-- 0~10세 ==> 0대
-- 11~20세 ==> 10대
-- 세부적으로 하려면 이렇게
-- 2) 대충 (?)
SELECT FLOOR(21/10) * 10; -- 20대 도출
SELECT FLOOR(AGE/10) * 10 AGEBAND, AGE FROM titanic;

-- 연령별 승객수, 생존자수, 생존율
SELECT 
	FLOOR(AGE/10) * 10 AGEBAND 
    FROM titanic;
    
SELECT 
	FLOOR(AGE/10) * 10 AS AGEBAND 
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존수
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율 -- 반올림
FROM titanic
GROUP BY AGEBAND
ORDER BY AGEBAND ASC
;

-- 연령별, 성별 승객수, 생존자수, 생존율
SELECT 
	SEX AS 성별
	, FLOOR(AGE/10) * 10 AS 연령대
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존수
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율 -- 반올림
FROM titanic
GROUP BY 1, 2
ORDER BY 1, 2
;

-- 원하는 테이블
-- 연령대 남성생존율 여성생존율 생존율차이
-- 0     0.594   0.633   여성-남성
-- HINT : join 걸어야 함
SELECT * FROM titanic;
-- CREATE titanic.female AS
SELECT
	Sex AS 성별
    , FLOOR(AGE/10) * 10 AS 연령대
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존수
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율 -- 반올림
FROM titanic
GROUP BY 1, 2
ORDER BY 1, 2
;


-- 여성 관련만
SELECT
	SEX as 성별
    , FLOOR(AGE/10) * 10 AS 연령대
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 여성생존율
FROM titanic
WHERE Sex = 'female'
GROUP BY 2
ORDER BY 2
;

SELECT
	A.연령대
    , A.생존율 AS 여성생존율
    , B.생존율 AS 남성생존율
    , A.생존율-B.생존율 AS 생존율차이
FROM (
	SELECT
		FLOOR(AGE/10) * 10 AS 연령대
        , SEX AS 성별
		, ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율
	FROM titanic
	GROUP BY 1, 2
    HAVING SEX = 'female'
) A
LEFT JOIN (
	SELECT
		FLOOR(AGE/10) * 10 AS 연령대
        , SEX AS 성별
		, ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율
	FROM titanic
	GROUP BY 1, 2
    HAVING SEX = 'male'

) B
ON A.연령대 = B.연령대
ORDER BY 1
; -- 왜 안되지 ..

SELECT 
    A.연령대
    , A.생존율 AS 남성생존율
    , B.생존율 AS 여성생존율
    , B.생존율 - A.생존율 AS 생존율차이
FROM (
    SELECT 
        FLOOR(AGE/10) * 10 AS 연령대
        , SEX AS 성별
        , COUNT(PassengerId) AS 승객수
        , SUM(SURVIVED) AS 생존자수
        , ROUND(SUM(SURVIVED) / COUNT(PassengerId), 3) AS 생존율
    FROM titanic
    GROUP BY 1, 2
    HAVING SEX = 'male'
) A 
LEFT JOIN (
    SELECT 
        FLOOR(AGE/10) * 10 AS 연령대
        , SEX AS 성별
        , COUNT(PassengerId) AS 승객수
        , SUM(SURVIVED) AS 생존자수
        , ROUND(SUM(SURVIVED) / COUNT(PassengerId), 3) AS 생존율
    FROM titanic
    GROUP BY 1, 2
    HAVING SEX = 'female'
) B
ON A.연령대 = B.연령대
ORDER BY 1
;

-- 왜 연령대 성별에 따른 생존율이 다른 이유는 무엇인가?
-- 분석 : 질적인 측면, 양적인 측면 동시에 고려
-- 주어진 데이터에서는 더 이상의 분석은 불가
-- 다른 해상사고 찾아서 결과 확인 후 교차 검증을 진행 해야함

-- 객실 등극별로 승객 수, 생존자 수, 생존율 계산
-- pclass 컬럼 이용
SELECT 
	pclass as 객실등급
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존자수
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율 -- 반올림
FROM titanic
GROUP BY 1
ORDER BY 1
;

-- 더 파야함
SELECT 
	pclass as 객실등급
    , Sex AS 성별
    , FLOOR(AGE/10) * 10 AS 연령대
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존자수
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율 -- 반올림
FROM titanic
GROUP BY 1, 2, 3
ORDER BY 2, 1
; -- 이렇게 추가해가면서 해석 할 수 있음.
-- 결론: 유아일수록 생존율이 높음, 모든 객실 등급에서 남성보다는 여성의 생존율 높음

-- 탑승객 분석
-- 출발지, 도착지별 승객 수
SELECT * FROM titanic;
-- Boarded: 출발지
-- Destination: 목적지
-- 출발지-목적지별 승객 수
SELECT 
	boarded
    , destination
    , COUNT(PassengerId) 승객수
FROM titanic
GROUP BY 1, 2
ORDER BY 3 DESC
;

-- 상위 5개 경로를 추출할 떄, 탑승객 수로 순위를 매기기
/* SELECT 
	boarded
    , destination
    , COUNT(PassengerId) 승객수
	, dense_rank() OVER(ORDER BY COUNT(PassengerId) DESC) RNK
FROM titanic
GROUP BY 1, 2
HAVING RNK BETWEEN 1 AND 5;
ORDER BY 3 DESC
; */

SELECT * 
FROM (
    SELECT 
        *
        , ROW_NUMBER() OVER(ORDER BY N_PASSENGERS DESC) RNK
    FROM (
            SELECT 
                BOARDED
                , DESTINATION
                , COUNT(PASSENGERID) N_PASSENGERS
            FROM titanic
            GROUP BY BOARDED, DESTINATION
    ) BASE
) BASE
WHERE RNK BETWEEN 1 AND 5
;

-- Hometown별 탑승객 수 생존율
SELECT * FROM titanic;
/*SELECT
	pclass as 객실등급
    , Sex AS 성별
    , FLOOR(AGE/10) * 10 AS 연령대
	, COUNT(PassengerID) AS 승객수
    , SUM(SURVIVED) AS 생존자수
    , ROUND(SUM(SURVIVED) / COUNT(PassengerID), 3) AS 생존율 -- 반올림
FROM titanic
GROUP BY 1, 2, 3
ORDER BY 2, 1 */

SELECT SUM(1); 				-- 결과 1 -> SUM(1): 테이블의 행 개수
SELECT SUM(1) FROM titanic;  -- 결과 714 -> SUM(1): 테이블의 행 개수

USE titanic;
-- 승객수가 10명 이상이면서 생존율이 0.5 이상인 HOMETOWN 출력
SELECT
	HOMETOWN
    , SUM(1) 승객수
    , SUM(SURVIVED)/SUM(1) 생존율 
FROM
	titanic
GROUP BY 1
HAVING
	SUM(1) >= 10 AND 생존율 >= 0.5 
;

/* python 언어로 mysql에서 할 수 있는 거
CRUD
CREATE
READ
UPDATE
DELETE

mysql에서 python 쓰는 이유
회귀분석, t-test, 머신러닝 등 하고 싶어서

final project 할때는 03 업무별 데이터 분석 절차
이대로 나와야 함. 그래야 좋아함.
*/