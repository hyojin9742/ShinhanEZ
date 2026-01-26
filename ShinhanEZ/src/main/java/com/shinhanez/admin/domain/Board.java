package com.shinhanez.admin.domain;

import java.util.Date;

/**
 * 게시판 도메인 (미디어룸/공지사항)
 */
public class Board {
    private Long idx;           // 게시글 번호
    private String title;       // 제목
    private Date regDate;       // 등록일
    private String textarea;    // 내용
    private int cnt;            // 조회수
    private String id;          // 작성자 ID

    // Getters and Setters
    public Long getIdx() {
        return idx;
    }

    public void setIdx(Long idx) {
        this.idx = idx;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public String getTextarea() {
        return textarea;
    }

    public void setTextarea(String textarea) {
        this.textarea = textarea;
    }

    public int getCnt() {
        return cnt;
    }

    public void setCnt(int cnt) {
        this.cnt = cnt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
