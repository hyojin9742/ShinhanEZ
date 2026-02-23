--계약
SELECT 
	C.contract_id,
    C.customer_id       ,
    CU.name             ,
    CU.birth_date       ,
    CU.GENDER           ,
    C.product_id        ,
    i.productName       ,
    i.category          ,
    c.reg_date          ,    
    c.expired_date      ,    
    c.update_date       , 
    C.premium_amount    ,
    C.payment_cycle     ,
    c.contract_status   as "status"
FROM 
    shez_contracts C
JOIN 
    SHEZ_INSURANCES i ON c.product_id= i.PRODUCTNO
JOIN    
    shez_customers CU ON CU.customer_id = C.customer_id
-- WHERE C.contract_status = '활성' -- (선택) 유지 중인 계약만 보고 싶을 때 주석 해제
ORDER BY 
    C.customer_id ASC;
    
-- 납입
SELECT 
    payment_id, 
    payment_date, 
    due_date, 
    amount, 
    status 
FROM shez_payments
ORDER BY payment_date DESC; -- 최신 납입일 기준으로 정렬

SELECT 
    payment_id, 
    payment_date, 
    due_date, 
    amount,
    -- 영문 상태값을 한글로 변환
    CASE status
        WHEN 'PAID'    THEN '완납'
        WHEN 'PENDING' THEN '대기중' -- 업무에 따라 '미납'으로 쓰셔도 좋습니다.
        WHEN 'OVERDUE' THEN '연체'
        ELSE status
    END AS status
FROM shez_payments;


-- 청구
SELECT 
    claim_id, 
    claim_date, 
    claim_amount, 
    paid_at, 
    paid_amount,
    -- 상태값을 한글로 변환하여 'status'라는 이름으로 출력
    CASE status
        WHEN 'PENDING'   THEN '대기중'
        WHEN 'COMPLETED' THEN '완료'
        WHEN 'REJECTED'  THEN '거절'
        ELSE status 
    END AS status
FROM shez_claims;
    
SELECT 
    claim_id, 
    claim_date, 
    claim_amount, 
    paid_at, 
    paid_amount,
    status
FROM shez_claims
ORDER BY claim_date DESC; -- 최신 청구일 기준으로 정렬    