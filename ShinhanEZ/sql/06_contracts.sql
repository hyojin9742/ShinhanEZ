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
        CHECK(contract_status IN('활성','만료','해지')),            -- 계약상태
    update_date         DATE            DEFAULT SYSDATE,        -- 수정일
    admin_idx            NUMBER(30)      NOT NULL,               -- 관리자 번호
    CONSTRAINT pk_shez_contractid PRIMARY KEY (contract_id),
    CONSTRAINT fk_shez_contract_customer FOREIGN KEY (customer_id) REFERENCES shez_customers(customer_id),
    CONSTRAINT fk_shez_contract_insured FOREIGN KEY (insured_id) REFERENCES shez_customers(customer_id),
    CONSTRAINT fk_shez_contract_product FOREIGN KEY (product_id) REFERENCES SHEZ_INSURANCES(PRODUCTNO),
    CONSTRAINT fk_shez_contract_admin FOREIGN KEY (admin_idx) REFERENCES shez_admins(admin_idx)
);

select * from shez_contracts;
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
-- 더미데이터
-- 계약 더미데이터 4건
INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_idx
) VALUES (
    SEQ_SHEZCONTRACTS.nextval, 'C001', 'C001', 1,
    '암 진단비 5천만원 보장', DATE '2024-01-01', DATE '2029-01-01',
    50000, '월납', '활성',
    SYSDATE, 1
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_idx
) VALUES (
    SEQ_SHEZCONTRACTS.nextval, 'C002', 'C002', 2,
    '교통사고 입원비 보장', DATE '2023-07-15', DATE '2028-06-15',
    30000, '분기납', '활성',
    SYSDATE, 2
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_idx
) VALUES (
    SEQ_SHEZCONTRACTS.nextval, 'C003', 'C003', 3,
    '실손 의료비 보장', DATE '2022-03-10', DATE '2027-03-10',
    45000, '연납', '만료',
    SYSDATE, 1
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_idx
) VALUES (
    SEQ_SHEZCONTRACTS.nextval, 'C004', 'C004', 4,
    '재해 사망 보장', DATE '2025-01-01', DATE '2030-01-01',
    100000, '일시납', '활성',
    SYSDATE, 3
);

commit;
SELECT * FROM shez_contracts;
-- ==================================================================================================
-- 계약 목록 조회
SELECT 
contract_id,
customer_id,
customer_name,
insured_id,
insured_name,
product_id,
product_name,
reg_date,
expired_date,
contract_status,
premium_amount,
payment_cycle,
update_date,
admin_idx,
admin_name,
admin_role
FROM (
    SELECT 
        c.contract_id,
        c.customer_id,
        cu.name AS customer_name,
        c.insured_id,
        ins.name AS insured_name,
        c.product_id,
        p.productname AS product_name,
        c.reg_date,
        c.expired_date,
        c.contract_status,
        c.premium_amount,
        c.payment_cycle,
        c.update_date,
        c.admin_idx,
        ad.admin_name AS admin_name,
        ad.admin_role AS admin_role,
        ROW_NUMBER() OVER (ORDER BY c.reg_date DESC, c.contract_id DESC) AS rn
    FROM 
        shez_contracts c
        INNER JOIN shez_customers cu ON c.customer_id = cu.customer_id
        INNER JOIN shez_customers ins ON c.insured_id = ins.customer_id
        INNER JOIN shez_insurances p ON c.product_id = p.productno
        INNER JOIN shez_admins ad ON c.admin_idx = ad.admin_idx
    WHERE contract_id = 12
    )
WHERE rn BETWEEN 0 + 1 AND 10;

-- 계약 건수 조회
SELECT COUNT(*) FROM 
    shez_contracts c
    INNER JOIN shez_customers cu ON c.customer_id = cu.customer_id
    INNER JOIN shez_insurances p ON c.product_id = p.productno;
    
SELECT cu.id id,cu.name cusName,insu.name insurName,productname productName,reg_date regDate,contract_status status from
    shez_contracts c
    INNER JOIN shez_user cu ON c.customer_id = cu.id
    INNER JOIN shez_user insu ON c.insured_id = insu.id
    INNER JOIN shez_insurances p ON c.product_id = p.productno;
    
select * from shez_user;    
commit;

-- 상품별 건수 조회 연도별   
SELECT PRODUCTNAME,COUNT(*) FROM 
    shez_contracts c 
    INNER JOIN shez_insurances p ON c.product_id = p.productno where TO_CHAR(reg_date, 'YYYY')='2023' group by p.PRODUCTNAME;


-- 연도별 건수 조회    
SELECT TO_CHAR(reg_date, 'YYYY-MM') as reg_date, count(*) FROM 
    shez_contracts where TO_CHAR(reg_date, 'YYYY')='2024' GROUP BY TO_CHAR(reg_date, 'YYYY-MM');
    
-- 연도 가져오기    
SELECT DISTINCT TO_CHAR(reg_date, 'YYYY') AS year
FROM shez_contracts
ORDER BY year;

-- 전체 회원 수
SELECT count(*) alluser FROM shez_user;
-- 전체 고객 수
SELECT count(*) allcustomer FROM shez_customers;
-- 전체 계약 수
SELECT count(*) allcontract FROM shez_contracts;

    
    
    
    
-- 계약 단건 조회
SELECT 
    *
FROM (
    SELECT 
        c.contract_id,
        c.customer_id,
        cu.name AS customer_name,
        c.insured_id,
        ins.name AS insured_name,
        c.product_id,
        p.productname AS product_name,
        c.contract_coverage,
        c.reg_date,
        c.expired_date,
        c.premium_amount,
        c.payment_cycle,
        c.contract_status,
        c.update_date,
        c.admin_idx,
        ad.admin_name AS admin_name
    FROM 
        shez_contracts c
        INNER JOIN shez_customers cu ON c.customer_id = cu.customer_id
        INNER JOIN shez_customers ins ON c.insured_id = ins.customer_id
        INNER JOIN shez_insurances p ON c.product_id = p.productno
        INNER JOIN shez_admins ad ON c.admin_idx = ad.admin_idx
)
WHERE contract_id = 7;


COMMIT;
SELECT * FROM shez_contracts;

-- 계약 수정
UPDATE shez_contracts SET 
    contract_coverage = '암, 심근경색 진단비 보장', expired_date = DATE '2040-01-01', premium_amount = 90000, 
    payment_cycle = '일시납', contract_status = '활성', admin_idx = 2
WHERE contract_id = 5;
COMMIT;
SELECT * FROM shez_contracts;

-- 계약 삭제 | 무결성 위반
-- DELETE FROM shez_contracts WHERE contract_id = 1;

-- 자동완성
-- 고객 검색
SELECT customerId, name
FROM (
    SELECT customer_id AS customerId,
           name
    FROM (
        SELECT customer_id, name
        FROM shez_customers
        WHERE status = 'Y'
          AND LOWER(name) LIKE '%' || LOWER('김') || '%'
        ORDER BY name
    )
)
WHERE ROWNUM <= 50;
-- 보험검색
SELECT productNo, productName, coverageRange
FROM (
    SELECT 
        productNo,productName, coverageRange
    FROM (
        SELECT 
            productno AS productNo,
            productname AS productName,
            coveragerange AS coverageRange
        FROM shez_insurances
        WHERE STATUS = 'ACTIVE' AND LOWER(productName) LIKE '%' || LOWER('보험') || '%'
        ORDER BY productName
    )
)
WHERE ROWNUM <= 50;
-- 상품 번호 보험 검색
SELECT 
    productno AS productNo,
    productname AS productName,
    coveragerange AS coverageRange
FROM shez_insurances
WHERE productno = 2;
-- 관리자 검색
SELECT adminIdx, adminName, adminRole
FROM (
    SELECT 
        adminIdx,adminName, adminRole
    FROM ( 
        SELECT 
            admin_idx AS adminIdx,
            admin_name AS adminName,
            admin_role AS adminRole
        FROM shez_admins
        WHERE LOWER(admin_name) LIKE '%' || LOWER('김') || '%'
        ORDER BY admin_name
    )
)
WHERE ROWNUM <= 50;
SELECT * FROM shez_customers ORDER BY customer_id;
SELECT * FROM shez_admins ORDER BY admin_idx;
SELECT * FROM shez_insurances ORDER BY productno;