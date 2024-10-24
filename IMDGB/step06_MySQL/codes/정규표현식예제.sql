-- 슬라이드 3: 기본 문법 및 패턴
-- 제목: 기본 문법 및 패턴

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

-- 샘플 테이블 생성
DROP TABLE users;
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

-- 샘플 쿼리 예제

-- 1. .: 임의의 단일 문자
-- 사용자 이름에 임의의 한 문자(t)가 있는 경우를 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP '.t';

-- 2. ^: 문자열의 시작
-- 'a'로 시작하는 사용자 이름을 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP '^a';

-- 3. $: 문자열의 끝
-- 'm'으로 끝나는 이메일을 찾는 쿼리:
SELECT * FROM users WHERE email REGEXP 'm$';

-- 4. *: 0개 이상의 반복
-- 'do'로 시작하고 임의의 문자들이 올 수 있는 사용자 이름을 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP 'do.*';

-- 5. +: 1개 이상의 반복
-- 숫자를 하나 이상 포함하는 사용자 이름을 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP '[0-9]+';
SELECT * FROM users WHERE username REGEXP '[:digit:]+';

-- 6. ?: 0개 또는 1개의 반복
-- 'd'가 하나 또는 없는 사용자 이름을 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP 'd?';

-- 7. |: 논리적 OR
-- 'john' 또는 'jane'이라는 이름을 가진 사용자를 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP 'john|jane';

-- 8. []: 범위 또는 문자 클래스
-- 알파벳 소문자 'a'에서 'e' 사이의 문자로 시작하는 사용자 이름을 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP '^[a-e]';

-- 9. (): 그룹화
-- 사용자 이름이 'bob'으로 시작하고 '-'를 포함한 사용자를 찾는 쿼리:
SELECT * FROM users WHERE username REGEXP '^(bob\-builder)$';
