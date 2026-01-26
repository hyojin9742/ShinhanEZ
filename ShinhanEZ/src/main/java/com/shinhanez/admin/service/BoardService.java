package com.shinhanez.admin.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.shinhanez.admin.domain.Board;
import com.shinhanez.admin.mapper.BoardMapper;
import com.shinhanez.domain.Paging;

@Service
public class BoardService {

    @Autowired
    private BoardMapper boardMapper;

    // 목록 조회 (페이징, 검색)
    public Map<String, Object> getBoardList(int pageNum, String keyword) {

        int pageSize = 10;
        int blockSize = 10;

        // 검색 조건 파라미터
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);

        // 전체 개수 조회
        int totalDB = boardMapper.countBoard(params);

        // 페이징 계산
        Paging paging = new Paging(pageNum, pageSize, totalDB, blockSize);

        Map<String, Object> pagingMap = new HashMap<>();
        pagingMap.put("pageNum", paging.getPageNum());
        pagingMap.put("startPage", paging.getStartPage());
        pagingMap.put("endPage", paging.getEndPage());
        pagingMap.put("totalPages", paging.getTotalPages());
        pagingMap.put("hasPrev", paging.hasPrev());
        pagingMap.put("hasNext", paging.hasNext());

        int startRow = (pageNum - 1) * pageSize + 1;
        int endRow = pageNum * pageSize;

        params.put("startRow", startRow);
        params.put("endRow", endRow);

        // 목록 조회
        List<Board> list = boardMapper.selectBoardList(params);

        // 결과 리턴
        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("paging", pagingMap);

        return result;
    }

    // 상세 조회
    public Board getBoard(Long idx) {
        return boardMapper.selectBoard(idx);
    }

    // 상세 조회 + 조회수 증가
    public Board getBoardWithCnt(Long idx) {
        boardMapper.updateCnt(idx);
        return boardMapper.selectBoard(idx);
    }

    // 등록
    public void addBoard(Board board) {
        boardMapper.insertBoard(board);
    }

    // 수정
    public void editBoard(Board board) {
        boardMapper.updateBoard(board);
    }

    // 삭제
    public void deleteBoard(Long idx) {
        boardMapper.deleteBoard(idx);
    }

    // 키워드로 게시글 검색 (통합 검색용)
    public List<Board> searchByKeyword(String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("startRow", 1);
        params.put("endRow", 10);
        return boardMapper.selectBoardList(params);
    }
}
