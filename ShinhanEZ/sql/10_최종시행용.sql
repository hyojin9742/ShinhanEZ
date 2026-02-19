-- ============================================= 회원 테이블 생성 ============================================= 
DROP TABLE shez_user CASCADE CONSTRAINTS;
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
    provider    VARCHAR2(90)                            -- 간편로그인 provider
);
-- ============================================= 게시판 테이블 생성 ============================================= 
DROP TABLE shez_board CASCADE CONSTRAINTS;
CREATE TABLE shez_board (
    idx         NUMBER          PRIMARY KEY,            -- 게시글 번호
    title       VARCHAR2(200)   NOT NULL,               -- 제목
    reg_date    DATE            DEFAULT SYSDATE,        -- 등록일
    textarea    VARCHAR2(3000)  NOT NULL,               -- 내용
    cnt         NUMBER          DEFAULT 0,              -- 조회수
    id          VARCHAR2(50)    NOT NULL,               -- 작성자 ID
    CONSTRAINT fk_shez_board_user 
        FOREIGN KEY (id) REFERENCES shez_user(id)
);
-- ============================================= 고객(보험자) 테이블 생성 ============================================= 
DROP TABLE shez_customers CASCADE CONSTRAINTS;
CREATE TABLE shez_customers (
    customer_id     VARCHAR2(50)    PRIMARY KEY,            -- 고객 PK
    login_id        VARCHAR2(50),
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
-- ============================================= 관리자 | admins ============================================= 
DROP TABLE shez_admins CASCADE CONSTRAINTS;
CREATE TABLE shez_admins(
    admin_idx         NUMBER(30)      ,
    admin_id          VARCHAR2(50)    NOT NULL,
    admin_pw          VARCHAR2(255)   NOT NULL,
    admin_role        VARCHAR2(30)    DEFAULT 'staff' CHECK(admin_role IN('super','manager','staff')),
    admin_name        VARCHAR2(60)    NOT NULL,
    department  VARCHAR2(30)    NOT NULL,
    last_login  DATE            DEFAULT SYSDATE,
    CONSTRAINT pk_shez_adminidx PRIMARY KEY (admin_idx),
    CONSTRAINT uk_shez_admins_admin_id UNIQUE (admin_id)
);
-- 시퀀스
DROP SEQUENCE seq_shezAdmins;
CREATE SEQUENCE seq_shezAdmins
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
-- ============================================= 상품 | insurances ============================================= 
DROP TABLE SHEZ_INSURANCES CASCADE CONSTRAINTS;
CREATE TABLE SHEZ_INSURANCES (
    PRODUCTNO      NUMBER(30)      PRIMARY KEY,             -- 상품번호 (PK)
    PRODUCTNAME    VARCHAR2(200)   NOT NULL,                -- 상품명
    CATEGORY        VARCHAR2(50)    NOT NULL,                -- 분류 (예: 생명보험, 손해보험, 건강보험)
    BASEPREMIUM    NUMBER          NOT NULL,                -- 기본 보험료
    COVERAGERANGE  VARCHAR2(1000)  NOT NULL,                -- 보장범위
    COVERAGEPERIOD NUMBER(3)       NOT NULL,                -- 보장 기간 (개월 단위)
    STATUS          VARCHAR2(20)    DEFAULT 'INACTIVE' 
        CHECK (STATUS IN ('ACTIVE', 'INACTIVE')),            -- 상태 (활성/비활성)
    CREATEDDATE    DATE            DEFAULT SYSDATE,         -- 생성일
    UPDATEDDATE    DATE            DEFAULT SYSDATE,         -- 수정일
    CREATEDUSER    VARCHAR2(50)    NOT NULL,                -- 생성자
    UPDATEDUSER    VARCHAR2(50)    NOT NULL                 -- 수정자
);    
-- 시퀀스
DROP SEQUENCE seq_shezinsuraces;
CREATE SEQUENCE seq_shezinsuraces
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;    
-- ============================================= 계약 | contracts ============================================= 
DROP TABLE shez_contracts CASCADE CONSTRAINTS;
CREATE TABLE shez_contracts (
    contract_id         NUMBER(30)      ,            -- 계약번호 | pk
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
        CHECK(contract_status IN('활성','만료','해지','대기')),    -- 계약상태
    update_date         DATE            DEFAULT SYSDATE,        -- 수정일
    admin_idx           NUMBER(30),                             -- 관리자 번호
    sign_name           VARCHAR2(100),                          -- 서명 이름
    sign_image          CLOB,                                   -- 서명 이미지
    signed_date         DATE            DEFAULT SYSDATE,        -- 서명일자
    CONSTRAINT pk_shez_contractid PRIMARY KEY (contract_id)
);
-- 제약 사항
ALTER TABLE shez_contracts ADD CONSTRAINT fk_shez_contract_customer
FOREIGN KEY (customer_id) REFERENCES shez_customers(customer_id);
ALTER TABLE shez_contracts ADD CONSTRAINT fk_shez_contract_insured
FOREIGN KEY (insured_id) REFERENCES shez_customers(customer_id);
ALTER TABLE shez_contracts ADD CONSTRAINT fk_shez_contract_product
FOREIGN KEY (product_id) REFERENCES SHEZ_INSURANCES(PRODUCTNO);
ALTER TABLE shez_contracts ADD CONSTRAINT fk_shez_contract_admin
FOREIGN KEY (admin_idx) REFERENCES shez_admins(admin_idx);
-- 시퀀스
DROP SEQUENCE seq_shezContracts;
CREATE SEQUENCE seq_shezContracts
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
-- 인덱스
CREATE INDEX idx_contracts_regdate_desc ON SHEZ_CONTRACTS(REG_DATE DESC, CONTRACT_ID DESC);
CREATE INDEX idx_contracts_customer ON SHEZ_CONTRACTS(CUSTOMER_ID, REG_DATE DESC);
CREATE INDEX idx_contracts_status_regdate ON SHEZ_CONTRACTS(CONTRACT_STATUS, REG_DATE DESC);
-- ============================================
-- 납입내역 테이블 생성
-- ============================================
DROP TABLE shez_payments CASCADE CONSTRAINTS;
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
DROP SEQUENCE payment_seq;
CREATE SEQUENCE payment_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
-- 인덱스
CREATE INDEX idx_payment_contract ON shez_payments(contract_id);
CREATE INDEX idx_payment_status ON shez_payments(status);
CREATE INDEX idx_payment_due_date ON shez_payments(due_date);
-- ============================================= 청구 | claims ============================================= 
-- 1) sequence
drop sequence seq_claim_id;
create sequence seq_claim_id
  start with 1
  increment by 1
  nocache
  nocycle;
-- 2) table
ALTER TRIGGER trg_shez_claims_bi DISABLE;
drop table shez_claims CASCADE CONSTRAINTS;
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
  admin_idx              NUMBER(30)                         -- 13. 담당 관리자 fk
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
/
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
foreign key (admin_idx) references shez_admins(admin_idx);

-- 5) indexes (관리자 목록 최신순 + 상태 필터 대비)
create index idx_shez_claims_date_id
on shez_claims (claim_date desc, claim_id desc);

create index idx_shez_claims_status_date_id
on shez_claims (status, claim_date desc, claim_id desc);
-- ============================================= claims_file =============================================
-- 1) sequence
drop sequence seq_claim_file_id;
create sequence seq_claim_file_id
  start with 1
  increment by 1
  nocache
  nocycle;

-- 2) table
ALTER TRIGGER trg_shez_claim_files_bi DISABLE;
drop table shez_claim_files CASCADE CONSTRAINTS;
create table shez_claim_files (
  file_id            number(19)        primary key,        -- PK
  claim_id           number(19)        not null,           -- FK -> shez_claims.claim_id

  doc_type           varchar2(30)      default 'ETC' not null, -- 서류 종류(확장 가능)
  original_name      varchar2(255)     not null,           -- 원본 파일명
  storage_key        varchar2(500)     not null,           -- 저장 키(상대경로/키)
  content_type       varchar2(100),                        -- MIME
  file_size          number(19),                           -- bytes

  uploaded_by        varchar2(50),                         -- 업로드한 주체(고객ID 등) 선택
  created_at         date              default sysdate not null,
  is_deleted         char(1)           default 'N' not null
);
-- 3) trigger: file_id 자동 채번
create or replace trigger trg_shez_claim_files_bi
before insert on shez_claim_files
for each row
begin
  if :new.file_id is null then
    select seq_claim_file_id.nextval into :new.file_id from dual;
  end if;
end;
/
 
-- 4) constraints
alter table shez_claim_files add constraint ck_shez_claim_files_deleted
check (is_deleted in ('Y','N'));
-- FK (부모 청구)
alter table shez_claim_files add constraint fk_claim_files_claim
foreign key (claim_id) references shez_claims(claim_id);

-- 5) indexes
-- 청구 상세에서 파일 목록 빠르게
create index idx_claim_files_claim_created
on shez_claim_files (claim_id, created_at desc);

-- 다운로드/관리에서 doc_type별 정렬/필터 시 유용
create index idx_claim_files_claim_doctype
on shez_claim_files (claim_id, doc_type);


-- ============================================= 더미데이터 =============================================
-- ============================================= 회원 | 20건 =============================================
INSERT INTO shez_user (
    id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date, provider
) VALUES (
    'user1', '$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO', 'user1@test.com', '홍길동',DATE '1990-01-01', 'SKT', 'M', '010-1111-1111', 'K','ROLE_USER', SYSDATE, NULL
);

INSERT INTO shez_user (
    id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date, provider
) VALUES (
    'user2', '$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO', 'user2@test.com', '김영희', DATE '1992-05-10', 'KT', 'F', '010-2222-2222', 'K','ROLE_USER', SYSDATE, NULL
);

INSERT INTO shez_user (
    id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date, provider
) VALUES (
    'user3', '$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO', 'user3@test.com', '이철수', DATE '1988-09-23', 'LGU+', 'M', '010-3333-3333', 'K', 'ROLE_USER', SYSDATE, NULL
);

INSERT INTO shez_user (
    id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date, provider
) VALUES (
    'user4', '$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO', 'user4@test.com', '박민지', DATE '1995-12-15', 'SKT', 'F', '010-4444-4444', 'K','ROLE_USER', SYSDATE, NULL
);

INSERT INTO shez_user (
    id, pw, email, name, birth, telecom, gender, phone, nation, role, reg_date, provider
) VALUES (
    'user5', '$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO', 'user5@test.com', '김철수', DATE '1993-07-07', 'KT', 'F', '010-5555-5555', 'K','ROLE_USER', SYSDATE, NULL
);
INSERT INTO shez_user VALUES
('user6','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user6@test.com','최민수', DATE '1991-03-12','SKT','M','010-6666-6666','K','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user7','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user7@test.com','한지은', DATE '1994-11-08','KT','F','010-7777-7777','K','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user8','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','john.smith@test.com','John Smith', DATE '1989-06-21','LGU+','M','010-8888-8888','F','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user9','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','emma.w@test.com','Emma Wilson', DATE '1992-02-14','SKT','F','010-9999-9999','F','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user10','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user10@test.com','윤서준', DATE '1987-08-30','KT','M','010-1010-1010','K','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user11','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','alex.k@test.com','Alex Kim', DATE '1990-01-19','LGU+','M','010-1111-2222','F','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user12','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user12@test.com','김나래', DATE '1996-04-03','SKT','F','010-1212-1212','K','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user13','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','maria.g@test.com','Maria Garcia', DATE '1985-09-09','KT','F','010-1313-1313','F','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user14','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user14@test.com','박현우', DATE '1993-12-25','LGU+','M','010-1414-1414','K','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user15','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','li.wei@test.com','Li Wei', DATE '1991-05-17','SKT','M','010-1515-1515','F','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user16','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user16@test.com','서유진', DATE '1997-07-01','KT','F','010-1616-1616','K','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user17','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','daniel.b@test.com','Daniel Brown', DATE '1988-10-11','LGU+','M','010-1717-1717','F','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user18','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user18@test.com','오지훈', DATE '1990-02-28','SKT','M','010-1818-1818','K','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user19','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','sophia.l@test.com','Sophia Lee', DATE '1994-06-06','KT','F','010-1919-1919','F','ROLE_USER',SYSDATE,NULL);

INSERT INTO shez_user VALUES
('user20','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','user20@test.com','정민재', DATE '1986-09-14','LGU+','M','010-2020-2020','K','ROLE_USER',SYSDATE,NULL);

COMMIT;
-- ============================================= 게시판 | 20건 =============================================
INSERT INTO shez_board VALUES
(1, '첫 번째 게시글입니다', SYSDATE-20, '게시판 더미 데이터 테스트용 글입니다.', 12, 'user1');

INSERT INTO shez_board VALUES
(2, '보험 가입 문의', SYSDATE-19, '보험 가입 절차가 어떻게 되나요?', 8, 'user2');

INSERT INTO shez_board VALUES
(3, '계약서 확인 요청', SYSDATE-18, '계약서 PDF 확인 부탁드립니다.', 15, 'user3');

INSERT INTO shez_board VALUES
(4, '로그인 오류 발생', SYSDATE-17, '로그인이 안 되는 문제가 있습니다.', 22, 'user4');

INSERT INTO shez_board VALUES
(5, '회원정보 수정 방법', SYSDATE-16, '전화번호 수정은 어디서 하나요?', 6, 'user5');

INSERT INTO shez_board VALUES
(6, '외국인 가입 가능 여부', SYSDATE-15, '외국인도 보험 가입이 가능한가요?', 19, 'user8');

INSERT INTO shez_board VALUES
(7, '보험료 납부 관련', SYSDATE-14, '보험료 자동이체 설정 방법 문의', 11, 'user6');

INSERT INTO shez_board VALUES
(8, '보장 내용 문의', SYSDATE-13, '이 상품의 보장 범위가 궁금합니다.', 17, 'user7');

INSERT INTO shez_board VALUES
(9, '계약 해지 요청', SYSDATE-12, '계약 해지는 어떻게 진행되나요?', 25, 'user9');

INSERT INTO shez_board VALUES
(10, '모바일 이용 문의', SYSDATE-11, '모바일에서도 계약서 확인되나요?', 9, 'user10');

INSERT INTO shez_board VALUES
(11, '관리자 답변 요청', SYSDATE-10, '문의글에 답변이 아직 없어요.', 14, 'user11');

INSERT INTO shez_board VALUES
(12, '보험금 청구 방법', SYSDATE-9, '보험금 청구 절차 알려주세요.', 31, 'user12');

INSERT INTO shez_board VALUES
(13, '이메일 변경 문의', SYSDATE-8, '이메일 주소 변경하고 싶어요.', 7, 'user13');

INSERT INTO shez_board VALUES
(14, '계약 기간 연장', SYSDATE-7, '계약 기간 연장이 가능한가요?', 18, 'user14');

INSERT INTO shez_board VALUES
(15, '상품 추천 요청', SYSDATE-6, '30대에게 추천할 보험 있나요?', 27, 'user15');

INSERT INTO shez_board VALUES
(16, 'PDF 다운로드 오류', SYSDATE-5, '계약서 PDF가 안 열립니다.', 21, 'user16');

INSERT INTO shez_board VALUES
(17, '가입 취소 문의', SYSDATE-4, '가입 취소는 어디서 하나요?', 10, 'user17');

INSERT INTO shez_board VALUES
(18, '해외 거주자 보험', SYSDATE-3, '해외 거주 중인데 가입 가능할까요?', 16, 'user18');

INSERT INTO shez_board VALUES
(19, '고객센터 운영시간', SYSDATE-2, '고객센터 운영시간이 궁금합니다.', 5, 'user19');

INSERT INTO shez_board VALUES
(20, '사이트 개선 제안', SYSDATE-1, 'UI가 조금 복잡한 것 같아요.', 13, 'user20');

COMMIT;
-- ============================================= 고객 | 40건 =============================================
-- =================================== 비활성 3건 | 활성 20건 | 피보험자 17건 =================================== 
INSERT INTO shez_customers VALUES ('C001',NULL,'김영수',DATE '1978-03-22','M','010-4000-0001','inactive1@test.com','서울특별시 마포구','N',ADD_MONTHS(SYSDATE,-72));
INSERT INTO shez_customers VALUES ('C002',NULL,'Anna Brown',DATE '1980-11-05','F','010-4000-0002','inactive2@test.com','경기도 고양시 일산동구','N',ADD_MONTHS(SYSDATE,-96));
INSERT INTO shez_customers VALUES ('C003',NULL,'이정은',DATE '1975-06-14','F','010-4000-0003','inactive3@test.com','대구광역시 수성구','N',ADD_MONTHS(SYSDATE,-132));

INSERT INTO shez_customers VALUES ('C004','user1','홍길동',DATE '1990-01-01','M','010-5000-0001','a1@test.com','서울특별시 강서구','Y',ADD_MONTHS(SYSDATE,-6));
INSERT INTO shez_customers VALUES ('C005','user2','김영희',DATE '1992-05-10','F','010-5000-0002','a2@test.com','서울특별시 송파구','Y',ADD_MONTHS(SYSDATE,-8));
INSERT INTO shez_customers VALUES ('C006','user3','이철수',DATE '1988-09-23','M','010-5000-0003','a3@test.com','경기도 수원시','Y',ADD_MONTHS(SYSDATE,-10));
INSERT INTO shez_customers VALUES ('C007','user4','박민지',DATE '1995-12-15','F','010-5000-0004','a4@test.com','경기도 용인시','Y',ADD_MONTHS(SYSDATE,-12));
INSERT INTO shez_customers VALUES ('C008','user5','김철수',DATE '1993-07-07','F','010-5000-0005','a5@test.com','인천광역시 연수구','Y',ADD_MONTHS(SYSDATE,-14));
INSERT INTO shez_customers VALUES ('C009','user6','최민수',DATE '1991-03-12','M','010-5000-0006','a6@test.com','서울특별시 구로구','Y',ADD_MONTHS(SYSDATE,-16));
INSERT INTO shez_customers VALUES ('C010','user7','한지은',DATE '1994-11-08','F','010-5000-0007','a7@test.com','서울특별시 성동구','Y',ADD_MONTHS(SYSDATE,-18));
INSERT INTO shez_customers VALUES ('C011','user8','John Smith',DATE '1989-06-21','M','010-5000-0008','a8@test.com','경기도 고양시','Y',ADD_MONTHS(SYSDATE,-20));
INSERT INTO shez_customers VALUES ('C012','user9','Emma Wilson',DATE '1992-02-14','F','010-5000-0009','a9@test.com','경기도 파주시','Y',ADD_MONTHS(SYSDATE,-22));
INSERT INTO shez_customers VALUES ('C013','user10','윤서준',DATE '1987-08-30','M','010-5000-0010','a10@test.com','서울특별시 중랑구','Y',ADD_MONTHS(SYSDATE,-24));
INSERT INTO shez_customers VALUES ('C014','user11','Alex Kim',DATE '1990-01-19','M','010-5000-0011','a11@test.com','서울특별시 동작구','Y',ADD_MONTHS(SYSDATE,-26));
INSERT INTO shez_customers VALUES ('C015','user12','김나래',DATE '1996-04-03','F','010-5000-0012','a12@test.com','서울특별시 은평구','Y',ADD_MONTHS(SYSDATE,-28));
INSERT INTO shez_customers VALUES ('C016','user13','Maria Garcia',DATE '1985-09-09','F','010-5000-0013','a13@test.com','경기도 안양시','Y',ADD_MONTHS(SYSDATE,-30));
INSERT INTO shez_customers VALUES ('C017','user14','박현우',DATE '1993-12-25','M','010-5000-0014','a14@test.com','부산광역시 해운대구','Y',ADD_MONTHS(SYSDATE,-32));
INSERT INTO shez_customers VALUES ('C018','user15','Li Wei',DATE '1991-05-17','M','010-5000-0015','a15@test.com','부산광역시 수영구','Y',ADD_MONTHS(SYSDATE,-34));
INSERT INTO shez_customers VALUES ('C019','user16','서유진',DATE '1997-07-01','F','010-5000-0016','a16@test.com','대전광역시 서구','Y',ADD_MONTHS(SYSDATE,-36));
INSERT INTO shez_customers VALUES ('C020','user17','Daniel Brown',DATE '1988-10-11','M','010-5000-0017','a17@test.com','대전광역시 유성구','Y',ADD_MONTHS(SYSDATE,-38));
INSERT INTO shez_customers VALUES ('C021','user18','오지훈',DATE '1990-02-28','M','010-5000-0018','a18@test.com','광주광역시 북구','Y',ADD_MONTHS(SYSDATE,-40));
INSERT INTO shez_customers VALUES ('C022','user19','Sophia Lee',DATE '1994-06-06','F','010-5000-0019','a19@test.com','광주광역시 서구','Y',ADD_MONTHS(SYSDATE,-42));
INSERT INTO shez_customers VALUES ('C023','user20','정민재',DATE '1986-09-14','M','010-5000-0020','a20@test.com','울산광역시 남구','Y',ADD_MONTHS(SYSDATE,-44));

INSERT INTO shez_customers VALUES ('C024',NULL,'김도윤',DATE '2015-03-12','M','010-6000-0024','i24@test.com','서울특별시 강서구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C025',NULL,'이서연',DATE '2017-07-25','F','010-6000-0025','i25@test.com','서울특별시 송파구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C026',NULL,'박준혁',DATE '2013-11-08','M','010-6000-0026','i26@test.com','경기도 수원시','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C027',NULL,'최하은',DATE '2018-02-19','F','010-6000-0027','i27@test.com','경기도 용인시','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C028',NULL,'정민호',DATE '1980-06-03','M','010-6000-0028','i28@test.com','인천광역시 연수구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C029',NULL,'한지수',DATE '1982-09-14','F','010-6000-0029','i29@test.com','서울특별시 구로구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C030',NULL,'윤재현',DATE '2012-01-27','M','010-6000-0030','i30@test.com','서울특별시 성동구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C031',NULL,'서윤아',DATE '2016-05-09','F','010-6000-0031','i31@test.com','경기도 고양시','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C032',NULL,'강태우',DATE '1979-12-22','M','010-6000-0032','i32@test.com','경기도 파주시','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C033',NULL,'오수빈',DATE '1985-04-18','F','010-6000-0033','i33@test.com','서울특별시 중랑구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C034',NULL,'임건우',DATE '2014-08-30','M','010-6000-0034','i34@test.com','서울특별시 동작구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C035',NULL,'배소율',DATE '2019-10-11','F','010-6000-0035','i35@test.com','서울특별시 은평구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C036',NULL,'신현수',DATE '1976-02-05','M','010-6000-0036','i36@test.com','경기도 안양시','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C037',NULL,'문지현',DATE '1983-07-29','F','010-6000-0037','i37@test.com','부산광역시 해운대구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C038',NULL,'조은찬',DATE '2011-09-16','M','010-6000-0038','i38@test.com','부산광역시 수영구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C039',NULL,'백서린',DATE '2017-12-04','F','010-6000-0039','i39@test.com','대전광역시 서구','Y',SYSDATE);
INSERT INTO shez_customers VALUES ('C040',NULL,'노재원',DATE '1978-05-21','M','010-6000-0040','i40@test.com','광주광역시 북구','Y',SYSDATE);

COMMIT;
-- ============================================= 관리자 | 30건 =============================================
-- super
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'admin','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','super','황수연','보험청구팀');

-- manager (10)
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager1','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','김민수','계약관리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager2','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','이서연','고객지원팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager3','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','박준호','보험심사팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager4','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','최지은','보상처리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager5','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','윤태호','보험청구팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager6','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','강다은','계약관리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager7','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','배소영','보험심사팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager8','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','임서현','고객지원팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager9','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','홍지훈','보상처리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'manager10','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager','전수빈','계약관리팀');

-- staff (19)
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff1','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','정우성','계약관리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff2','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','한유진','고객지원팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff3','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','서지민','보험심사팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff4','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','오세훈','보상처리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff5','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','신현수','고객지원팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff6','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','문지현','보험청구팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff7','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','조민재','보상처리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff8','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','노지훈','계약관리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff9','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','백승우','보험청구팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff10','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','차은별','보험심사팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff11','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','유민석','계약관리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff12','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','장하늘','고객지원팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff13','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','송지안','보험심사팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff14','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','남도현','보상처리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff15','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','하윤성','고객지원팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff16','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','김태윤','보험청구팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff17','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','서은찬','보험심사팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff18','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','권지후','보상처리팀');
INSERT INTO shez_admins (admin_idx,admin_id, admin_pw, admin_role, admin_name, department)VALUES (seq_shezAdmins.NEXTVAL,'staff19','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff','류성민','보험청구팀');

-- super
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('admin','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','admin@shinhanez.com','황수연',DATE '1990-01-01','KT','M','01010000001','K','ROLE_ADMIN');

-- manager
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager1','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager1@shinhanez.com','김민수',DATE '1988-01-01','KT','M','01010000002','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager2','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager2@shinhanez.com','이서연',DATE '1991-01-01','SKT','F','01010000003','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager3','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager3@shinhanez.com','박준호',DATE '1987-01-01','KT','M','01010000004','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager4','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager4@shinhanez.com','최지은',DATE '1992-01-01','LGU','F','01010000005','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager5','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager5@shinhanez.com','윤태호',DATE '1985-01-01','KT','M','01010000006','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager6','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager6@shinhanez.com','강다은',DATE '1993-01-01','SKT','F','01010000007','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager7','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager7@shinhanez.com','배소영',DATE '1989-01-01','LGU','F','01010000008','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager8','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager8@shinhanez.com','임서현',DATE '1990-01-01','KT','F','01010000009','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager9','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager9@shinhanez.com','홍지훈',DATE '1986-01-01','KT','M','01010000010','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('manager10','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','manager10@shinhanez.com','전수빈',DATE '1991-01-01','SKT','F','01010000011','K','ROLE_ADMIN');

-- staff
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff1','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff1@shinhanez.com','정우성',DATE '1990-01-01','KT','M','01010000012','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff2','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff2@shinhanez.com','한유진',DATE '1994-01-01','SKT','F','01010000013','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff3','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff3@shinhanez.com','서지민',DATE '1992-01-01','LGU','F','01010000014','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff4','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff4@shinhanez.com','오세훈',DATE '1988-01-01','KT','M','01010000015','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff5','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff5@shinhanez.com','신현수',DATE '1991-01-01','SKT','M','01010000016','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff6','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff6@shinhanez.com','문지현',DATE '1993-01-01','KT','F','01010000017','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff7','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff7@shinhanez.com','조민재',DATE '1989-01-01','KT','M','01010000018','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff8','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff8@shinhanez.com','노지훈',DATE '1992-01-01','SKT','M','01010000019','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff9','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff9@shinhanez.com','백승우',DATE '1988-01-01','KT','M','01010000020','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff10','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff10@shinhanez.com','차은별',DATE '1994-01-01','LGU','F','01010000021','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff11','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff11@shinhanez.com','유민석',DATE '1990-01-01','KT','M','01010000022','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff12','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff12@shinhanez.com','장하늘',DATE '1995-01-01','SKT','F','01010000023','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff13','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff13@shinhanez.com','송지안',DATE '1993-01-01','LGU','F','01010000024','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff14','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff14@shinhanez.com','남도현',DATE '1987-01-01','KT','M','01010000025','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff15','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff15@shinhanez.com','하윤성',DATE '1991-01-01','SKT','M','01010000026','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff16','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff16@shinhanez.com','김태윤',DATE '1989-01-01','KT','M','01010000027','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff17','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff17@shinhanez.com','서은찬',DATE '1994-01-01','LGU','M','01010000028','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff18','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff18@shinhanez.com','권지후',DATE '1992-01-01','KT','M','01010000029','K','ROLE_ADMIN');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)VALUES ('staff19','$2a$10$GuX0ayR2AKzsOooSIbrGt.CZUGmHWDhowBK.MOBM6d5/udR9uQ6hO','staff19@shinhanez.com','류성민',DATE '1988-01-01','KT','M','01010000030','K','ROLE_ADMIN');

COMMIT;
-- ============================================= 상품 | 23건 =============================================
INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM, COVERAGERANGE, COVERAGEPERIOD, STATUS,CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezinsuraces.NEXTVAL,'표준 실손 의료보험','실손보험',35000,'입원비보장 3000만원, 통원치료비보장 500만원, 처방조제비보장 300만원',
    120,'INACTIVE', ADD_MONTHS(SYSDATE, -18),ADD_MONTHS(SYSDATE, -18),'황수연','황수연'
);

INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM,COVERAGERANGE, COVERAGEPERIOD, STATUS,CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezinsuraces.NEXTVAL,'종합 암 진단 보험', '암보험',52000,'암진단비보장 5000만원, 암수술비보장 2000만원, 항암치료비보장 3000만원',
    240,'INACTIVE',ADD_MONTHS(SYSDATE, -30),ADD_MONTHS(SYSDATE, -30),'김민수','김민수'
);

INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM,COVERAGERANGE, COVERAGEPERIOD, STATUS,CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezinsuraces.NEXTVAL,'운전자 상해 보장 보험','운전자보험',28000,'교통사고상해보장 1000만원, 후유장해보장 3000만원, 벌금보장 2000만원',
    180,'INACTIVE',ADD_MONTHS(SYSDATE, -48), ADD_MONTHS(SYSDATE, -48),'이서연','이서연'
);
INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM, COVERAGERANGE,
    COVERAGEPERIOD, STATUS, CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezinsuraces.NEXTVAL, '프리미엄 실손 의료보험', '실손보험', 42000,
    '입원비보장 5000만원, 통원치료비보장 1000만원, 처방조제비보장 500만원',
    120, 'ACTIVE', SYSDATE, SYSDATE, '황수연', '황수연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '스탠다드 암 진단 보험', '암보험', 48000,
    '암진단비보장 4000만원, 암수술비보장 1500만원, 항암치료비보장 2500만원',
    240, 'ACTIVE', SYSDATE, SYSDATE, '김민수', '김민수'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '프리미엄 암 집중 보험', '암보험', 65000,
    '암진단비보장 7000만원, 암수술비보장 3000만원, 표적항암보장 4000만원',
    240, 'ACTIVE', SYSDATE, SYSDATE, '이서연', '이서연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '운전자 종합 보장 보험', '운전자보험', 32000,
    '교통사고상해보장 2000만원, 벌금보장 3000만원, 변호사비보장 2000만원',
    180, 'ACTIVE', SYSDATE, SYSDATE, '황수연', '황수연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '어린이 종합 보장 보험', '어린이보험', 29000,
    '입원비보장 2000만원, 상해치료비보장 1000만원, 질병진단보장 1500만원',
    180, 'ACTIVE', SYSDATE, SYSDATE, '김민수', '김민수'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '노후 대비 실버 보험', '노후보험', 55000,
    '치매진단보장 3000만원, 요양비보장 2000만원, 간병비보장 1500만원',
    300, 'ACTIVE', SYSDATE, SYSDATE, '이서연', '이서연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '상해 종합 보장 보험', '상해보험', 26000,
    '상해입원보장 2000만원, 후유장해보장 3000만원, 수술비보장 1500만원',
    120, 'ACTIVE', SYSDATE, SYSDATE, '황수연', '황수연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '여성 맞춤 건강 보험', '건강보험', 37000,
    '여성질환보장 3000만원, 유방암보장 4000만원, 자궁질환보장 2000만원',
    180, 'ACTIVE', SYSDATE, SYSDATE, '김민수', '김민수'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '남성 건강 집중 보험', '건강보험', 36000,
    '심혈관질환보장 4000만원, 뇌혈관질환보장 4000만원, 간질환보장 2500만원',
    180, 'ACTIVE', SYSDATE, SYSDATE, '이서연', '이서연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '치아 종합 보장 보험', '치아보험', 19000,
    '충치치료보장 500만원, 임플란트보장 1000만원, 교정보장 800만원',
    120, 'ACTIVE', SYSDATE, SYSDATE, '황수연', '황수연'
);

/* 10건 추가 */

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '간병비 집중 보장 보험', '간병보험', 45000,
    '간병일당보장 2000만원, 입원간병보장 1500만원, 장기요양보장 3000만원',
    240, 'ACTIVE', SYSDATE, SYSDATE, '김민수', '김민수'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '화재 재산 보호 보험', '재산보험', 33000,
    '화재손해보장 5000만원, 폭발손해보장 3000만원, 붕괴손해보장 2000만원',
    120, 'ACTIVE', SYSDATE, SYSDATE, '이서연', '이서연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '여행자 안전 보험', '여행보험', 15000,
    '상해치료보장 2000만원, 질병치료보장 1500만원, 휴대품손해보장 500만원',
    12, 'ACTIVE', SYSDATE, SYSDATE, '황수연', '황수연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '반려동물 의료 보험', '펫보험', 22000,
    '진료비보장 1000만원, 수술비보장 1500만원, 입원비보장 800만원',
    60, 'ACTIVE', SYSDATE, SYSDATE, '김민수', '김민수'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '주택 종합 보장 보험', '주택보험', 39000,
    '주택손해보장 6000만원, 도난손해보장 2000만원, 배상책임보장 3000만원',
    240, 'ACTIVE', SYSDATE, SYSDATE, '이서연', '이서연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '배상 책임 종합 보험', '배상책임보험', 28000,
    '대인배상보장 5000만원, 대물배상보장 3000만원, 법률비용보장 1000만원',
    180, 'ACTIVE', SYSDATE, SYSDATE, '황수연', '황수연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '골절 집중 보장 보험', '상해보험', 21000,
    '골절진단보장 1500만원, 수술비보장 1000만원, 입원비보장 800만원',
    120, 'ACTIVE', SYSDATE, SYSDATE, '김민수', '김민수'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '뇌혈관 집중 보험', '건강보험', 47000,
    '뇌출혈보장 5000만원, 뇌경색보장 4000만원, 재활치료보장 2000만원',
    240, 'ACTIVE', SYSDATE, SYSDATE, '이서연', '이서연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '심혈관 안심 보험', '건강보험', 46000,
    '심근경색보장 5000만원, 협심증보장 3000만원, 수술비보장 2000만원',
    240, 'ACTIVE', SYSDATE, SYSDATE, '황수연', '황수연'
);

INSERT INTO SHEZ_INSURANCES VALUES (
    seq_shezinsuraces.NEXTVAL, '종합 생활 안전 보험', '생활보험', 30000,
    '일상상해보장 2000만원, 배상책임보장 1500만원, 법률비용보장 1000만원',
    180, 'ACTIVE', SYSDATE, SYSDATE, '김민수', '김민수'
);

COMMIT;
-- ============================================= 계약 | 50건 =============================================
-- ==================================== 대기 10건 | 활성 30건 | 만료, 해지 5건 =============================================
-- 대기 10건
INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C001', 'C001', 4,
    '주계약, 뇌출혈보장 4000만원, 뇌경색보장 3000만원',
    ADD_MONTHS(SYSDATE, -1), ADD_MONTHS(SYSDATE, 83),
    54000, '월납', '대기',
    1, '김하윤', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C002', 'C002', 5,
    '주계약, 심근경색보장 5000만원, 허혈성심장질환보장 3000만원',
    ADD_MONTHS(SYSDATE, -2), ADD_MONTHS(SYSDATE, 116),
    67000, '월납', '대기',
    1, '박지훈', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C003', 'C003', 6,
    '주계약, 골절진단보장 500만원, 통원치료비보장 300만원',
    ADD_MONTHS(SYSDATE, -3), ADD_MONTHS(SYSDATE, 35),
    28000, '월납', '대기',
    1, '이서연', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

/* ───── 피보험자가 다른 고객인 계약 ───── */

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C004', 'C024', 7,
    '주계약, 질병사망보장 8000만원, 입원비보장 2000만원',
    ADD_MONTHS(SYSDATE, -1), ADD_MONTHS(SYSDATE, 114),
    72000, '연납', '대기',
    1, '정민준', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C005', 'C025', 8,
    '주계약, 화상진단보장 2000만원, 입원일당 20만원',
    ADD_MONTHS(SYSDATE, -4), ADD_MONTHS(SYSDATE, 59),
    39000, '월납', '대기',
    SYSDATE, 1, '최윤서', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C006', 'C026', 9,
    '주계약, 운전자벌금보장 3000만원, 교통사고처리지원금 5000만원',
    ADD_MONTHS(SYSDATE, -2), ADD_MONTHS(SYSDATE, 23),
    46000, '월납', '대기',
    SYSDATE, 1, '한지민', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C007', 'C027', 10,
    '주계약, 어린이질병보장 3000만원, 입원비보장 1000만원',
    ADD_MONTHS(SYSDATE, -6), ADD_MONTHS(SYSDATE, 119),
    31000, '월납', '대기',
    SYSDATE, 1, '오세훈', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C008', 'C028', 4,
    '주계약, 뇌출혈보장 4000만원, 뇌경색보장 3000만원',
    ADD_MONTHS(SYSDATE, -1), ADD_MONTHS(SYSDATE, 83),
    54000, '월납', '대기',
    SYSDATE, 1, '신예은', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C009', 'C029', 5,
    '주계약, 심근경색보장 5000만원, 허혈성심장질환보장 3000만원',
    ADD_MONTHS(SYSDATE, -3), ADD_MONTHS(SYSDATE, 116),
    67000, '월납', '대기',
    SYSDATE, 1, '문채원', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C010', 'C030', 6,
    '주계약, 골절진단보장 500만원, 통원치료비보장 300만원',
    ADD_MONTHS(SYSDATE, -1), ADD_MONTHS(SYSDATE, 35),
    28000, '월납', '대기',
    SYSDATE, 1, '유나', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);
-- 활성 30건
INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C001', 'C001', 4,
    '주계약, 뇌출혈보장 4000만원, 뇌경색보장 3000만원',
    ADD_MONTHS(SYSDATE, -14), ADD_MONTHS(SYSDATE, 106),
    54000, '월납', '활성',
    1, '김하윤', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C002', 'C002', 5,
    '주계약, 심근경색보장 5000만원, 허혈성심장질환보장 3000만원',
    ADD_MONTHS(SYSDATE, -12), ADD_MONTHS(SYSDATE, 108),
    67000, '월납', '활성',
    SYSDATE, 1, '박지훈', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C003', 'C003', 6,
    '주계약, 골절진단보장 500만원, 통원치료비보장 300만원',
    ADD_MONTHS(SYSDATE, -10), ADD_MONTHS(SYSDATE, 50),
    28000, '월납', '활성',
    SYSDATE, 1, '이서연', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C004', 'C024', 7,
    '주계약, 질병사망보장 8000만원, 입원비보장 2000만원, 수술비보장 1500만원',
    ADD_MONTHS(SYSDATE, -18), ADD_MONTHS(SYSDATE, 102),
    72000, '연납', '활성',
    SYSDATE, 1, '정민준', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C005', 'C005', 8,
    '주계약, 암진단보장 6000만원, 항암치료보장 2000만원',
    ADD_MONTHS(SYSDATE, -9), ADD_MONTHS(SYSDATE, 111),
    83000, '월납', '활성',
    SYSDATE, 1, '최은서', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C006', 'C025', 9,
    '주계약, 상해사망보장 1억원, 후유장해보장 5000만원',
    ADD_MONTHS(SYSDATE, -7), ADD_MONTHS(SYSDATE, 113),
    61000, '연납', '활성',
    SYSDATE, 1, '한지민', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C007', 'C007', 10,
    '주계약, 입원일당보장 5만원, 중환자실보장 20만원',
    ADD_MONTHS(SYSDATE, -6), ADD_MONTHS(SYSDATE, 54),
    32000, '월납', '활성',
    SYSDATE, 1, '서준혁', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C008', 'C026', 11,
    '주계약, 치아보철보장 300만원, 치아충전보장 100만원',
    ADD_MONTHS(SYSDATE, -11), ADD_MONTHS(SYSDATE, 49),
    21000, '월납', '활성',
    SYSDATE, 1, '윤서아', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C009', 'C009', 12,
    '주계약, 운전자벌금보장 2000만원, 변호사선임비보장 500만원',
    ADD_MONTHS(SYSDATE, -15), ADD_MONTHS(SYSDATE, 45),
    18000, '연납', '활성',
    SYSDATE, 1, '장민호', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C010', 'C027', 13,
    '주계약, 실손입원비보장 3000만원, 통원치료비보장 500만원',
    ADD_MONTHS(SYSDATE, -8), ADD_MONTHS(SYSDATE, 112),
    35000, '월납', '활성',
    SYSDATE, 1, '임수정', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

/* product_id 14 ~ 23 */

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C011', 'C011', 14,
    '주계약, 치매진단보장 4000만원, 간병비보장 2000만원',
    ADD_MONTHS(SYSDATE, -20), ADD_MONTHS(SYSDATE, 100),
    76000, '월납', '활성',
    SYSDATE, 1, '오세훈', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C012', 'C028', 15,
    '주계약, 화재손해보장 2억원, 가재도구손해보장 5000만원',
    ADD_MONTHS(SYSDATE, -5), ADD_MONTHS(SYSDATE, 55),
    41000, '연납', '활성',
    SYSDATE, 1, '신민아', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C013', 'C013', 16,
    '주계약, 상해입원보장 2000만원, 골절수술보장 1000만원',
    ADD_MONTHS(SYSDATE, -13), ADD_MONTHS(SYSDATE, 47),
    29000, '월납', '활성',
    SYSDATE, 1, '김동현', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C014', 'C029', 17,
    '주계약, 여성암보장 7000만원, 유방암보장 4000만원',
    ADD_MONTHS(SYSDATE, -16), ADD_MONTHS(SYSDATE, 104),
    88000, '월납', '활성',
    SYSDATE, 1, '한예슬', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C015', 'C015', 18,
    '주계약, 어린이상해보장 5000만원, 입원비보장 1000만원',
    ADD_MONTHS(SYSDATE, -4), ADD_MONTHS(SYSDATE, 116),
    26000, '월납', '활성',
    SYSDATE, 1, '문채원', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C016', 'C030', 19,
    '주계약, 질병입원보장 3000만원, 수술비보장 2000만원',
    ADD_MONTHS(SYSDATE, -9), ADD_MONTHS(SYSDATE, 111),
    39000, '월납', '활성',
    SYSDATE, 1, '이종석', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C017', 'C017', 20,
    '주계약, 실손통원보장 500만원, 처방조제비보장 300만원',
    ADD_MONTHS(SYSDATE, -6), ADD_MONTHS(SYSDATE, 114),
    33000, '월납', '활성',
    SYSDATE, 1, '김지원', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C018', 'C031', 21,
    '주계약, 상해후유장해보장 1억원, 사망보장 5000만원',
    ADD_MONTHS(SYSDATE, -17), ADD_MONTHS(SYSDATE, 103),
    69000, '연납', '활성',
    SYSDATE, 1, '조승우', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C019', 'C019', 22,
    '주계약, 뇌혈관질환보장 6000만원, 재활치료보장 2000만원',
    ADD_MONTHS(SYSDATE, -11), ADD_MONTHS(SYSDATE, 109),
    74000, '월납', '활성',
    SYSDATE, 1, '김태리', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C020', 'C032', 23,
    '주계약, 노인간병보장 4000만원, 요양병원입원보장 3000만원',
    ADD_MONTHS(SYSDATE, -19), ADD_MONTHS(SYSDATE, 101),
    81000, '월납', '활성',
    SYSDATE, 1, '유해진', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);
INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C021', 'C021', 4,
    '주계약, 뇌출혈보장 4000만원, 뇌경색보장 3000만원, 재활치료보장 1000만원',
    ADD_MONTHS(SYSDATE, -8), ADD_MONTHS(SYSDATE, 112),
    56000, '월납', '활성',
    1, '김서현', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C022', 'C033', 5,
    '주계약, 심근경색보장 5000만원, 허혈성심장질환보장 3000만원',
    ADD_MONTHS(SYSDATE, -11), ADD_MONTHS(SYSDATE, 109),
    69000, '월납', '활성',
    SYSDATE, 1, '박민재', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C023', 'C023', 6,
    '주계약, 골절진단보장 700만원, 통원치료비보장 300만원',
    ADD_MONTHS(SYSDATE, -6), ADD_MONTHS(SYSDATE, 54),
    30000, '월납', '활성',
    SYSDATE, 1, '이도윤', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C024', 'C034', 7,
    '주계약, 질병사망보장 8000만원, 입원비보장 2000만원',
    ADD_MONTHS(SYSDATE, -15), ADD_MONTHS(SYSDATE, 105),
    74000, '연납', '활성',
    SYSDATE, 1, '정하늘', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C025', 'C025', 8,
    '주계약, 암진단보장 6000만원, 항암치료보장 2000만원, 입원비보장 1000만원',
    ADD_MONTHS(SYSDATE, -9), ADD_MONTHS(SYSDATE, 111),
    85000, '월납', '활성',
    SYSDATE, 1, '서지우', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C026', 'C035', 9,
    '주계약, 상해사망보장 1억원, 후유장해보장 5000만원',
    ADD_MONTHS(SYSDATE, -7), ADD_MONTHS(SYSDATE, 113),
    63000, '연납', '활성',
    SYSDATE, 1, '윤지호', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C027', 'C027', 10,
    '주계약, 입원일당보장 5만원, 중환자실보장 20만원',
    ADD_MONTHS(SYSDATE, -5), ADD_MONTHS(SYSDATE, 55),
    34000, '월납', '활성',
    SYSDATE, 1, '김나연', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C028', 'C036', 11,
    '주계약, 치아보철보장 300만원, 치아충전보장 100만원',
    ADD_MONTHS(SYSDATE, -10), ADD_MONTHS(SYSDATE, 50),
    22000, '월납', '활성',
    SYSDATE, 1, '홍지훈', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C029', 'C029', 12,
    '주계약, 운전자벌금보장 2000만원, 변호사선임비보장 500만원',
    ADD_MONTHS(SYSDATE, -14), ADD_MONTHS(SYSDATE, 46),
    19000, '연납', '활성',
    SYSDATE, 1, '백승우', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C030', 'C037', 13,
    '주계약, 실손입원비보장 3000만원, 통원치료비보장 500만원',
    ADD_MONTHS(SYSDATE, -8), ADD_MONTHS(SYSDATE, 112),
    36000, '월납', '활성',
    SYSDATE, 1, '노윤주', 'R0lGODlhAQABAIAAAAUEBA==', SYSDATE
);
-- 해지 5건
INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C031', 'C031', 14,
    '주계약, 암진단보장 4000만원, 항암치료보장 1500만원',
    ADD_MONTHS(SYSDATE, -36), ADD_MONTHS(SYSDATE, -6),
    58000, '월납', '해지',
    1, '김도현', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -6)
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C032', 'C038', 15,
    '주계약, 상해사망보장 8000만원, 후유장해보장 4000만원',
    ADD_MONTHS(SYSDATE, -48), ADD_MONTHS(SYSDATE, -12),
    62000, '연납', '해지',
    SYSDATE, 1, '이민재', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -12)
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C033', 'C033', 16,
    '주계약, 입원일당보장 5만원, 중환자실보장 15만원',
    ADD_MONTHS(SYSDATE, -24), ADD_MONTHS(SYSDATE, -3),
    33000, '월납', '해지',
    SYSDATE, 1, '박서연', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -3)
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C034', 'C039', 17,
    '주계약, 치아보철보장 250만원, 치아충전보장 120만원',
    ADD_MONTHS(SYSDATE, -30), ADD_MONTHS(SYSDATE, -9),
    21000, '월납', '해지',
    SYSDATE, 1, '정우성', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -9)
);

INSERT INTO shez_contracts VALUES (
    seq_shezContracts.NEXTVAL, 'C035', 'C035', 18,
    '주계약, 운전자벌금보장 2000만원, 교통사고처리지원금 4000만원',
    ADD_MONTHS(SYSDATE, -18), ADD_MONTHS(SYSDATE, -2),
    27000, '연납', '해지',
    SYSDATE, 1, '한유진', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -2)
);
-- 만료 5건
INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C036', 'C036', 19,
    '주계약, 암진단보장 3000만원, 항암치료보장 1000만원',
    ADD_MONTHS(SYSDATE, -72), ADD_MONTHS(SYSDATE, -12),
    48000, '월납', '만료',
    1, '김민재', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -12)
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C037', 'C039', 20,
    '주계약, 상해사망보장 7000만원, 후유장해보장 3000만원',
    ADD_MONTHS(SYSDATE, -84), ADD_MONTHS(SYSDATE, -6),
    52000, '연납', '만료',
    1, '이서준', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -6)
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C038', 'C038', 21,
    '주계약, 입원일당보장 4만원, 중환자실보장 12만원',
    ADD_MONTHS(SYSDATE, -60), ADD_MONTHS(SYSDATE, -1),
    29000, '월납', '만료',
    1, '박지훈', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -1)
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C039', 'C040', 22,
    '주계약, 치아보철보장 300만원, 치아충전보장 150만원',
    ADD_MONTHS(SYSDATE, -90), ADD_MONTHS(SYSDATE, -18),
    23000, '월납', '만료',
    1, '정수빈', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -18)
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id, contract_coverage,
    reg_date, expired_date, premium_amount, payment_cycle, contract_status,
    admin_idx, sign_name, sign_image, signed_date
) VALUES (
    seq_shezContracts.NEXTVAL, 'C040', 'C040', 23,
    '주계약, 운전자벌금보장 1500만원, 교통사고처리지원금 3000만원',
    ADD_MONTHS(SYSDATE, -66), ADD_MONTHS(SYSDATE, -3),
    26000, '연납', '만료',
    1, '한예린', 'R0lGODlhAQABAIAAAAUEBA==', ADD_MONTHS(SYSDATE, -3)
);
-- ============================================= 계약 | 30건 =============================================
--  PAID
INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 1, ADD_MONTHS(SYSDATE, -1) - 3, ADD_MONTHS(SYSDATE, -1),
    35000, '자동이체', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 3, ADD_MONTHS(SYSDATE, -2) - 5, ADD_MONTHS(SYSDATE, -2),
    42000, '카드', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 5, ADD_MONTHS(SYSDATE, -3) - 2, ADD_MONTHS(SYSDATE, -3),
    61000, '계좌이체', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 7, ADD_MONTHS(SYSDATE, -1) - 1, ADD_MONTHS(SYSDATE, -1),
    54000, '자동이체', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 9, ADD_MONTHS(SYSDATE, -4) - 6, ADD_MONTHS(SYSDATE, -4),
    67000, '카드', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 12, ADD_MONTHS(SYSDATE, -2) - 4, ADD_MONTHS(SYSDATE, -2),
    28000, '계좌이체', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 15, ADD_MONTHS(SYSDATE, -5) - 3, ADD_MONTHS(SYSDATE, -5),
    72000, '자동이체', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 18, ADD_MONTHS(SYSDATE, -1) - 7, ADD_MONTHS(SYSDATE, -1),
    39000, '카드', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 22, ADD_MONTHS(SYSDATE, -3) - 1, ADD_MONTHS(SYSDATE, -3),
    46000, '계좌이체', 'PAID', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 27, ADD_MONTHS(SYSDATE, -1) - 2, ADD_MONTHS(SYSDATE, -1),
    31000, '자동이체', 'PAID', SYSDATE
);
-- PENDING
INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 2, NULL, SYSDATE + 5,
    35000, '자동이체', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 4, NULL, SYSDATE + 7,
    42000, '카드', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 6, NULL, SYSDATE + 10,
    61000, '계좌이체', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 8, NULL, SYSDATE + 3,
    54000, '자동이체', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 10, NULL, SYSDATE + 14,
    67000, '카드', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 13, NULL, SYSDATE + 6,
    28000, '계좌이체', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 16, NULL, SYSDATE + 9,
    72000, '자동이체', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 19, NULL, SYSDATE + 4,
    39000, '카드', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 24, NULL, SYSDATE + 12,
    46000, '계좌이체', 'PENDING', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 29, NULL, SYSDATE + 8,
    31000, '자동이체', 'PENDING', SYSDATE
);
-- OVERDUE
INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 1, NULL, SYSDATE - 5,
    35000, '자동이체', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 3, NULL, SYSDATE - 10,
    42000, '카드', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 5, NULL, SYSDATE - 7,
    61000, '계좌이체', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 7, NULL, SYSDATE - 3,
    54000, '자동이체', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 9, NULL, SYSDATE - 14,
    67000, '카드', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 12, NULL, SYSDATE - 6,
    28000, '계좌이체', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 15, NULL, SYSDATE - 20,
    72000, '자동이체', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 18, NULL, SYSDATE - 9,
    39000, '카드', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 22, NULL, SYSDATE - 4,
    46000, '계좌이체', 'OVERDUE', SYSDATE
);

INSERT INTO shez_payments (
    payment_id, contract_id, payment_date, due_date, amount, method, status, reg_date
) VALUES (
    payment_seq.NEXTVAL, 28, NULL, SYSDATE - 12,
    31000, '자동이체', 'OVERDUE', SYSDATE
);
-- ============================================= 청구 | 30건 =============================================
-- ============================ PENDING 15건 | COMPELETED 10건 | REJECTED 5건 ==============================
-- PENDING 15건
INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C024', 'C031', 1,
    SYSDATE - 20, SYSDATE - 15, 30000,
    '진단서,영수증,약제비영수증,세부내역서', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C025', 'C025', 3,
    SYSDATE - 40, SYSDATE - 35, 42000,
    '진단서,입원확인서,퇴원확인서', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims VALUES (
    seq_claim_id.NEXTVAL, 'C026', 'C033', 5,
    SYSDATE - 18, SYSDATE - 14, 55000,
    '수술확인서,영수증,입원확인서,퇴원확인서', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C027', 'C027', 7,
    SYSDATE - 25, SYSDATE - 22, 48000,
    '진단서', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C028', 'C035', 9,
    SYSDATE - 12, SYSDATE - 10, 60000,
    '입퇴원확인서,영수증', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C029', 'C036', 12,
    SYSDATE - 60, SYSDATE - 55, 25000,
    '진단서,영수증,세부내역서', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C030', 'C030', 15,
    SYSDATE - 33, SYSDATE - 30, 70000,
    '진단서,수술확인서', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C031', 'C038', 18,
    SYSDATE - 14, SYSDATE - 12, 38000,
    '영수증', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C032', 'C032', 22,
    SYSDATE - 21, SYSDATE - 18, 46000,
    '진단서,통원확인서', NULL, NULL, 'PENDING', NULL, 1
);

INSERT INTO shez_claims (
    customer_id, insured_id, contract_id,
    accident_date, claim_date, claim_amount, document_list,
    paid_at, paid_amount, status, completed_at, admin_idx
) VALUES (
    'C033', 'C040', 27,
    SYSDATE - 9, SYSDATE - 7, 32000,
    '진단서', NULL, NULL, 'PENDING', NULL, 1
);
INSERT INTO shez_claims (
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C024','C031', 5, SYSDATE-30, SYSDATE-25, 30000, '진단서', NULL, NULL, 'PENDING', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C024','C031', 5, SYSDATE-20, SYSDATE-18, 20000, '영수증', NULL, NULL, 'PENDING', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES 
('C025','C025', 8, SYSDATE-40, SYSDATE-35, 45000, '진단서,입원확인서', NULL, NULL, 'PENDING', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C026','C033', 8, SYSDATE-15, SYSDATE-12, 18000, '통원확인서', NULL, NULL, 'PENDING', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C027','C027', 12, SYSDATE-22, SYSDATE-20, 52000, '진단서', NULL, NULL, 'PENDING', NULL, 1);
--COMPLETED 10건
INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C033','C040', 20, SYSDATE-50, SYSDATE-45, 60000, '진단서,영수증',SYSDATE-40, 55000, 'COMPLETED', SYSDATE-40, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C024','C031', 20, SYSDATE-32, SYSDATE-30, 30000, '통원확인서',SYSDATE-28, 30000, 'COMPLETED', SYSDATE-28, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C025','C025', 21, SYSDATE-70, SYSDATE-65, 45000, '입원확인서', SYSDATE-60, 42000, 'COMPLETED', SYSDATE-60, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C026','C033', 21, SYSDATE-24, SYSDATE-22, 26000, '진단서',SYSDATE-20, 25000, 'COMPLETED', SYSDATE-20, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C027','C027', 22, SYSDATE-90, SYSDATE-85, 80000, '수술확인서',SYSDATE-80, 75000, 'COMPLETED', SYSDATE-80, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C028','C035', 22, SYSDATE-18, SYSDATE-16, 22000, '영수증',SYSDATE-14, 20000, 'COMPLETED', SYSDATE-14, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C029','C036', 23, SYSDATE-44, SYSDATE-40, 38000, '진단서', SYSDATE-35, 35000, 'COMPLETED', SYSDATE-35, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C030','C030', 23, SYSDATE-27, SYSDATE-25, 29000, '통원확인서', SYSDATE-22, 29000, 'COMPLETED', SYSDATE-22, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C031','C038', 24, SYSDATE-55, SYSDATE-50, 41000, '진단서',SYSDATE-45, 40000, 'COMPLETED', SYSDATE-45, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C032','C032', 24, SYSDATE-16, SYSDATE-14, 21000, '영수증',SYSDATE-12, 20000, 'COMPLETED', SYSDATE-12, 1);
--REJECTED 5건
INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C028','C035', 12, SYSDATE-60, SYSDATE-55, 40000, '진단서', NULL, NULL, 'REJECTED', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C029','C036', 15, SYSDATE-25, SYSDATE-22, 35000, '처방전', NULL, NULL, 'REJECTED', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C030','C030', 15, SYSDATE-18, SYSDATE-15, 28000, '약제비영수증', NULL, NULL, 'REJECTED', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C031','C038', 18, SYSDATE-33, SYSDATE-30, 47000, '진단서', NULL, NULL, 'REJECTED', NULL, 1);

INSERT INTO shez_claims(
  customer_id, insured_id, contract_id,
  accident_date, claim_date, claim_amount, document_list,
  paid_at, paid_amount, status, completed_at, admin_idx
) VALUES
('C032','C032', 18, SYSDATE-14, SYSDATE-11, 19000, '처방전', NULL, NULL, 'REJECTED', NULL, 1);
COMMIT;
-- ============================================= 청구 파일 | 30건 =============================================
INSERT INTO shez_claim_files (
  claim_id,
  doc_type,
  original_name,
  storage_key,
  content_type,
  file_size,
  uploaded_by
)
SELECT
  c.claim_id,
  CASE c.status
    WHEN 'PENDING'   THEN 'RECEIPT'
    WHEN 'COMPLETED' THEN 'DIAGNOSIS'
    WHEN 'REJECTED'  THEN 'ETC'
  END AS doc_type,
  CASE c.status
    WHEN 'PENDING'   THEN 'receipt_'   || c.claim_id || '.pdf'
    WHEN 'COMPLETED' THEN 'diagnosis_' || c.claim_id || '.pdf'
    WHEN 'REJECTED'  THEN 'document_'  || c.claim_id || '.pdf'
  END AS original_name,
  '/claims/' || c.claim_id || '/' ||
  CASE c.status
    WHEN 'PENDING'   THEN 'receipt.pdf'
    WHEN 'COMPLETED' THEN 'diagnosis.pdf'
    WHEN 'REJECTED'  THEN 'document.pdf'
  END AS storage_key,
  'application/pdf' AS content_type,
  ROUND(DBMS_RANDOM.VALUE(50000, 500000)) AS file_size,
  c.customer_id AS uploaded_by
FROM (
  SELECT claim_id, status, customer_id
  FROM shez_claims
  ORDER BY claim_id DESC
) c
WHERE ROWNUM <= 30;

COMMIT;
-- ============================================= 최종 테이블 확인 ==============================================
SELECT * FROM shez_user ORDER BY id;
SELECT * FROM shez_board ORDER BY idx;
SELECT * FROM shez_customers ORDER BY customer_id;
SELECT * FROM shez_admins ORDER BY admin_idx;
SELECT * FROM SHEZ_INSURANCES ORDER BY productno;
SELECT * FROM shez_contracts ORDER BY contract_id;
SELECT * FROM shez_payments ORDER BY payment_id;
SELECT * FROM shez_claims ORDER BY claim_id;
SELECT * FROM shez_claim_files ORDER BY file_id;