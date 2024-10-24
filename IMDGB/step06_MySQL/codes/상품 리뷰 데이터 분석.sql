USE mydata;

SELECT * FROM dataset2;

DESC dataset2; 

SELECT `癤풠lothing ID` FROM dataset2 LIMIT 5;

ALTER TABLE dataset2 
RENAME COLUMN `癤풠lothing ID` TO `CLOTHING ID`;

SELECT * FROM dataset2;

-- DIVISION NAME 별 평균 평점 
SELECT 
	`DIVISION NAME`
    , AVG(RATING) AVG_RATE
FROM dataset2
GROUP BY 1;

-- Departments 별 평균 평점
DESC dataset2; 
SELECT 
	`Department Name`
    , AVG(RATING) AVG_RATE
FROM dataset2
GROUP BY 1;

-- Trend의 평점 3점 이하 리뷰
SELECT * 
FROM dataset2
WHERE `Department Name` = 'Trend'
	AND RATING <= 3;
    
-- 연령대별로 집계를 해보자
-- CASE WHEN
DESC dataset2;

SELECT CASE WHEN Age BETWEEN 0 AND 9 THEN '10세미만'
			WHEN Age BETWEEN 10 AND 19 THEN '10대'
			WHEN Age BETWEEN 20 AND 29 THEN '20대'
			WHEN Age BETWEEN 30 AND 39 THEN '30대'
			WHEN Age BETWEEN 40 AND 49 THEN '40대'
			WHEN Age BETWEEN 50 AND 59 THEN '50대'
			WHEN Age BETWEEN 60 AND 69 THEN '60대'
			WHEN Age BETWEEN 70 AND 79 THEN '70대'
			WHEN Age BETWEEN 80 AND 89 THEN '80대'
			WHEN Age BETWEEN 90 AND 99 THEN '90대' END AS AGEGROUP,
	Age
FROM dataset2
WHERE `DEPARTMENT NAME` = 'Trend'
AND RATING <= 3
;

-- FLOOR 활용해서 구분
SELECT FLOOR(Age/10) * 10 AGEGROUP, AGE
FROM dataset2
WHERE `DEPARTMENT NAME` = 'Trend'
AND RATING <= 3;

-- Trend의 평점 3점 이하 리뷰의 연령 분포
SELECT 
	FLOOR(Age/10) * 10 AGEGROUP
    , COUNT(*) AS CNT
FROM dataset2
WHERE `DEPARTMENT NAME` = 'Trend'
	AND RATING <= 3
GROUP BY 1
ORDER BY 2 DESC
;

-- department별 연령 리뷰 수
SELECT 
	FLOOR(Age/10) * 10 AGEGROUP
    , COUNT(*) AS CNT
FROM dataset2
WHERE `DEPARTMENT NAME` = 'Trend'
GROUP BY 1
ORDER BY 2 DESC
;

-- 결론 : 30대 리뷰수가 제일 많음 / 3점 이하 리뷰수는 50대가 제일 많음
-- 구체적으로 50대의 평점 3점 이하 리뷰 체크
SELECT title, `Review Text`
FROM dataset2
WHERE `DEPARTMENT NAME` = 'Trend'
	AND rating <= 3
    AND age BETWEEN 50 AND 59 LIMIT 5
;

-- 평점이 낮은 주요 상품의 주요 컴플레인 
-- 부서 이름, Clothing ID 별 평균 평점 계산
SELECT 
	`Department Name`
    , `Clothing ID`
    , AVG(Rating) AVG_RATE
FROM dataset2
GROUP BY 1, 2;

-- Department별 순위 생성
-- 윈도우 함수 생성 : ROW_NUMBER()
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
;

-- 각 Department Name별 1~10인 데이터만 조회
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
WHERE RNK <= 10
;

-- 테이블 생성 
CREATE TEMPORARY TABLE mydata.stat AS 
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
WHERE RNK <= 10
;

SELECT * FROM stat;

SELECT `Clothing ID`
FROM stat
WHERE `Department Name` = 'Bottoms';

-- 해당 ID의 리뷰 내용만 뽑아보자
SELECT *
FROM dataset2
WHERE `Clothing ID` IN (SELECT `Clothing ID`
						FROM stat
						WHERE `Department Name` = 'Bottoms')
;


-- 연령별, department별 가장 낮은 점수를 구해보기
SELECT 
	`Department Name`
	, FLOOR(AGE/10) * 10 AGEGROUP
    , AVG(RATING) AVG_RATING
FROM
	dataset2
GROUP BY 1, 2;

-- 연령별로 생성한 점수를 기준으로 RANK 계산 
SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY AGEGROUP ORDER BY AVG_RATING) RNK
FROM (
	SELECT 
		`Department Name`
		, FLOOR(AGE/10) * 10 AGEGROUP
		, AVG(RATING) AVG_RATING
	FROM
		dataset2
	GROUP BY 1, 2
) A
;

-- 연령별로 평균 점수가 가장 낮은 Department가 Rank 값 1을 갖도록 설계 
-- Rank값이 1인 값만 별도로 조회 가능
SELECT * 
FROM (
	SELECT *, 
		ROW_NUMBER() OVER(PARTITION BY AGEGROUP ORDER BY AVG_RATING) RNK
	FROM (
		SELECT 
			`Department Name`
			, FLOOR(AGE/10) * 10 AGEGROUP
			, AVG(RATING) AVG_RATING
		FROM
			dataset2
		GROUP BY 1, 2
	) A
) A
WHERE RNK = 1
;

-- SIZE 리뷰가 포함된 리뷰 수를 구해보자!!
-- LIKE 연산자로 추출 가능 
SELECT 
	`REVIEW TEXT`
	, CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END IS_SIZE
FROM dataset2
;


-- 전체 리뷰수 구하기 
SELECT 
	SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) CNT
    , COUNT(*) totals
FROM dataset2
;

SELECT 
	`Department Name`
    , FLOOR(AGE/10) * 10 AGE_GROUP
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) SIZE_CNT
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) LARGE_CNT
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LONG%' THEN 1 ELSE 0 END) LONG_CNT
    , COUNT(*) totals
FROM dataset2
GROUP BY 1, 2
ORDER BY 1, 2;


-- 비율 뽑기
SELECT 
	`Department Name`
    , FLOOR(AGE/10) * 10 AGE_GROUP
	, SUM(CASE WHEN `REVIEW TEXT` LIKE '%SIZE%' THEN 1 ELSE 0 END) / COUNT(*) SIZE_CNT
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LARGE%' THEN 1 ELSE 0 END) / SUM(1) LARGE_CNT
    , SUM(CASE WHEN `REVIEW TEXT` LIKE '%LONG%' THEN 1 ELSE 0 END) / SUM(1) LONG_CNT
    , COUNT(*) totals
FROM dataset2
GROUP BY 1, 2
ORDER BY 1, 2;