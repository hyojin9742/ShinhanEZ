-- 1) sequence
drop sequence seq_claim_file_id;
create sequence seq_claim_file_id
  start with 1
  increment by 1
  nocache
  nocycle;

-- 2) table
drop table shez_claim_files;
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

-- doc_type은 처음엔 ETC만 써도 되지만, 추후 고정값으로 제한하고 싶으면 체크제약 추가
-- alter table shez_claim_files add constraint ck_shez_claim_files_doc_type
-- check (doc_type in ('ID_CARD','ACCIDENT_REPORT','MEDICAL','ETC'));

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
