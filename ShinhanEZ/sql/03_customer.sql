/*
    =============================================
    ShinhanEZ - 03. 고객/보험자(customer) 테이블
    =============================================
    - 보험 계약을 체결하는 고객(보험자)의 정보를 저장
    - 관리자 페이지에서 CRUD 관리
    =============================================
*/

-- 고객(보험자) 테이블 생성
DROP TABLE shez_customers CASCADE CONSTRAINTS;
CREATE TABLE shez_customers (
    customer_id     VARCHAR2(50)    PRIMARY KEY,            -- 고객 PK
    login_id        VARCHAR2(50)    NOT NULL,
    name            VARCHAR2(100)   NOT NULL,               -- 고객 이름
    birth_date      DATE            NOT NULL,               -- 생년월일
    gender          CHAR(1)         NOT NULL
                        CHECK (gender IN ('M', 'F')),       -- 성별 (M:남, F:여)
    phone           VARCHAR2(20)    NOT NULL,               -- 연락처
    email           VARCHAR2(100),                          -- 이메일
    address         VARCHAR2(255),                          -- 주소
    status          CHAR(1)         DEFAULT 'Y'
                        CHECK (status IN ('Y', 'N')),       -- 상태 (Y:활성, N:비활성)
    reg_date        DATE            DEFAULT SYSDATE         -- 등록일
);
ALTER TABLE shez_customers add CONSTRAINT uq_shez_customer_uniqueId
UNIQUE (login_id);
alter table shez_customers add constraint fk_shez_customer_loginId
foreign key (login_id) references shez_user(id);
-- 테이블 코멘트
COMMENT ON TABLE shez_customers IS '고객(보험자) 테이블';
COMMENT ON COLUMN shez_customers.customer_id IS '고객 ID (PK)';
COMMENT ON COLUMN shez_customers.name IS '고객 이름';
COMMENT ON COLUMN shez_customers.birth_date IS '생년월일';
COMMENT ON COLUMN shez_customers.gender IS '성별 (M:남, F:여)';
COMMENT ON COLUMN shez_customers.phone IS '연락처';
COMMENT ON COLUMN shez_customers.email IS '이메일';
COMMENT ON COLUMN shez_customers.address IS '주소';
COMMENT ON COLUMN shez_customers.status IS '상태 (Y:활성, N:비활성)';
COMMENT ON COLUMN shez_customers.reg_date IS '등록일';

-- 더미 데이터 (고객 10명)
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C001', 'user1', '김민호', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 'M', '010-1234-5678', 'kim.minho@email.com', '서울특별시 강남구 테헤란로 123', 'Y', TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C002', 'user2', '이지은', TO_DATE('1993-03-22', 'YYYY-MM-DD'), 'F', '010-2345-6789', 'lee.jieun@email.com', '서울특별시 서초구 서초대로 456', 'Y', TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C003', 'user3', '최유나', TO_DATE('1995-07-30', 'YYYY-MM-DD'), 'F', '010-3456-7890', 'choi.yuna@email.com', '경기도 성남시 분당구 판교역로 789', 'Y', TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C004', 'user4', 'John Smith', TO_DATE('1988-12-12', 'YYYY-MM-DD'), 'M', '010-4567-8901', 'john.smith@email.com', '서울특별시 용산구 이태원로 100', 'Y', TO_DATE('2024-04-05', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C005', 'user5', '정소라', TO_DATE('1992-09-18', 'YYYY-MM-DD'), 'F', '010-5678-9012', 'jung.sora@email.com', '인천광역시 남동구 구월동 200', 'Y', TO_DATE('2024-05-12', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C006', 'user6', '강준호', TO_DATE('1987-04-25', 'YYYY-MM-DD'), 'M', '010-6789-0123', 'kang.junho@email.com', '부산광역시 해운대구 우동 300', 'Y', TO_DATE('2024-06-18', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C007', 'user7', 'Maria Garcia', TO_DATE('1994-08-07', 'YYYY-MM-DD'), 'F', '010-7890-1234', 'maria.garcia@email.com', '서울특별시 마포구 상암동 400', 'Y', TO_DATE('2024-07-22', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C008', 'user8', '윤태형', TO_DATE('1991-02-14', 'YYYY-MM-DD'), 'M', '010-8901-2345', 'yoon.taehyung@email.com', '대구광역시 수성구 범어동 500', 'Y', TO_DATE('2024-08-30', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C009', 'user9', '한소영', TO_DATE('1996-06-20', 'YYYY-MM-DD'), 'F', '010-9012-3456', 'han.soyoung@email.com', '경기도 수원시 영통구 광교중앙로 600', 'Y', TO_DATE('2024-09-15', 'YYYY-MM-DD'));
INSERT INTO shez_customers (customer_id, login_id, name, birth_date, gender, phone, email, address, status, reg_date)
VALUES ('C010', 'user10', '박서준', TO_DATE('1989-11-03', 'YYYY-MM-DD'), 'M', '010-0123-4567', 'park.seojun@email.com', '서울특별시 송파구 잠실동 700', 'Y', TO_DATE('2024-10-10', 'YYYY-MM-DD'));

COMMIT;

-- 확인
SELECT * FROM shez_customers ORDER BY reg_date DESC;

-- 고객 수 확인
SELECT COUNT(*) AS total_customers FROM shez_customers;
