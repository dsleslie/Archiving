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

-- 14시부터 여기서부터 한 두 문제 나옴
USE titanic;
/* MySQL 정규표현식 

정규표현식 기본 문법
-패턴 그대로 매칭: 찾기 기능 같은 것
-메타문자 활용 
-그룹, look around 기능 <- 어렵
= > 여튼 문자열 찾을 때 사용하는 기법이다 !

문법
SELECT * FROM 테이블명 WHERE 컬럼명 REGEXP"pattern";
-> 강의 슬라이드, documentation 참고 !
-> 어려운 거임
-> pandas, sql에서 문자열 패턴으로 문자열 검색하고 싶을 때 '정규 표현식' 사용

-- 내용:
-- 문자와 기호:
-- .: 임의의 단일 문자
-- ^: 문자열의 시작
-- $: 문자열의 끝
-- *: 0개 이상의 반복
-- +: 1개 이상의 반복
-- ?: 0개 또는 1개의 반복
-- |: 논리적 OR
-- []: 범위 또는 문자 클래스
-- (): 그룹화

*/

-- 정규표현식 예제
USE etc;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20)
);

-- 샘플 데이터 삽입
INSERT INTO users (username, email, phone) VALUES
('john.doe', 'john.doe@example.com', '123-456-7890'),
('jane_smith', 'jane.smith@example.net', '555-1234'),
('alice99', 'alice123@wonderland.com', '987-654-3210'),
('bob-builder', 'bob.builder@construction.org', '321-654-0987'),
('charlie.brown', 'charlie.brown@example.com', '555-9876');

SELECT * FROM users;
-- 1. 임의의 단일 문자 : .
-- 문제 : username 컬럼에서 임의의 한 문자(t)가 있는 이름 찾아서 조회
SELECT * FROM users WHERE username REGEXP '.t';


-- 2. 문자열의 시작 : ^
-- 'a'로 시작하는 사용자 이름을 찾는 쿼리
SELECT * FROM users WHERE username REGEXP '^a'; 
SELECT * FROM users WHERE username REGEXP '^ja';
SELECT * FROM users WHERE username REGEXP '^j';

-- 3. 문자열의 끝 : $
-- 'm'으로 끝나는 이메일을 찾는 쿼리
SELECT * FROM users WHERE email REGEXP 'm$';

-- 4. * : 0개 이상의 반복
SELECT * FROM users WHERE username REGEXP 'do.*'; -- 중간글자 검색.. 응?

-- 5. + : 1개 이상의 반복
-- 숫자를 하나 이상 포함하는 사용자 이름 찾기
SELECT * FROM users WHERE username REGEXP '[0-9]'; -- []: 범위지정 , 숫자는 0-9가 있음. 그래서 숫자만 들어있으면 조회하겠다 는 뜻
-- ㅇ
SELECT * FROM users WHERE username REGEXP '[0-9]+'; -- + : 반복해서 가져온다 .. 응?
SELECT * FROM users WHERE username REGEXP '[:digit:]+'; -- :digit: 숫자를 의미하는 또 다른 명령어

-- 6. 알파벳 소문자 'a'에서 'e'사이의 문자로 시작하는 사용자 이름
SELECT * FROM users WHERE username REGEXP '^[a-e]'; -- a,b,c,d,e 중에 하나로 시작하는 username 가져온다
SELECT * FROM users WHERE username REGEXP '^.[a-e]'; -- 두번째 문자를 기준점으로 가져오기 ( . 이 이미 첫글자라서 )
SELECT * FROM users WHERE username REGEXP '^..[a-e]'; -- 세번째 문자를 기준점으로 가져오기 ( . 이 이미 첫,두글자라서 )


/* 리뷰 데이터
강의 슬라이드 참고
그냥 참고, 컬럼명 바꾸는 메서드 .. 당연 있음. 
*/
USE dataset2;
SELECT * FROM dataset2;
-- 컬럼명에 띄어쓰기 있어서 가져올  때 주의해야함 '이게 아니라 ` 써야함
SELECT `Review Text` FROM dataset2;

-- Department별 평균 평점 구하기
SELECT 
	`Department Name`
	, AVG(Rating) AS average
FROM dataset2
GROUP BY 1
ORDER BY 2 DESC
; -- Trend에 대한 평점 매우 낮음 -> 왜 이런 문제가 생겼을까 알아봐야 함.
-- DIVISION NAME별 평균 평점 구하기
SELECT 
	`DIVISION NAME`
	, AVG(Rating) AS average
FROM dataset2
GROUP BY 1
ORDER BY 2 DESC
;

-- Trend의 평점 3이하 조회
SELECT
	*
FROM
	dataset2
WHERE `Department Name` = 'Trend'
	AND RATING <=3
;

-- Trend의 평점 3점 이하 연령 분포 조회
-- AGE 활용 (titanic 통해 확인)
SELECT
	FLOOR(Age/10) * 10 AS AGEBAND
	, COUNT(*) AS 명수
FROM
	dataset2
WHERE `Department Name` = 'Trend'
	AND RATING <=3
GROUP BY 1
ORDER BY 2 DESC
;


-- Department별 연령별 리뷰수 
SELECT 
	FLOOR(Age/10) * 10 AS AGEBAND
	, COUNT(*) AS 명수
FROM dataset2
WHERE `Department Name` = 'Trend'
GROUP BY 1
ORDER BY 1
;
-- 위 두개 비교해보면, 실제로는 50대가 불만이 많음을 알 수 있음

-- 조건 
-- 연령대 : 50대
-- 평점 : 3점 이하 
-- Department Name : Trend
SELECT 
	Title
    , `Review Text`
FROM 
	dataset2
WHERE 
	`Department Name` = 'Trend'
	AND AGE BETWEEN 50 AND 59
    AND Rating <= 3
;
-- review text 보니 size complain이 있다.
-- size  complain에 대해 조사 디테일하게 해보자.
-- 결론:  SQL에서 더 디테일하게 조사 불가
-- NLP or 텍스트 마이닝 ==> 딥러닝, 생성형 AI 활용해서 별도로 조사
-- 간단한 집계 정도는 sql에서 할 수 있다.
-- 집계 TRUE / FALSE
-- 만약 ,   
SELECT 
	`REVIEW TEXT`
    , CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0
     END SIZE_YN -- 리뷰 내용에서 size가 있으면 1, 없으면 0
FROM 
	dataset2
;

-- 전체 리뷰 개수 중에서 SIZE에 관한 리뷰는 몇%인지 계산
-- 코드로 구현할 필요는 없고, 각각 개수 구하고 어림잡아서 판단
SELECT 
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS 사이즈리뷰개수
	, SUM(1) AS 전체리뷰개수
FROM 
	dataset2
;


-- LARGE
-- SMALL
-- TIGHT
-- LOOSE
SELECT 
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS 사이즈리뷰개수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS small_사이즈리뷰개수
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS large_사이즈리뷰개수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS loose_사이즈리뷰개수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS tight_사이즈리뷰개수
    , SUM(1) AS 전체리뷰개수
FROM 
	dataset2
;

-- 할 것
-- department name 별로 집계
-- 연령대별로 집계
-- department name, 연령대별로 집계
-- 각각 비율도 구할 수 있다. : 예시 : SUM(CASE WHEN ~~~ / SUM(1) ) 

-- ?
-- 아래는 강사님 코드

-- department name별로 집계
SELECT
	`department name`
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS SIZE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS LARGE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS SMALL_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS TIGHT_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS LOOSE_전체리뷰갯수
	, SUM(1) AS 전체리뷰갯수
FROM 
	dataset2
GROUP BY 1
;

-- 연령대별로 집계
SELECT
	FLOOR(AGE/10) * 10 연령대 
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS SIZE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS LARGE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS SMALL_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS TIGHT_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS LOOSE_전체리뷰갯수
	, SUM(1) AS 전체리뷰갯수
FROM 
	dataset2
GROUP BY 1
ORDER BY 1
;
-- department name, 연령대별로 집계
SELECT
	`department name`
	, FLOOR(AGE/10) * 10 연령대 
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) AS SIZE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) AS LARGE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) AS SMALL_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) AS TIGHT_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) AS LOOSE_전체리뷰갯수
	, SUM(1) AS 전체리뷰갯수
FROM 
	dataset2
GROUP BY 1, 2
ORDER BY 2, 1
;
-- 각각의 비율 구할 수 있음 
SELECT
	`department name`
	, FLOOR(AGE/10) * 10 연령대 
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / SUM(1) AS SIZE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) / SUM(1) AS LARGE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) / SUM(1) AS SMALL_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) / SUM(1) AS TIGHT_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) / SUM(1) AS LOOSE_전체리뷰갯수
	, SUM(1) AS 전체리뷰갯수
FROM 
	dataset2
GROUP BY 1, 2
ORDER BY 2, 1
;
-- SUM (case when ~~~ ) / SUM(1) 
SELECT * FROM dataset2;
SELECT
	`department name`
	, FLOOR(AGE/10) * 10 연령대 
    , Rating
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / SUM(1) AS SIZE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) / SUM(1) AS LARGE_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%SMALL%' THEN 1 ELSE 0 END) / SUM(1) AS SMALL_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%TIGHT%' THEN 1 ELSE 0 END) / SUM(1) AS TIGHT_전체리뷰갯수
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LOOSE%' THEN 1 ELSE 0 END) / SUM(1) AS LOOSE_전체리뷰갯수
	, SUM(1) AS 전체리뷰갯수
FROM 
	dataset2
GROUP BY 1, 2, 3
ORDER BY 2, 1, 3 DESC
;