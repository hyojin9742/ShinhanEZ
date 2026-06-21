package com.shinhanez.chatbot.controller;

import com.shinhanez.admin.domain.Insurance;
import com.shinhanez.admin.service.InsuranceService;
import com.shinhanez.chatbot.dto.ChatMessage;
import com.shinhanez.chatbot.service.ChatbotService;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.Arrays;
import java.util.List;

/**
 * 채팅 컨트롤러
 * - WebSocket STOMP 메시지 처리
 * - 챗봇 자동응답 + 상품 DB 연동 추천
 */
@Controller
public class ChatController {

    private final ChatbotService chatbotService;
    private final SimpMessagingTemplate messagingTemplate;
    private final InsuranceService insuranceService;

    // 상품 추천 관련 키워드
    private static final List<String> PRODUCT_KEYWORDS = Arrays.asList(
        "상품", "추천", "보험 추천", "어떤 보험", "뭐가 좋", "가입", "상품 안내",
        "보험 종류", "어떤 거", "어떤걸", "무슨 보험", "상품 알려", "보험 알려",
        "추천해줘", "추천해 줘", "추천 부탁", "어떤 상품", "뭐 있어", "뭐있어"
    );

    public ChatController(ChatbotService chatbotService,
                          SimpMessagingTemplate messagingTemplate,
                          InsuranceService insuranceService) {
        this.chatbotService = chatbotService;
        this.messagingTemplate = messagingTemplate;
        this.insuranceService = insuranceService;
    }

    /** 메시지가 상품 추천 관련인지 판단 */
    private boolean isProductQuery(String message) {
        String lower = message.toLowerCase();
        return PRODUCT_KEYWORDS.stream().anyMatch(lower::contains);
    }

    /**
     * 채팅 메시지 수신 및 봇 응답
     */
    @MessageMapping("/chat.sendMessage")
    @SendTo("/topic/public")
    public ChatMessage sendMessage(@Payload ChatMessage chatMessage) {
        System.out.println("[CHAT] " + chatMessage.getSender() + ": " + chatMessage.getContent());

        String content = chatMessage.getContent();

        // 상품 관련 질문이면 DB 상품 목록을 컨텍스트로 포함
        String botResponse;
        if (isProductQuery(content)) {
            List<Insurance> activeProducts = insuranceService.findByStatus("ACTIVE");
            botResponse = chatbotService.getResponseWithProducts(content, activeProducts);
        } else {
            botResponse = chatbotService.getResponse(content);
        }

        ChatMessage botMessage = new ChatMessage(
            ChatMessage.MessageType.BOT,
            botResponse,
            "신한봇"
        );

        new Thread(() -> {
            try {
                Thread.sleep(500);
                messagingTemplate.convertAndSend("/topic/public", botMessage);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }).start();

        return chatMessage;
    }

    /**
     * 사용자 입장 처리
     */
    @MessageMapping("/chat.join")
    @SendTo("/topic/public")
    public ChatMessage joinChat(@Payload ChatMessage chatMessage, SimpMessageHeaderAccessor headerAccessor) {
        // 세션에 사용자 이름 저장
        headerAccessor.getSessionAttributes().put("username", chatMessage.getSender());

        chatMessage.setType(ChatMessage.MessageType.JOIN);

        // 환영 메시지 전송
        new Thread(() -> {
            try {
                Thread.sleep(300);
                ChatMessage welcomeMessage = new ChatMessage(
                    ChatMessage.MessageType.BOT,
                    chatbotService.getWelcomeMessage(),
                    "신한봇"
                );
                messagingTemplate.convertAndSend("/topic/public", welcomeMessage);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }).start();

        return chatMessage;
    }

    /**
     * 챗봇 테스트 페이지
     */
    @GetMapping("/chatbot")
    public String chatbotPage() {
        return "chatbot/chat";
    }
}
