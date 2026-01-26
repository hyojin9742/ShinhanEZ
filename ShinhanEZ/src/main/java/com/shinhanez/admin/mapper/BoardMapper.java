package com.shinhanez.admin.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.shinhanez.admin.domain.Board;

@Mapper
public interface BoardMapper {
    List<Board> findAll();
    Board findById(Long idx);
    void insert(Board board);
    void update(Board board);
    void delete(Long idx);
    int count();
    void incrementCnt(Long idx);
}
