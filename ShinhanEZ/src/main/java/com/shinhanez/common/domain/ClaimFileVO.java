package com.shinhanez.common.domain;

import java.sql.Date;

import lombok.Data;
@Data
public class ClaimFileVO {
    private Long fileId;         // FILE_ID (PK)
    private Long claimId;        // CLAIM_ID (FK)

    private String docType;      // DOC_TYPE (기본 ETC)
    private String originalName; // ORIGINAL_NAME
    private String storageKey;   // STORAGE_KEY

    private String contentType;  // CONTENT_TYPE
    private Long fileSize;       // FILE_SIZE

    private String uploadedBy;   // UPLOADED_BY (선택)
    private Date createdAt;      // CREATED_AT
    private String isDeleted;    // IS_DELETED ('N'/'Y')
	
}
