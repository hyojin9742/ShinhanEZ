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

-- 상품 더미데이터 5건
INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM,
    COVERAGERANGE, COVERAGEPERIOD, STATUS,
    CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezInsuraces.NEXTVAL, '생명보험 기본형', '생명보험', 50000,
    '사망 시 1억원 지급', 120, 'ACTIVE',
    SYSDATE, SYSDATE, 'admin01', 'admin01'
);

INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM,
    COVERAGERANGE, COVERAGEPERIOD, STATUS,
    CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezInsuraces.NEXTVAL, '건강보험 표준형', '건강보험', 30000,
    '암, 뇌졸중, 심근경색 진단비 보장', 60, 'ACTIVE',
    SYSDATE, SYSDATE, 'admin02', 'admin02'
);

INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM,
    COVERAGERANGE, COVERAGEPERIOD, STATUS,
    CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezInsuraces.NEXTVAL, '자동차보험 종합형', '손해보험', 40000,
    '교통사고 손해 및 대인/대물 배상', 36, 'ACTIVE',
    SYSDATE, SYSDATE, 'admin03', 'admin03'
);

INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM,
    COVERAGERANGE, COVERAGEPERIOD, STATUS,
    CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezInsuraces.NEXTVAL, '재해보험 실속형', '손해보험', 20000,
    '재해 사망 및 후유장해 보장', 24, 'INACTIVE',
    SYSDATE, SYSDATE, 'admin01', 'admin01'
);

INSERT INTO SHEZ_INSURANCES (
    PRODUCTNO, PRODUCTNAME, CATEGORY, BASEPREMIUM,
    COVERAGERANGE, COVERAGEPERIOD, STATUS,
    CREATEDDATE, UPDATEDDATE, CREATEDUSER, UPDATEDUSER
) VALUES (
    seq_shezInsuraces.NEXTVAL, '실손 의료비 보험', '건강보험', 35000,
    '입원 및 외래 진료비 보장', 48, 'ACTIVE',
    SYSDATE, SYSDATE, 'admin02', 'admin02'
);

COMMIT;
SELECT * FROM shez_insurances;
    