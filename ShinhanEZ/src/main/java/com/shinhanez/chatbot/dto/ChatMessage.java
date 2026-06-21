package com.shinhanez.chatbot.dto;

import java.time.LocalDateTime;

/**
 * 채팅 메시지 DTO
 */
public class ChatMessage {

    public enum MessageType {
        CHAT,       // 일반 메시지
        JOIN,       // 입장
        LEAVE,      // 퇴장
        BOT         // 봇 응답
    }

    private MessageType type;
    private String content;
    private String sender;
    private String sessionId;
    private LocalDateTime timestamp;

    public ChatMessage() {
        this.timestamp = LocalDateTime.now();
    }

    public ChatMessage(MessageType type, String content, String sender) {
        this.type = type;
        this.content = content;
        this.sender = sender;
        this.timestamp = LocalDateTime.now();
    }

    // Getters and Setters
    public MessageType getType() { return type; }
    public void setType(MessageType type) { this.type = type; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}
