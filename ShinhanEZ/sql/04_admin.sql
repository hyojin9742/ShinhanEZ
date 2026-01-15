-- ============================================= 관리자 | admins ============================================= 
DROP TABLE shez_admins CASCADE CONSTRAINTS;
CREATE TABLE shez_admins(
    admin_id    NUMBER(30)      ,
    id          VARCHAR2(50)    NOT NULL,
    pw          VARCHAR2(255)   NOT NULL,
    role        VARCHAR2(30)    DEFAULT 'staff' CHECK(role IN('super','manager','staff')),
    name        VARCHAR2(60)    NOT NULL,
    department  VARCHAR2(30)    NOT NULL,
    last_login  DATE            DEFAULT SYSDATE,
    CONSTRAINT pk_shez_adminid PRIMARY KEY (admin_id)
);

-- 시퀀스
DROP SEQUENCE seq_shezAdmins;
CREATE SEQUENCE seq_shezAdmins
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
-- 관리자 더미데이터
INSERT INTO shez_admins (
    admin_id, id, pw, role, name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'admin01', 'pw1234', 'super', '홍길동', '경영지원팀', SYSDATE
);

INSERT INTO shez_admins (
    admin_id, id, pw, role, name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'manager01', 'pw5678', 'manager', '김철수', '영업팀', SYSDATE
);

INSERT INTO shez_admins (
    admin_id, id, pw, role, name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'staff01', 'pw9012', 'staff', '이영희', '고객지원팀', SYSDATE
);

INSERT INTO shez_admins (
    admin_id, id, pw, role, name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'staff02', 'pw3456', 'staff', '박민수', '상품개발팀', SYSDATE
);

commit;

SELECT * FROM shez_admins;