package com.shinhanez.admin.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.sql.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Board {

    private Long idx;           // 게시글 번호
    private String title;       // 제목
    private Date regDate;       // 등록일
    private String textarea;    // 내용
    private Integer cnt;        // 조회수
    private String id;          // 작성자 ID

    // JSP에서 ${list.reg_date}로 접근 가능하게 (팀 호환성)
    public Date getReg_date() {
        return regDate;
    }
}
