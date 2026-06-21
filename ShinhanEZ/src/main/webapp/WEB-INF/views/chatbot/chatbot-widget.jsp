<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!-- 챗봇 플로팅 위젯 -->
<style>
/* 플로팅 버튼 */
.chatbot-float-btn {
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #0046ff 0%, #0035cc 100%);
    border-radius: 50%;
    box-shadow: 0 4px 20px rgba(0, 70, 255, 0.4);
    cursor: pointer;
    z-index: 9999;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    border: none;
}
.chatbot-float-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 25px rgba(0, 70, 255, 0.5);
}
.chatbot-float-btn .icon {
    font-size: 28px;
    color: #fff;
}
.chatbot-float-btn .close-icon {
    display: none;
}
.chatbot-float-btn.active .chat-icon {
    display: none;
}
.chatbot-float-btn.active .close-icon {
    display: block;
}

/* 알림 뱃지 */
.chatbot-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    width: 20px;
    height: 20px;
    background: #ff4757;
    border-radius: 50%;
    color: #fff;
    font-size: 11px;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: pulse 2s infinite;
}
@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

/* 챗봇 팝업 */
.chatbot-popup {
    position: fixed;
    bottom: 100px;
    right: 30px;
    width: 380px;
    height: 550px;
    background: #fff;
    border-radius: 20px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
    z-index: 9998;
    display: none;
    flex-direction: column;
    overflow: hidden;
    animation: slideUp 0.3s ease;
}
@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
.chatbot-popup.show {
    display: flex;
}

/* 팝업 헤더 */
.chatbot-popup-header {
    background: linear-gradient(135deg, #0046ff 0%, #0035cc 100%);
    color: #fff;
    padding: 15px 20px;
    display: flex;
    align-items: center;
    gap: 12px;
}
.chatbot-popup-header .avatar {
    width: 45px;
    height: 45px;
    background: #fff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
}
.chatbot-popup-header .info h3 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
    color:#fff;
}
.chatbot-popup-header .info p {
    margin: 2px 0 0;
    font-size: 11px;
    opacity: 0.8;
}
.chatbot-popup-header .status {
    width: 8px;
    height: 8px;
    background: #2ecc71;
    border-radius: 50%;
    margin-left: auto;
}

/* 팝업 메시지 영역 */
.chatbot-popup-messages {
    flex: 1;
    overflow-y: auto;
    padding: 15px;
    background: #f8f9fa;
}
.chatbot-msg {
    margin-bottom: 12px;
    display: flex;
    align-items: flex-start;
    animation: fadeIn 0.3s ease;
}
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
.chatbot-msg.user {
    flex-direction: row-reverse;
}
.chatbot-msg-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    flex-shrink: 0;
}
.chatbot-msg.bot .chatbot-msg-avatar {
    background: #0046ff;
    color: #fff;
    margin-right: 8px;
}
.chatbot-msg.user .chatbot-msg-avatar {
    background: #6c757d;
    color: #fff;
    margin-left: 8px;
}
.chatbot-msg-content {
    max-width: 70%;
    padding: 10px 14px;
    border-radius: 16px;
    font-size: 13px;
    line-height: 1.5;
    white-space: pre-line;
}
.chatbot-msg.bot .chatbot-msg-content {
    background: #fff;
    color: #333;
    border-bottom-left-radius: 4px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.08);
}
.chatbot-msg.user .chatbot-msg-content {
    background: #0046ff;
    color: #fff;
    border-bottom-right-radius: 4px;
}

/* 퀵 버튼 */
.chatbot-quick-btns {
    padding: 10px 15px;
    background: #fff;
    border-top: 1px solid #eee;
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
}
.chatbot-quick-btn {
    padding: 6px 12px;
    border: 1px solid #0046ff;
    border-radius: 15px;
    background: #fff;
    color: #0046ff;
    font-size: 11px;
    cursor: pointer;
    transition: all 0.2s;
    height:30px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.chatbot-quick-btn:hover {
    background: #0046ff;
    color: #fff;
}

/* 팝업 입력 영역 */
.chatbot-popup-input {
    display: flex;
    padding: 12px 15px;
    background: #fff;
    border-top: 1px solid #eee;
    gap: 10px;
}
.chatbot-popup-input input {
    flex: 1;
    border: 1px solid #ddd;
    border-radius: 20px;
    padding: 10px 16px;
    font-size: 13px;
    outline: none;
}
.chatbot-popup-input input:focus {
    border-color: #0046ff;
}
.chatbot-popup-input button {
    width: 40px;
    height: 40px;
    border: none;
    background: #0046ff;
    color: #fff;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
}
.chatbot-popup-input button:hover {
    background: #0035cc;
}

/* 타이핑 인디케이터 */
.chatbot-typing {
    display: none;
    padding: 8px 15px;
    font-size: 11px;
    color: #666;
}
.chatbot-typing span {
    display: inline-block;
    width: 6px;
    height: 6px;
    background: #0046ff;
    border-radius: 50%;
    margin-right: 3px;
    animation: bounce 1.4s infinite;
}
.chatbot-typing span:nth-child(2) { animation-delay: 0.2s; }
.chatbot-typing span:nth-child(3) { animation-delay: 0.4s; }
@keyframes bounce {
    0%, 60%, 100% { transform: translateY(0); }
    30% { transform: translateY(-5px); }
}

/* 상품 추천 카드 */
.chatbot-product-card {
    display: flex;
    align-items: center;
    gap: 6px;
    background: linear-gradient(135deg, #f0f4ff 0%, #e8eeff 100%);
    border: 1px solid #b3c4ff;
    border-radius: 10px;
    padding: 8px 12px;
    margin: 3px 0;
    text-decoration: none;
    color: #0046ff;
    font-size: 12px;
    font-weight: 500;
    transition: all 0.2s;
    cursor: pointer;
}
.chatbot-product-card:hover {
    background: linear-gradient(135deg, #0046ff 0%, #0035cc 100%);
    color: #fff;
    border-color: #0046ff;
    transform: translateY(-1px);
    box-shadow: 0 3px 10px rgba(0,70,255,0.25);
}
.chatbot-product-card .cp-icon { font-size: 14px; }
.chatbot-product-card .cp-link { margin-left: auto; font-size: 10px; opacity: 0.7; }

/* 회원가입 링크 카드 */
.chatbot-join-card {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
    border: 1px solid #ffb74d;
    border-radius: 10px;
    padding: 8px 14px;
    margin: 3px 0;
    text-decoration: none;
    color: #e65100;
    font-size: 12px;
    font-weight: 500;
    transition: all 0.2s;
}
.chatbot-join-card:hover {
    background: linear-gradient(135deg, #ff6f00 0%, #e65100 100%);
    color: #fff;
    border-color: #ff6f00;
}

/* 모바일 반응형 */
@media (max-width: 480px) {
    .chatbot-popup {
        width: calc(100% - 20px);
        right: 10px;
        bottom: 80px;
        height: 70vh;
    }
    .chatbot-float-btn {
        right: 15px;
        bottom: 15px;
    }
}
</style>

<!-- 플로팅 버튼 -->
<button class="chatbot-float-btn" id="chatbotFloatBtn" onclick="toggleChatbot()">
    <span class="icon chat-icon">💬</span>
    <span class="icon close-icon">✕</span>
    <span class="chatbot-badge" id="chatbotBadge">1</span>
</button>

<!-- 챗봇 팝업 -->
<div class="chatbot-popup" id="chatbotPopup">
    <!-- 헤더 -->
    <div class="chatbot-popup-header">
        <div class="avatar">🤖</div>
        <div class="info">
            <h3>신한EZ 상담봇</h3>
            <p>무엇이든 물어보세요!</p>
        </div>
        <div class="status" title="온라인"></div>
    </div>

    <!-- 메시지 영역 -->
    <div class="chatbot-popup-messages" id="chatbotMessages">
        <!-- 초기 메시지 -->
        <div class="chatbot-msg bot">
            <div class="chatbot-msg-avatar">🤖</div>
            <div class="chatbot-msg-content">
                안녕하세요! 신한EZ손해보험 상담 챗봇입니다. 😊

무엇을 도와드릴까요?
            </div>
        </div>
    </div>

    <!-- 타이핑 인디케이터 -->
    <div class="chatbot-typing" id="chatbotTyping">
        <span></span><span></span><span></span> 입력 중...
    </div>

    <!-- 퀵 버튼 -->
    <div class="chatbot-quick-btns">
        <button class="chatbot-quick-btn" onclick="sendChatbotMsg('보험금 청구')">보험금 청구</button>
        <button class="chatbot-quick-btn" onclick="sendChatbotMsg('보험료 납부')">보험료 납부</button>
        <button class="chatbot-quick-btn" onclick="sendChatbotMsg('상품 추천해줘')">🎯 상품 추천</button>
        <button class="chatbot-quick-btn" onclick="sendChatbotMsg('계약 조회')">계약 조회</button>
        <button class="chatbot-quick-btn" onclick="sendChatbotMsg('상담원 연결')">상담원</button>
        <a href="${ctx}/member/join" class="chatbot-quick-btn">회원가입</a>
    </div>

    <!-- 입력 영역 -->
    <div class="chatbot-popup-input">
        <input type="text" id="chatbotInput" placeholder="메시지를 입력하세요..." onkeypress="if(event.key==='Enter') sendChatbotMsg()">
        <button onclick="sendChatbotMsg()">
            <i class="bi bi-send-fill"></i>
        </button>
    </div>
</div>

<!-- SockJS & STOMP -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<script>
var chatbotClient = null;
var chatbotUser = '고객' + Math.floor(Math.random() * 1000);
var chatbotConnected = false;

// 챗봇 토글
function toggleChatbot() {
    var popup = document.getElementById('chatbotPopup');
    var btn = document.getElementById('chatbotFloatBtn');
    var badge = document.getElementById('chatbotBadge');

    if (popup.classList.contains('show')) {
        popup.classList.remove('show');
        btn.classList.remove('active');
    } else {
        popup.classList.add('show');
        btn.classList.add('active');
        badge.style.display = 'none';

        // 최초 열기 시 연결
        if (!chatbotConnected) {
            connectChatbot();
        }

        // 입력란 포커스
        setTimeout(function() {
            document.getElementById('chatbotInput').focus();
        }, 300);
    }
}

// WebSocket 연결
function connectChatbot() {
    var socket = new SockJS('${ctx}/ws/chat');
    chatbotClient = Stomp.over(socket);
    chatbotClient.debug = null;

    chatbotClient.connect({}, function() {
        chatbotConnected = true;

        // 메시지 구독
        chatbotClient.subscribe('/topic/public', function(payload) {
            var message = JSON.parse(payload.body);
            if (message.type === 'BOT' || message.sender === '신한봇') {
                addChatbotMsg(message.content, 'bot');
                document.getElementById('chatbotTyping').style.display = 'none';
            }
        });

        // 입장
        chatbotClient.send("/app/chat.join", {}, JSON.stringify({
            sender: chatbotUser,
            type: 'JOIN'
        }));
    }, function(error) {
        console.error('챗봇 연결 실패:', error);
    });
}

// 메시지 전송
function sendChatbotMsg(text) {
    var input = document.getElementById('chatbotInput');
    var content = text || input.value.trim();

    if (content && chatbotClient && chatbotConnected) {
        // 사용자 메시지 표시
        addChatbotMsg(content, 'user');

        // 서버로 전송
        chatbotClient.send("/app/chat.sendMessage", {}, JSON.stringify({
            sender: chatbotUser,
            content: content,
            type: 'CHAT'
        }));

        input.value = '';

        // 타이핑 표시
        setTimeout(function() {
            document.getElementById('chatbotTyping').style.display = 'block';
            scrollChatbot();
        }, 200);
    }
}

// 메시지 추가
function addChatbotMsg(content, type) {
    var container = document.getElementById('chatbotMessages');
    var avatar = type === 'bot' ? '🤖' : '👤';
    var rendered = (type === 'bot') ? renderChatbotContent(content) : escapeHtmlChat(content);

    var msgDiv = document.createElement('div');
    msgDiv.className = 'chatbot-msg ' + type;
    msgDiv.innerHTML =
        '<div class="chatbot-msg-avatar">' + avatar + '</div>' +
        '<div class="chatbot-msg-content">' + rendered + '</div>';

    container.appendChild(msgDiv);
    scrollChatbot();
}

// 봇 메시지 렌더링: __PRODUCT:id:이름__ 마커 → 상품 카드로 변환
function renderChatbotContent(content) {
    if (!content) return '';
    var ctx = '${ctx}';
    var parts = content.split(/(__PRODUCT:\d+:[^_]+__)/g);
    var result = '';
    for (var i = 0; i < parts.length; i++) {
        var part = parts[i];
        var match = part.match(/^__PRODUCT:(\d+):([^_]+)__$/);
        if (match) {
            var productNo = match[1];
            var productName = match[2];
            result +=
                '<a href="' + ctx + '/product/detail/' + productNo + '" class="chatbot-product-card">' +
                    '<span class="cp-icon">📋</span>' +
                    '<span>' + escapeHtmlSimpleChat(productName) + '</span>' +
                    '<span class="cp-link">보기 →</span>' +
                '</a>';
        } else {
            result += escapeHtmlChat(part);
        }
    }
    return result;
}

// 스크롤
function scrollChatbot() {
    var container = document.getElementById('chatbotMessages');
    container.scrollTop = container.scrollHeight;
}

// HTML 이스케이프 (줄바꿈 포함)
function escapeHtmlChat(text) {
    if (!text) return '';
    return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/\n/g, "<br>");
}

// 단순 이스케이프 (상품명용)
function escapeHtmlSimpleChat(text) {
    if (!text) return '';
    return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");
}

// 챗봇 외부 클릭 시 닫기
document.addEventListener('click', function(e) {
    var popup = document.getElementById('chatbotPopup');
    var btn   = document.getElementById('chatbotFloatBtn');
    if (!popup || !btn) return;
    if (!popup.classList.contains('show')) return;

    // 클릭 대상이 팝업 또는 플로팅 버튼 안이면 무시
    if (popup.contains(e.target) || btn.contains(e.target)) return;

    popup.classList.remove('show');
    btn.classList.remove('active');
});
</script>
