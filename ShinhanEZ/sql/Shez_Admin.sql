-- ============================================= 고객 | customers ============================================= 
DROP TABLE shez_customers CASCADE CONSTRAINTS;
CREATE TABLE shez_customers (
    customer_id     VARCHAR2(50)    PRIMARY KEY,            -- 고객 ID (회원 ID)
    password        VARCHAR2(255)   NOT NULL,               -- 비밀번호 (암호화 저장) 무슨 용도?
    name            VARCHAR2(100)   NOT NULL,               -- 고객 이름
    birth_date      DATE            NOT NULL,               -- 생년월일
    gender          CHAR(1)         NOT NULL 
                        CHECK (gender IN ('M', 'F')),       -- 성별 (M:남, F:여)
    phone           VARCHAR2(20)    NOT NULL,               -- 연락처
    email           VARCHAR2(100),                          -- 이메일
    address         VARCHAR2(255),                          -- 주소
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
COMMENT ON COLUMN shez_customers.role IS '권한';
COMMENT ON COLUMN shez_customers.reg_date IS '등록일';

-- ============================================= 상품 | insurances ============================================= 
DROP TABLE SHEZ_INSURANCES CASCADE CONSTRAINTS;
CREATE TABLE SHEZ_INSURANCES (
    PRODUCT_NO      NUMBER(30)      PRIMARY KEY,             -- 상품번호 (PK)
    PRODUCT_NAME    VARCHAR2(200)   NOT NULL,                -- 상품명
    CATEGORY        VARCHAR2(50)    NOT NULL,                -- 분류 (예: 생명보험, 손해보험, 건강보험)
    BASE_PREMIUM    NUMBER          NOT NULL,                -- 기본 보험료
    COVERAGE_RANGE  VARCHAR2(1000)  NOT NULL,                -- 보장범위
    COVERAGE_PERIOD NUMBER(3)       NOT NULL,                -- 보장 기간 (개월 단위)
    STATUS          VARCHAR2(20)    DEFAULT 'INACTIVE' 
        CHECK (STATUS IN ('ACTIVE', 'INACTIVE')),            -- 상태 (활성/비활성)
    CREATED_DATE    DATE            DEFAULT SYSDATE,         -- 생성일
    UPDATED_DATE    DATE            DEFAULT SYSDATE,         -- 수정일
    CREATED_USER    VARCHAR2(50)    NOT NULL,                -- 생성자
    UPDATED_USER    VARCHAR2(50)    NOT NULL                 -- 수정자
);
-- 시퀀스
CREATE SEQUENCE seq_shezInsuraces
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- ============================================= 계약 | contracts ============================================= 
DROP TABLE shez_contracts CASCADE CONSTRAINTS;
CREATE TABLE shez_contracts (
    contract_id         NUMBER(30)      PRIMARY KEY,            -- 계약번호 | pk
    customer_id         VARCHAR2(50)    NOT NULL,               -- 고객번호 | fk
    insured_id          VARCHAR2(50)    NOT NULL,               -- 피보험자 | fk
    product_id          NUMBER(30)      NOT NULL,               -- 상품번호 | fk
    contract_coverage   VARCHAR2(3000)  NOT NULL,               -- 실제 보장내역
    reg_date            DATE            NOT NULL,               -- 계약일
    expired_date        DATE            NOT NULL,               -- 만료일
    premium_amount      NUMBER(30)      NOT NULL,               -- 실제 보험료
    payment_cycle       VARCHAR2(15)    NOT NULL                -- 납입주기
        CHECK(payment_cycle IN('월납', '분기납', '반기납', '연납', '일시납')),   
    contract_status     VARCHAR2(10)    NOT NULL 
        CHECK(payment_cycle IN('활성','만료','해지')),            -- 계약상태
    update_date         DATE            DEFAULT SYSDATE,        -- 수정일
    admin_id            NUMBER(30)      NOT NULL,               -- 관리자 번호
    CONSTRAINT fk_shez_contract_customer FOREIGN KEY (customer_id) REFERENCES shez_customers(customer_id),
    CONSTRAINT fk_shez_contract_insured FOREIGN KEY (insured_id) REFERENCES shez_customers(customer_id),
    CONSTRAINT fk_shez_contract_product FOREIGN KEY (product_no) REFERENCES SHEZ_INSURANCES(PRODUCT_NO),
    CONSTRAINT fk_shez_contract_admin FOREIGN KEY (admin_id) REFERENCES shez_admins(admin_id)
);
-- 시퀀스
CREATE SEQUENCE seq_shezContracts
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
-- 인덱스
CREATE INDEX idx_shez_contractId ON shez_contracts(contract_id);

-- ============================================= 청구 | claims ============================================= 
-- 1) sequence
create sequence seq_claim_id
  start with 1
  increment by 1
  nocache
  nocycle;

-- 2) table
create table shez_claims (
  claim_id              number(19)      primary key,       -- 1. 청구 번호 pk
  customer_id           VARCHAR2(50)    not null,          -- 2. 청구인 | 고객 fk
  insured_id            VARCHAR2(50)    not null,          -- 3. 피보험자 | 고객 fk
  contract_id           NUMBER(30)      not null,          -- 4. 계약 fk
  accident_date         date            not null,          -- 5. 사고일
  claim_date            date            not null,          -- 6. 청구일
  claim_amount          number(15,2)    default 0 not null,-- 7. 청구금액
  document_list         varchar2(1000),                    -- 8. 서류목록
  paid_at               date,                              -- 9. 지급일
  paid_amount           number(15,2),                      -- 10. 지급액
  status                varchar2(30)    not null,          -- 11. 처리 상태
  completed_at          date,                              -- 12. 처리 완료일
  admin_id              NUMBER(30)                         -- 13. 담당 관리자 fk
);
-- 3) trigger: claim_id 자동 채번 (더미데이터 편하게 넣으려고) -> id 시퀀스 알아서 넣어줌
create or replace trigger trg_shez_claims_bi
before insert on shez_claims
for each row
begin
  if :new.claim_id is null then
    select seq_claim_id.nextval into :new.claim_id from dual;
  end if;
end;

-- 4) constraints 3개의 항목만 들어올수 있음
alter table shez_claims add constraint ck_shez_claims_status
check (status in ('PENDING','COMPLETED','REJECTED'));

-- fk는 실제 테이블/컬럼명 맞춘 뒤에 적용
alter table shez_claims add constraint fk_shez_claims_claimant
foreign key (customer_id) references shez_customers(customer_id);

alter table shez_claims add constraint fk_shez_claims_insured
foreign key (insured_id) references shez_customers(customer_id);

alter table shez_claims add constraint fk_shez_claims_policy
foreign key (contract_id) references shez_contracts(contract_id);

alter table shez_claims add constraint fk_shez_claims_assignee
foreign key (admin_id) references shez_admins(admin_id);

-- 5) indexes (관리자 목록 최신순 + 상태 필터 대비)
create index idx_shez_claims_date_id
on shez_claims (claim_date desc, claim_id desc);

create index idx_shez_claims_status_date_id
on shez_claims (status, claim_date desc, claim_id desc);
-- ============================================= 납입 | payments ============================================= 
CREATE TABLE shez_payments (
    payment_id      NUMBER          PRIMARY KEY,            -- 납입 ID (PK)
    contract_id     NUMBER          NOT NULL,               -- 계약 ID (FK)
    payment_date    DATE,                                   -- 실제 납입일 (NULL 허용: 미납시)
    due_date        DATE            NOT NULL,               -- 납입 기한
    amount          NUMBER(12,2)    NOT NULL,               -- 납입 금액
    method          VARCHAR2(20),                           -- 납입 방법 (자동이체/카드/계좌이체)
    status          VARCHAR2(20)    DEFAULT 'PENDING',      -- 납입 상태 (PAID/PENDING/OVERDUE)
    reg_date        DATE            DEFAULT SYSDATE,        -- 등록일
    CONSTRAINT fk_payment_contract 
        FOREIGN KEY (contract_id) REFERENCES shez_contracts(contract_id)
);
-- 시퀀스
CREATE SEQUENCE payment_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
-- 인덱스
CREATE INDEX idx_payment_contract ON shez_payments(contract_id);
CREATE INDEX idx_payment_status ON shez_payments(status);
CREATE INDEX idx_payment_due_date ON shez_payments(due_date);

-- 컬럼 코멘트
COMMENT ON TABLE shez_payments IS '납입내역 테이블';
COMMENT ON COLUMN shez_payments.payment_id IS '납입 ID (PK)';
COMMENT ON COLUMN shez_payments.contract_id IS '계약 ID';
COMMENT ON COLUMN shez_payments.payment_date IS '실제 납입일 (미납시 NULL)';
COMMENT ON COLUMN shez_payments.due_date IS '납입 기한';
COMMENT ON COLUMN shez_payments.amount IS '납입 금액';
COMMENT ON COLUMN shez_payments.method IS '납입 방법 (자동이체/카드/계좌이체)';
COMMENT ON COLUMN shez_payments.status IS '납입 상태 (PAID:완료, PENDING:대기, OVERDUE:연체)';
COMMENT ON COLUMN shez_payments.reg_date IS '등록일';

-- ============================================= 관리자 | admins ============================================= 
CREATE TABLE shez_admins(
    admin_id    NUMBER(30)      PRIMARY KEY,
    id          VARCHAR2(50)    NOT NULL,
    pw          VARCHAR2(255)   NOT NULL,
    role        VARCHAR2(30)    DEFAULT 'staff' CHECK(payment_cycle IN('super','manager','staff')),
    name        VARCHAR2(60)    NOT NULL,
    department  VARCHAR2(30)    NOT NULL,
    last_login  DATE            DEFAULT SYSDATE
);
-- 시퀀스
CREATE SEQUENCE seq_shezAdmins
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
--인덱스
CREATE INDEX idx_shez_adminId ON shez_contracts(admin_id);
    
-- ============================================= CRUD 쿼리 ============================================= 
-- ============================================= 고객 | customers ============================================= 
-- 더미 데이터 (고객 10명)
INSERT INTO shez_customers VALUES ('C001', '1111', '김철수', TO_DATE('19850315','YYYYMMDD'), 'M', '010-1234-5678', 'kim@email.com', '서울시 강남구 테헤란로 123', SYSDATE);
INSERT INTO shez_customers VALUES ('C002', '1111', '이영희', TO_DATE('19900722','YYYYMMDD'), 'F', '010-2345-6789', 'lee@email.com', '서울시 서초구 서초대로 456', SYSDATE);
INSERT INTO shez_customers VALUES ('C003', '1111', '박민수', TO_DATE('19781105','YYYYMMDD'), 'M', '010-3456-7890', 'park@email.com', '경기도 성남시 분당구 판교로 789', SYSDATE);
INSERT INTO shez_customers VALUES ('C004', '1111', '최수진', TO_DATE('19950830','YYYYMMDD'), 'F', '010-4567-8901', 'choi@email.com', '인천시 연수구 컨벤시아대로 101', SYSDATE);
INSERT INTO shez_customers VALUES ('C005', '1111', '정대호', TO_DATE('19820214','YYYYMMDD'), 'M', '010-5678-9012', 'jung@email.com', '부산시 해운대구 해운대로 202', SYSDATE);
INSERT INTO shez_customers VALUES ('C006', '1111', '한미영', TO_DATE('19880919','YYYYMMDD'), 'F', '010-6789-0123', 'han@email.com', '대구시 수성구 수성로 303', SYSDATE);
INSERT INTO shez_customers VALUES ('C007', '1111', '강동원', TO_DATE('19751201','YYYYMMDD'), 'M', '010-7890-1234', 'kang@email.com', '광주시 서구 상무대로 404', SYSDATE);
INSERT INTO shez_customers VALUES ('C008', '1111', '윤서연', TO_DATE('19920605','YYYYMMDD'), 'F', '010-8901-2345', 'yoon@email.com', '대전시 유성구 대학로 505', SYSDATE);
INSERT INTO shez_customers VALUES ('C009', '1111', '임재현', TO_DATE('19800428','YYYYMMDD'), 'M', '010-9012-3456', 'lim@email.com', '울산시 남구 삼산로 606', SYSDATE);
INSERT INTO shez_customers VALUES ('C010', '1111', '송지은', TO_DATE('19970113','YYYYMMDD'), 'F', '010-0123-4567', 'song@email.com', '세종시 한누리대로 707', SYSDATE);

COMMIT;

-- 확인
SELECT * FROM shez_customers ORDER BY reg_date DESC;

-- 고객 수 확인
SELECT COUNT(*) AS total_customers FROM shez_customers;
-- ============================================= 상품 | insurances ============================================= 

-- ============================================= 계약 | contracts ============================================= 

-- ============================================= 청구 | claims ============================================= 
-- =========================================================
-- 6) dummy data (15 rows)
--   - claim_id는 트리거가 자동 생성
--   - completed만 paid_at/paid_amount/completed_at 세팅
-- =========================================================

insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (1, 1, 100, date '2025-01-01', date '2025-01-03',  500000, 'ID_CARD,ACCIDENT_REPORT', null, null,'PENDING', null, 10);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (2, 2, 101, date '2025-01-02', date '2025-01-04', 1200000, 'ID_CARD,MEDICAL_REPORT', null, null, 'PENDING', null, 11);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (3, 3, 102, date '2025-01-03', date '2025-01-05',  800000, 'ID_CARD', null, null, 'PENDING', null, 10);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (4, 4, 103, date '2025-01-04', date '2025-01-06',  300000, 'ID_CARD,ACCIDENT_REPORT', null, null, 'PENDING', null, 12);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (5, 5, 104, date '2025-01-05', date '2025-01-07', 1500000, 'ID_CARD,MEDICAL_REPORT', null, null, 'PENDING', null, 11);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (1, 2, 100, date '2025-01-06', date '2025-01-08',  200000, 'ID_CARD', null, null, 'PENDING', null, 10);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (2, 3, 101, date '2025-01-07', date '2025-01-09',  950000, 'ID_CARD,ACCIDENT_REPORT', null, null, 'PENDING', null, 12);
insert into shez_claims (customer_id, insured_customer_id, contract_id, ccident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (3, 3, 102, date '2025-01-08', date '2025-01-10',  430000, 'ID_CARD', sysdate - 2, 430000, 'COMPLETED', sysdate - 2, 11);
insert into shez_claims (customer_id, insured_customer_id, contract_id, ccident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values (4, 4, 103, date '2025-01-09', date '2025-01-11',  670000, 'ID_CARD,MEDICAL_REPORT', sysdate - 3, 670000, 'COMPLETED', sysdate - 3, 10);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values (5, 5, 104, date '2025-01-10', date '2025-01-12', 1100000, 'ID_CARD,ACCIDENT_REPORT', sysdate - 4, 1100000, 'COMPLETED', sysdate - 4, 12);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values (1, 1, 100, date '2025-01-11', date '2025-01-13',  520000, 'ID_CARD', sysdate - 5, 520000, 'COMPLETED', sysdate - 5, 11);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values (2, 2, 101, date '2025-01-12', date '2025-01-14',  780000, 'ID_CARD,MEDICAL_REPORT', sysdate - 6, 780000, 'COMPLETED', sysdate - 6, 10);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values (3, 3, 102, date '2025-01-13', date '2025-01-15',  640000, 'ID_CARD', null, null, 'REJECTED', sysdate - 1, 12);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values (4, 4, 103, date '2025-01-14', date '2025-01-16',  900000, 'ID_CARD,ACCIDENT_REPORT', null, null, 'REJECTED', sysdate - 2, 11);
insert into shez_claims (customer_id, insured_customer_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values (5, 5, 104, date '2025-01-15', date '2025-01-17',  350000, 'ID_CARD', null, null, 'REJECTED', sysdate - 3, 10);
commit;
-- =========================================================
-- 7) select (admin list / detail)
-- =========================================================
-- 전체 목록(최신순)
select * from shez_claims order by claim_date desc, claim_id desc;

-- 상세 조회
select * from shez_claims where claim_id = 1;

-- =========================================================
-- 8) update / delete (basic)
-- =========================================================

-- 담당자 배정 변경
update shez_claims set admin_id = TEST where claim_id = TEST;

-- 처리 완료(지급 포함) : pending만 완료 처리
update shez_claims set status = 'COMPLETED', completed_at = sysdate, paid_at = sysdate, paid_amount = :paid_amount where claim_id = :claim_id and status = 'PENDING';

-- 반려 : pending만 반려 처리
update shez_claims set status = 'REJECTED', completed_at = sysdate, paid_at = null, paid_amount = null where claim_id = :claim_id and status = 'PENDING';

-- 삭제
delete from shez_claims where claim_id = 1;

-- ============================================= 납입 | payments ============================================= 
-- ============================================
-- 더미 데이터
-- ============================================
-- 완료 상태 (PAID)
INSERT INTO shez_payments (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 1, TO_DATE('2025-01-05', 'YYYY-MM-DD'), TO_DATE('2025-01-10', 'YYYY-MM-DD'), 50000, '자동이체', 'PAID');

INSERT INTO shez_payments (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 1, TO_DATE('2025-02-05', 'YYYY-MM-DD'), TO_DATE('2025-02-10', 'YYYY-MM-DD'), 50000, '자동이체', 'PAID');

INSERT INTO shez_payments (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 2, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-05', 'YYYY-MM-DD'), 120000, '카드', 'PAID');

-- 대기 상태 (PENDING)
INSERT INTO shez_payments (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 2, NULL, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 75000, '카드', 'PENDING');

INSERT INTO shez_payments (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 3, NULL, TO_DATE('2025-01-20', 'YYYY-MM-DD'), 85000, '계좌이체', 'PENDING');

-- 연체 상태 (OVERDUE)
INSERT INTO shez_payments (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 3, NULL, TO_DATE('2024-12-31', 'YYYY-MM-DD'), 100000, '계좌이체', 'OVERDUE');

INSERT INTO shez_payments (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 4, NULL, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 95000, '카드', 'OVERDUE');

COMMIT;

-- ============================================
-- 확인 쿼리
-- ============================================
SELECT * FROM shez_payments ORDER BY payment_id;

SELECT status, COUNT(*) as cnt FROM shez_payments GROUP BY status;

-- ============================================= 관리자 | admins ============================================= 
