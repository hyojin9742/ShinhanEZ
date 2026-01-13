/*
    =============================================
    ShinhanEZ - 04. 납입내역(payment) 테이블
    담당: HSK (납입내역 파트)
    =============================================
    - 보험 납입내역 관리 테이블
    =============================================
*/

-- 기존 테이블 삭제 (필요시)
-- DROP TABLE payment CASCADE CONSTRAINTS;
-- DROP SEQUENCE payment_seq;

-- ============================================
-- 납입내역 테이블 생성
-- ============================================
CREATE TABLE payment (
    payment_id      NUMBER          PRIMARY KEY,            -- 납입 ID (PK)
    contract_id     NUMBER          NOT NULL,               -- 계약 ID
    payment_date    DATE,                                   -- 실제 납입일 (NULL 허용: 미납시)
    due_date        DATE            NOT NULL,               -- 납입 기한
    amount          NUMBER(12,2)    NOT NULL,               -- 납입 금액
    method          VARCHAR2(20),                           -- 납입 방법 (자동이체/카드/계좌이체)
    status          VARCHAR2(20)    DEFAULT 'PENDING',      -- 납입 상태 (PAID/PENDING/OVERDUE)
    reg_date        DATE            DEFAULT SYSDATE         -- 등록일
);

-- 시퀀스 생성
CREATE SEQUENCE payment_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 인덱스 생성
CREATE INDEX idx_payment_contract ON payment(contract_id);
CREATE INDEX idx_payment_status ON payment(status);
CREATE INDEX idx_payment_due_date ON payment(due_date);

-- 컬럼 코멘트
COMMENT ON TABLE payment IS '납입내역 테이블';
COMMENT ON COLUMN payment.payment_id IS '납입 ID (PK)';
COMMENT ON COLUMN payment.contract_id IS '계약 ID';
COMMENT ON COLUMN payment.payment_date IS '실제 납입일 (미납시 NULL)';
COMMENT ON COLUMN payment.due_date IS '납입 기한';
COMMENT ON COLUMN payment.amount IS '납입 금액';
COMMENT ON COLUMN payment.method IS '납입 방법 (자동이체/카드/계좌이체)';
COMMENT ON COLUMN payment.status IS '납입 상태 (PAID:완료, PENDING:대기, OVERDUE:연체)';
COMMENT ON COLUMN payment.reg_date IS '등록일';

-- ============================================
-- 더미 데이터
-- ============================================
-- 완료 상태 (PAID)
INSERT INTO payment (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 1, TO_DATE('2025-01-05', 'YYYY-MM-DD'), TO_DATE('2025-01-10', 'YYYY-MM-DD'), 50000, '자동이체', 'PAID');

INSERT INTO payment (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 1, TO_DATE('2025-02-05', 'YYYY-MM-DD'), TO_DATE('2025-02-10', 'YYYY-MM-DD'), 50000, '자동이체', 'PAID');

INSERT INTO payment (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 2, TO_DATE('2025-01-03', 'YYYY-MM-DD'), TO_DATE('2025-01-05', 'YYYY-MM-DD'), 120000, '카드', 'PAID');

-- 대기 상태 (PENDING)
INSERT INTO payment (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 2, NULL, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 75000, '카드', 'PENDING');

INSERT INTO payment (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 3, NULL, TO_DATE('2025-01-20', 'YYYY-MM-DD'), 85000, '계좌이체', 'PENDING');

-- 연체 상태 (OVERDUE)
INSERT INTO payment (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 3, NULL, TO_DATE('2024-12-31', 'YYYY-MM-DD'), 100000, '계좌이체', 'OVERDUE');

INSERT INTO payment (payment_id, contract_id, payment_date, due_date, amount, method, status)
VALUES (payment_seq.NEXTVAL, 4, NULL, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 95000, '카드', 'OVERDUE');

COMMIT;

-- ============================================
-- 확인 쿼리
-- ============================================
SELECT * FROM payment ORDER BY payment_id;

SELECT status, COUNT(*) as cnt FROM payment GROUP BY status;
