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
    reg_date    DATE            DEFAULT SYSDATE,        -- 가입일
    login_naver VARCHAR2(3000),
    login_google VARCHAR2(3000),
    login_kakao VARCHAR2(3000),
    provider    VARCHAR2(90)                            -- 간편로그인 provider
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

-- 더미 데이터 유저
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user1', '1111', 'kim.minho@email.com', '김민호', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'SKT', 'M', '010-1234-5678', 'K', 'ROLE_USER', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user2', '1111', 'lee.jieun@email.com', '이지은', TO_DATE('1993-03-22', 'YYYY-MM-DD'), 'KT', 'F', '010-2345-6789', 'K', 'ROLE_USER', TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user3', '1111', 'choi.yuna@email.com', '최유나', TO_DATE('1995-07-30', 'YYYY-MM-DD'), 'LGU+', 'F', '010-3456-7890', 'K', 'ROLE_USER', TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user4', '1111', 'john.smith@email.com', 'John Smith', TO_DATE('1988-12-12', 'YYYY-MM-DD'), 'SKT', 'M', '010-4567-8901', 'F', 'ROLE_USER', TO_DATE('2024-04-05', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user5', '1111', 'jung.sora@email.com', '정소라', TO_DATE('1992-09-18', 'YYYY-MM-DD'), 'KT', 'F', '010-5678-9012', 'K', 'ROLE_USER', TO_DATE('2024-05-12', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user6', '1111', 'kang.junho@email.com', '강준호', TO_DATE('1987-04-25', 'YYYY-MM-DD'), 'LGU+', 'M', '010-6789-0123', 'K', 'ROLE_USER', TO_DATE('2024-06-18', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user7', '1111', 'maria.garcia@email.com', 'Maria Garcia', TO_DATE('1994-08-07', 'YYYY-MM-DD'), 'SKT', 'F', '010-7890-1234', 'F', 'ROLE_USER', TO_DATE('2024-07-22', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user8', '1111', 'yoon.taehyung@email.com', '윤태형', TO_DATE('1991-02-14', 'YYYY-MM-DD'), 'KT', 'M', '010-8901-2345', 'K', 'ROLE_USER', TO_DATE('2024-08-30', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user9', '1111', 'han.soyoung@email.com', '한소영', TO_DATE('1996-06-20', 'YYYY-MM-DD'), 'LGU+', 'F', '010-9012-3456', 'K', 'ROLE_USER', TO_DATE('2024-09-15', 'YYYY-MM-DD'));
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date)
VALUES ('user10', '1111', 'park.seojun@email.com', '박서준', TO_DATE('1989-11-03', 'YYYY-MM-DD'), 'SKT', 'M', '010-0123-4567', 'K', 'ROLE_USER', TO_DATE('2024-10-10', 'YYYY-MM-DD'));

-- 더미 관리자
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role) 
VALUES ('admin', '1111', 'admin@shinhanez.co.kr', '관리자', TO_DATE('19900101','YYYYMMDD'), 'SKT', 'M', '01012345678', 'K', 'ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role) 
VALUES ('admin22', '1111', 'admin@shinhanez.co.kr', '관리자', TO_DATE('19900101','YYYYMMDD'), 'SKT', 'M', '01012345678', 'K', 'ROLE_ADMIN');

COMMIT;

-- 확인
SELECT * FROM shez_user;
