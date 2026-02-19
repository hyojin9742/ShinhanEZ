package com.shinhanez.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.shinhanez.admin.domain.Board;

@Mapper
public interface BoardMapper {

    // 목록 조회
    List<Board> selectBoardList(Map<String, Object> params);
    // 목록 조회 + 상태
    List<Board> selectBoardListwithStatus(Map<String, Object> params);

    // 전체 개수
    int countBoard(Map<String, Object> params);
    // 전체 개수+상태
    int countBoardwithStatus(Map<String, Object> params);

    // 상세 조회
    Board selectBoard(Long idx);

    // 조회수 증가
    void updateCnt(Long idx);

    // 등록
    int insertBoard(Board board);

    // 수정
    int updateBoard(Board board);

    // 삭제
    int deleteBoard(Long idx);

    // 다음 시퀀스 값 조회
    Long getNextIdx();
}
