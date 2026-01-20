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
    
-- 관리자 더미데이터
INSERT INTO shez_admins (
    admin_idx, admin_id, admin_pw, admin_role, admin_name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'admin01', 'pw1234', 'super', '홍길동', '경영지원팀', SYSDATE
);

INSERT INTO shez_admins (
    admin_idx, admin_id, admin_pw, admin_role, admin_name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'manager01', 'pw5678', 'manager', '김철수', '영업팀', SYSDATE
);

INSERT INTO shez_admins (
    admin_idx, admin_id, admin_pw, admin_role, admin_name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'staff01', 'pw9012', 'staff', '이영희', '고객지원팀', SYSDATE
);

INSERT INTO shez_admins (
    admin_idx, admin_id, admin_pw, admin_role, admin_name, department, last_login
) VALUES (
    seq_shezAdmins.NEXTVAL, 'staff02', 'pw3456', 'staff', '박민수', '상품개발팀', SYSDATE
);

commit;

SELECT * FROM shez_admins;
-- ================================ CRUD ========================================
-- 전체 조회
SELECT *
FROM 
    ( SELECT 
        ROWNUM AS rn, 
        a.* 
    FROM 
        ( SELECT 
            ad.admin_idx, 
            ad.admin_id, 
            ad.admin_pw, 
            ad.admin_role, 
            ad.admin_name, 
            ad.department, 
            ad.last_login 
        FROM shez_admins ad 
        ORDER BY ad.admin_idx DESC ) a
    WHERE ROWNUM <= 10)
WHERE rn >= 1;
-- 전체 관리자 건수
SELECT COUNT(*) FROM shez_admins;
-- 상세조회
SELECT * FROM shez_admins WHERE admin_idx = 1;
-- 등록
INSERT INTO shez_admins(admin_idx,admin_id, admin_pw, admin_role, admin_name, department) 
VALUES (seq_shezAdmins.NEXTVAL,'admin','1111','super','황청구','보험청구팀');
INSERT INTO shez_user (id, pw, email, name, birth, telecom, gender, phone, nation, role)
VALUES ('manager02','1111','admin@shinhanez.com','김철수', TO_DATE('19900101','YYYYMMDD'), 'SKT', 'M', '01012345678', 'K', 'ROLE_ADMIN');

COMMIT;
SELECT * FROM shez_user;
SELECT * FROM shez_admins;
-- 수정
UPDATE shez_admins SET admin_id = 'manager02', admin_pw = '1111', admin_role = 'manager', 
admin_name = '김철수', department = '보험영업팀' WHERE admin_idx = 2;
COMMIT;
SELECT * FROM shez_admins;
-- 삭제
DELETE FROM shez_admins WHERE admin_idx = 4;
COMMIT;
SELECT * FROM shez_admins;

-- 아이디로 관리자 가져오기
SELECT * FROM shez_admins WHERE admin_id = 'admin';
-- 마지막 로그인 처리
UPDATE shez_admins SET last_login = SYSDATE WHERE admin_idx = 1;