/*
    =============================================
    ShinhanEZ - 01. 회원(shez_user) 테이블
    =============================================
    - 웹사이트 로그인용 회원 테이블
    - role 컬럼으로 일반회원/관리자 구분
    =============================================
*/

-- 테이블 삭제 (초기화 시)
DROP TABLE shez_board CASCADE CONSTRAINTS;
DROP TABLE shez_user CASCADE CONSTRAINTS;

-- 회원 테이블 생성
CREATE TABLE shez_user (
    id          VARCHAR2(50)    PRIMARY KEY,            -- 회원 ID
    pw          VARCHAR2(255)   NOT NULL,               -- 비밀번호
    email       VARCHAR2(300),                          -- 이메일
    name        VARCHAR2(50)    NOT NULL,               -- 이름
    birth       DATE            NOT NULL,               -- 생년월일
    telecom     VARCHAR2(30),                           -- 통신사
    gender      CHAR(1),                                -- 성별 (M/F)
    phone       VARCHAR2(45)    NOT NULL,               -- 연락처
    nation      CHAR(1)         NOT NULL,               -- 내/외국인 (K/F)
    role        VARCHAR2(20)    DEFAULT 'ROLE_USER',    -- 권한 (ROLE_USER, ROLE_ADMIN)
    reg_date    DATE            DEFAULT SYSDATE         -- 가입일
);

-- 테이블 코멘트
COMMENT ON TABLE shez_user IS '웹사이트 회원 테이블';
COMMENT ON COLUMN shez_user.id IS '회원 ID (PK)';
COMMENT ON COLUMN shez_user.pw IS '비밀번호';
COMMENT ON COLUMN shez_user.email IS '이메일';
COMMENT ON COLUMN shez_user.name IS '이름';
COMMENT ON COLUMN shez_user.birth IS '생년월일';
COMMENT ON COLUMN shez_user.telecom IS '통신사';
COMMENT ON COLUMN shez_user.gender IS '성별 (M:남, F:여)';
COMMENT ON COLUMN shez_user.phone IS '연락처';
COMMENT ON COLUMN shez_user.nation IS '내/외국인 (K:내국인, F:외국인)';
COMMENT ON COLUMN shez_user.role IS '권한 (ROLE_USER:일반, ROLE_ADMIN:관리자)';
COMMENT ON COLUMN shez_user.reg_date IS '가입일';

-- 더미 데이터
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role) 
VALUES ('admin', '1111', 'admin@shinhanez.co.kr', '관리자', TO_DATE('19900101','YYYYMMDD'), 'SKT', 'M', '01012345678', 'K', 'ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role) 
VALUES ('admin22', '1111', 'admin@shinhanez.co.kr', '관리자', TO_DATE('19900101','YYYYMMDD'), 'SKT', 'M', '01012345678', 'K', 'ROLE_ADMIN');

INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role) 
VALUES ('user1', '1111', 'user1@test.com', '홍길동', TO_DATE('19950315','YYYYMMDD'), 'KT', 'M', '01011112222', 'K', 'ROLE_USER');

INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role) 
VALUES ('user2', '1111', 'user2@test.com', '김영희', TO_DATE('19980720','YYYYMMDD'), 'LGU+', 'F', '01033334444', 'K', 'ROLE_USER');

COMMIT;

-- 확인
SELECT * FROM shez_user;
