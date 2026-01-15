/*
    =============================================
    ShinhanEZ - 02. 게시판(shez_board) 테이블
    =============================================
    - 미디어룸 게시판
    - shez_user FK 연결
    =============================================
*/

-- 게시판 테이블 생성
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

-- 테이블 코멘트
COMMENT ON TABLE shez_board IS '미디어룸 게시판';
COMMENT ON COLUMN shez_board.idx IS '게시글 번호 (PK)';
COMMENT ON COLUMN shez_board.title IS '제목';
COMMENT ON COLUMN shez_board.reg_date IS '등록일';
COMMENT ON COLUMN shez_board.textarea IS '내용';
COMMENT ON COLUMN shez_board.cnt IS '조회수';
COMMENT ON COLUMN shez_board.id IS '작성자 ID (FK)';

-- 더미 데이터
INSERT INTO shez_board VALUES (1, '신한EZ손해보험 새로운 출발', SYSDATE, '신한EZ손해보험이 새롭게 출발합니다. 많은 관심 부탁드립니다.', 0, 'admin');
INSERT INTO shez_board VALUES (2, '해외여행보험 특가 이벤트 안내', SYSDATE, '해외여행보험 가입 시 특별 할인 혜택을 제공합니다.', 0, 'admin');
INSERT INTO shez_board VALUES (3, '고객센터 운영시간 안내', SYSDATE, '고객센터 운영시간은 평일 09:00~18:00 입니다.', 0, 'admin');

COMMIT;

-- 확인
SELECT * FROM shez_board ORDER BY idx DESC;
