package com.shinhanez.admin.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.shinhanez.admin.domain.Board;
import com.shinhanez.admin.mapper.BoardMapper;

@Service
public class BoardService {

    @Autowired
    private BoardMapper boardMapper;

    public List<Board> findAll() {
        return boardMapper.findAll();
    }

    public Board findById(Long idx) {
        return boardMapper.findById(idx);
    }

    public Board findByIdWithCnt(Long idx) {
        boardMapper.incrementCnt(idx);
        return boardMapper.findById(idx);
    }

    public void insert(Board board) {
        boardMapper.insert(board);
    }

    public void update(Board board) {
        boardMapper.update(board);
    }

    public void delete(Long idx) {
        boardMapper.delete(idx);
    }

    public int count() {
        return boardMapper.count();
    }
}
