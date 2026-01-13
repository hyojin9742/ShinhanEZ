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
    admin_id            NUMBER(30)      NOT NULL,               -- 관리자 번호
    CONSTRAINT pk_shez_contractid PRIMARY KEY (contract_id),
    CONSTRAINT fk_shez_contract_customer FOREIGN KEY (customer_id) REFERENCES shez_customers(customer_id),
    CONSTRAINT fk_shez_contract_insured FOREIGN KEY (insured_id) REFERENCES shez_customers(customer_id),
    CONSTRAINT fk_shez_contract_product FOREIGN KEY (product_id) REFERENCES SHEZ_INSURANCES(PRODUCT_NO),
    CONSTRAINT fk_shez_contract_admin FOREIGN KEY (admin_id) REFERENCES shez_admins(admin_id)
);
-- 시퀀스
CREATE SEQUENCE seq_shezContracts
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
-- 더미데이터
-- 계약 더미데이터 4건
INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_id
) VALUES (
    1, 'C001', 'C001', 1,
    '암 진단비 5천만원 보장', DATE '2024-01-01', DATE '2029-01-01',
    50000, '월납', '활성',
    SYSDATE, 1
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_id
) VALUES (
    2, 'C002', 'C002', 2,
    '교통사고 입원비 보장', DATE '2023-06-15', DATE '2028-06-15',
    30000, '분기납', '활성',
    SYSDATE, 2
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_id
) VALUES (
    3, 'C003', 'C003', 3,
    '실손 의료비 보장', DATE '2022-03-10', DATE '2027-03-10',
    45000, '연납', '만료',
    SYSDATE, 1
);

INSERT INTO shez_contracts (
    contract_id, customer_id, insured_id, product_id,
    contract_coverage, reg_date, expired_date,
    premium_amount, payment_cycle, contract_status,
    update_date, admin_id
) VALUES (
    4, 'C004', 'C004', 4,
    '재해 사망 보장', DATE '2025-01-01', DATE '2030-01-01',
    100000, '일시납', '활성',
    SYSDATE, 3
);

commit;
SELECT * FROM shez_contracts;