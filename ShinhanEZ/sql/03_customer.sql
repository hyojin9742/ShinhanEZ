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
    customer_id     VARCHAR2(50)    PRIMARY KEY,            -- 고객 ID (회원 ID)
    password        VARCHAR2(255)   NOT NULL,               -- 비밀번호 (암호화 저장)
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

-- 테이블 코멘트
COMMENT ON TABLE shez_customers IS '고객(보험자) 테이블';
COMMENT ON COLUMN shez_customers.customer_id IS '고객 ID (PK)';
COMMENT ON COLUMN shez_customers.password IS '비밀번호';
COMMENT ON COLUMN shez_customers.name IS '고객 이름';
COMMENT ON COLUMN shez_customers.birth_date IS '생년월일';
COMMENT ON COLUMN shez_customers.gender IS '성별 (M:남, F:여)';
COMMENT ON COLUMN shez_customers.phone IS '연락처';
COMMENT ON COLUMN shez_customers.email IS '이메일';
COMMENT ON COLUMN shez_customers.address IS '주소';
COMMENT ON COLUMN shez_customers.status IS '상태 (Y:활성, N:비활성)';
COMMENT ON COLUMN shez_customers.reg_date IS '등록일';

-- 더미 데이터 (고객 10명)
INSERT INTO shez_customers VALUES ('C001', '1111', '김철수', TO_DATE('19850315','YYYYMMDD'), 'M', '010-1234-5678', 'kim@email.com', '서울시 강남구 테헤란로 123', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C002', '1111', '이영희', TO_DATE('19900722','YYYYMMDD'), 'F', '010-2345-6789', 'lee@email.com', '서울시 서초구 서초대로 456', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C003', '1111', '박민수', TO_DATE('19781105','YYYYMMDD'), 'M', '010-3456-7890', 'park@email.com', '경기도 성남시 분당구 판교로 789', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C004', '1111', '최수진', TO_DATE('19950830','YYYYMMDD'), 'F', '010-4567-8901', 'choi@email.com', '인천시 연수구 컨벤시아대로 101', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C005', '1111', '정대호', TO_DATE('19820214','YYYYMMDD'), 'M', '010-5678-9012', 'jung@email.com', '부산시 해운대구 해운대로 202', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C006', '1111', '한미영', TO_DATE('19880919','YYYYMMDD'), 'F', '010-6789-0123', 'han@email.com', '대구시 수성구 수성로 303', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C007', '1111', '강동원', TO_DATE('19751201','YYYYMMDD'), 'M', '010-7890-1234', 'kang@email.com', '광주시 서구 상무대로 404', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C008', '1111', '윤서연', TO_DATE('19920605','YYYYMMDD'), 'F', '010-8901-2345', 'yoon@email.com', '대전시 유성구 대학로 505', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C009', '1111', '임재현', TO_DATE('19800428','YYYYMMDD'), 'M', '010-9012-3456', 'lim@email.com', '울산시 남구 삼산로 606', 'Y', SYSDATE);
INSERT INTO shez_customers VALUES ('C010', '1111', '송지은', TO_DATE('19970113','YYYYMMDD'), 'F', '010-0123-4567', 'song@email.com', '세종시 한누리대로 707', 'Y', SYSDATE);

COMMIT;

-- 확인
SELECT * FROM shez_customers ORDER BY reg_date DESC;

-- 고객 수 확인
SELECT COUNT(*) AS total_customers FROM shez_customers;
