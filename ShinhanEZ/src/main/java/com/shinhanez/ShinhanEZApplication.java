package com.shinhanez;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan({"com.shinhanez.admin.mapper","com.shinhanez.mapper","com.shinhanez.common.mapper"})  // MyBatis Mapper 스캔
public class ShinhanEZApplication {

    public static void main(String[] args) {
        SpringApplication.run(ShinhanEZApplication.class, args);
        System.out.println("=================================");
        System.out.println("ShinhanEZ 서버 시작!");
        System.out.println("http://localhost:8090");
        System.out.println("=================================");
    }
}
