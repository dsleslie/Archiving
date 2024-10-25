USE classicmodels; -- 데이터베이스 이동

SELECT 
	* 
FROM 
	employees
; -- 데이터베이스 내 사용할 테이블 선언

/* SQL 기본문법
SELECT 컬럼
FROM 테이블명
WHERE 조건절
GROUP BY 범주 컬럼
HAVING 그룹바이 이후 조건절 (GROUP BY 없이는 사용 안함)
ORDER BY 값 정렬
*/

-- 테이블 내 특정 컬럼만 출력
