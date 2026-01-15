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
foreign key (admin_id) references shez_admins(admin_id);

-- 5) indexes (관리자 목록 최신순 + 상태 필터 대비)
create index idx_shez_claims_date_id
on shez_claims (claim_date desc, claim_id desc);

create index idx_shez_claims_status_date_id
on shez_claims (status, claim_date desc, claim_id desc);
-- =========================================================
-- 6) dummy data (15 rows)
--   - claim_id는 트리거가 자동 생성
--   - completed만 paid_at/paid_amount/completed_at 세팅
-- =========================================================

insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C001', 'C001', 1, date '2025-01-01', date '2025-01-03',  500000, 'ID_CARD,ACCIDENT_REPORT', null, null,'PENDING', null, 1);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C002', 'C002', 2, date '2025-01-02', date '2025-01-04', 1200000, 'ID_CARD,MEDICAL_REPORT', null, null, 'PENDING', null, 2);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C003', 'C003', 3, date '2025-01-03', date '2025-01-05',  800000, 'ID_CARD', null, null, 'PENDING', null, 3);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C004', 'C004', 4, date '2025-01-04', date '2025-01-06',  300000, 'ID_CARD,ACCIDENT_REPORT', null, null, 'PENDING', null, 4);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C005', 'C005', 1, date '2025-01-05', date '2025-01-07', 1500000, 'ID_CARD,MEDICAL_REPORT', null, null, 'PENDING', null, 1);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C001', 'C002', 2, date '2025-01-06', date '2025-01-08',  200000, 'ID_CARD', null, null, 'PENDING', null, 2);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C002', 'C003', 3, date '2025-01-07', date '2025-01-09',  950000, 'ID_CARD,ACCIDENT_REPORT', null, null, 'PENDING', null, 3);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C003', 'C003', 4, date '2025-01-08', date '2025-01-10',  430000, 'ID_CARD', sysdate - 2, 430000, 'COMPLETED', sysdate - 2, 4);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list, paid_at, paid_amount, status, completed_at, admin_id) values ('C004', 'C004', 1, date '2025-01-09', date '2025-01-11',  670000, 'ID_CARD,MEDICAL_REPORT', sysdate - 3, 670000, 'COMPLETED', sysdate - 3, 1);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values ('C005', 'C005', 2, date '2025-01-10', date '2025-01-12', 1100000, 'ID_CARD,ACCIDENT_REPORT', sysdate - 4, 1100000, 'COMPLETED', sysdate - 4, 2);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values ('C001', 'C001', 3, date '2025-01-11', date '2025-01-13',  520000, 'ID_CARD', sysdate - 5, 520000, 'COMPLETED', sysdate - 5, 3);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values ('C002', 'C002', 4, date '2025-01-12', date '2025-01-14',  780000, 'ID_CARD,MEDICAL_REPORT', sysdate - 6, 780000, 'COMPLETED', sysdate - 6, 4);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values ('C003', 'C003', 1, date '2025-01-13', date '2025-01-15',  640000, 'ID_CARD', null, null, 'REJECTED', sysdate - 1,1);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values ('C004', 'C004', 2, date '2025-01-14', date '2025-01-16',  900000, 'ID_CARD,ACCIDENT_REPORT', null, null, 'REJECTED', sysdate - 2, 2);
insert into shez_claims (customer_id, insured_id, contract_id, accident_date, claim_date, claim_amount, document_list,  paid_at, paid_amount, status, completed_at, admin_id) values ('C005', 'C005', 3, date '2025-01-15', date '2025-01-17',  350000, 'ID_CARD', null, null, 'REJECTED', sysdate - 3, 3);
commit;
-- ================================================================================================
-- 최종 테이블 확인
SELECT * FROM shez_user ORDER BY id;
SELECT * FROM shez_board ORDER BY idx;
SELECT * FROM shez_customers ORDER BY customer_id;
SELECT * FROM shez_admins ORDER BY admin_id;
SELECT * FROM shez_insurances ORDER BY productno;
SELECT * FROM shez_contracts ORDER BY contract_id;
SELECT * FROM shez_payments ORDER BY payment_id;
SELECT * FROM shez_claims ORDER BY claim_id;
-- ================================================================================================
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