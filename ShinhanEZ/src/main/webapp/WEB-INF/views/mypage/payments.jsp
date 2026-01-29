<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head id="inc-head">
    <%@ include file="/WEB-INF/views/inc/head.jsp" %>
    <style>
        .mypage-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 60px 20px;
        }
        .mypage-header {
            margin-bottom: 40px;
        }
        .mypage-header h2 {
            font-size: 32px;
            font-weight: 700;
            color: #1a2b4a;
            margin-bottom: 10px;
        }
        .mypage-header p {
            color: #666;
        }
        .summary-cards {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            flex: 1;
            background: #fff;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }
        .summary-card.pending {
            border-left: 4px solid #ffc107;
        }
        .summary-card.overdue {
            border-left: 4px solid #dc3545;
        }
		.summary-card.paid {
			border-left: 4px solid #0f5132; 
		}
        .summary-card .label {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
        }
        .summary-card .value {
            font-size: 28px;
            font-weight: 700;
        }
        .summary-card.pending .value { color: #ffc107; }
        .summary-card.overdue .value { color: #dc3545; }
		.summary-card.paid .value { color: #0f5132; }

        .payment-list {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .payment-list-header {
            background: #1a2b4a;
            color: #fff;
            padding: 20px 25px;
            font-size: 18px;
            font-weight: 600;
        }
        .payment-table {
            width: 100%;
            border-collapse: collapse;
        }
        .payment-table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: center;
            font-weight: 600;
            color: #1a2b4a;
            border-bottom: 2px solid #dee2e6;
        }
        .payment-table td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        .payment-table tbody tr:hover {
            background: #f8f9ff;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }
        .status-PAID { background: #d1e7dd; color: #0f5132; }
        .status-PENDING { background: #fff3cd; color: #664d03; }
        .status-OVERDUE { background: #f8d7da; color: #842029; }

        .btn-pay {
            display: inline-block;
            padding: 8px 20px;
            background: #0d6efd;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-pay:hover {
            background: #0b5ed7;
            color: #fff;
        }
        .btn-pay:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        .empty-message {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-message i {
            font-size: 48px;
            margin-bottom: 15px;
            display: block;
        }
        .amount {
            font-weight: 600;
            color: #0d6efd;
        }
		#claimHead{
			margin-top: 5vw;
		}
		/* 서류첨부 */
		.btn-doc {
		  display: inline-block;
		  padding: 6px 14px;
		  background: #1a2b4a;
		  color: #fff;
		  border-radius: 6px;
		  font-size: 13px;
		  text-decoration: none;
		  cursor: pointer;
		}
		.btn-doc:hover { opacity: .9; color:#fff; }
		.btn-doc.secondary { background:#6c757d; }
    </style>
</head>
<body class="sub">
<div id="wrap">
    <div id="page">
        <header id="header" class="header">
            <%@ include file="/WEB-INF/views/inc/header.jsp" %>
        </header>

        <main id="main">
            <div class="mypage-container">
                <div class="mypage-header">
                    <h2>납입내역</h2>
                    <p>보험료 납입 현황을 확인하고 결제할 수 있습니다.</p>
                </div>

                <!-- 요약 카드 -->
                <div class="summary-cards">
                    <div class="summary-card pending">
                        <div class="label">납입 대기</div>
                        <div class="value">${pendingCount}건</div>
                    </div>
                    <div class="summary-card overdue">
                        <div class="label">연체</div>
                        <div class="value">${overdueCount}건</div>
                    </div>
                </div>

                <!-- 납입 목록 -->
                <div class="payment-list">
                    <div class="payment-list-header">
                        <i class="bi bi-credit-card"></i> 납입내역 목록
                    </div>

                    <c:choose>
                        <c:when test="${not empty payments}">
                            <table class="payment-table">
                                <thead>
                                    <tr>
                                        <th>납입ID</th>
                                        <th>계약ID</th>
                                        <th>납입기한</th>
                                        <th>납입금액</th>
                                        <th>상태</th>
                                        <th>결제</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${payments}">
                                        <tr>
                                            <td>${p.paymentId}</td>
                                            <td>${p.contractId}</td>
                                            <td><fmt:formatDate value="${p.dueDate}" pattern="yyyy-MM-dd"/></td>
                                            <td class="amount"><fmt:formatNumber value="${p.amount}" type="number"/>원</td>
                                            <td>
                                                <span class="status-badge status-${p.status}">
                                                    <c:choose>
                                                        <c:when test="${p.status == 'PAID'}">완료</c:when>
                                                        <c:when test="${p.status == 'PENDING'}">대기</c:when>
                                                        <c:when test="${p.status == 'OVERDUE'}">연체</c:when>
                                                        <c:otherwise>${p.status}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <c:if test="${p.status != 'PAID'}">
                                                    <a href="${ctx}/payment/checkout?contractId=${p.contractId}&paymentId=${p.paymentId}&amount=${p.amount}&orderName=보험료납입(${p.contractId})"
                                                       class="btn-pay">
                                                        결제하기
                                                    </a>
                                                </c:if>
                                                <c:if test="${p.status == 'PAID'}">
                                                    <span style="color:#198754;"><i class="bi bi-check-circle"></i> 완료</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-message">
                                <i class="bi bi-inbox"></i>
                                <p>납입내역이 없습니다.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
				
				<%-- =========================================================
				  [마이페이지 - 청구 현황/목록]
				  - 데이터 로딩: /js/user_claims_list.js (AJAX로 /user/claims/api/list 호출)
				  - DOM 포인트:
				    * #claimPendingCount / #claimRejectedCount / #claimCompletedCount : 요약 카운트
				    * #claimsTable / #claimsTbody : 목록 렌더링
				    * #claimsEmpty : 빈 상태/401 안내
				========================================================= --%>
				<!-- 청구 현황 -->
                <div class="summary-cards" id="claimHead">
                    <div class="summary-card pending">
                        <div class="label">청구대기</div>
                        <div class="value" id="claimPendingCount">0건</div>
                    </div>
                    <div class="summary-card overdue">
                        <div class="label">반려</div>
                        <div class="value" id="claimRejectedCount">0건</div>
                    </div>
                    <div class="summary-card paid">
                        <div class="label">승인</div>
                        <div class="value" id="claimCompletedCount">0건</div>
                    </div>
                </div>
                <!-- 청구 목록 -->
                <div class="payment-list">
                    <div class="payment-list-header">
                        <i class="bi bi-credit-card"></i> 청구 목록
                    </div>
                    <table class="payment-table" id="claimsTable">
                        <thead>
                            <tr>
                                <th>청구ID</th>
                                <th>상태</th>
                                <th>보험가입자</th>
                                <th>피보험자</th>
                                <th>사고일</th>
                                <th>청구일</th>
                                <th>청구금액</th>
                                <th>담당자</th>
                                <th>서류</th>
                            </tr>
                        </thead>
						<tbody id="claimsTbody">
						    <!-- JS로 채움 -->
						</tbody>
					</table>
                    <div class="empty-message" id="claimsEmpty" style="display:none">
                        <i class="bi bi-inbox"></i>
                        <p>청구내역이 없습니다.</p>
                    </div>
                </div>
            </div>
        </main>

        <footer id="footer" class="footer">
            <%@ include file="/WEB-INF/views/inc/footer.jsp" %>
        </footer>
    </div>
</div>

<%-- =========================================================
  [파일 관리 모달]
  - 오픈 트리거: 목록의 "서류관리/서류확인" 버튼(.js-docs-btn)
  - 정책: 승인/반려(COMPLETED/REJECTED) 상태는 업로드 비활성화(읽기 전용)
  - 렌더링: #filesModalBody 를 JS가 채움
========================================================= --%>
<div id="filesModalBackdrop" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:9998;"></div>

<div id="filesModal" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%);
     width:720px; max-width:92vw; background:#fff; border-radius:14px; padding:18px; z-index:9999;">
    <div style="display:flex; justify-content:space-between; align-items:center; gap:12px;">
        <div>
            <h3 style="margin:0;">서류 첨부/확인</h3>
            <div id="filesModalSub" style="margin-top:6px; color:#666; font-size:13px;"></div>
        </div>
        <button type="button" class="btn-doc secondary" id="btnCloseFilesModal">닫기</button>
    </div>

    <hr style="margin:14px 0; border:none; border-top:1px solid #eee;" />

    <!-- 업로드 영역 -->
    <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
        <input type="file" id="filesModalInput" multiple />
        <button type="button" class="btn-doc" id="btnUploadFiles">업로드</button>
        <span id="filesUploadHint" style="color:#777; font-size:12px;"></span>
    </div>

    <div id="filesUploadStatus" style="margin-top:10px; font-size:13px;"></div>

    <hr style="margin:14px 0; border:none; border-top:1px solid #eee;" />

    <!-- 목록 영역 -->
    <div style="display:flex; justify-content:space-between; align-items:center; gap:10px;">
        <h4 style="margin:0;">첨부 파일 목록</h4>
        <button type="button" class="btn-doc secondary" id="btnRefreshFiles">새로고침</button>
    </div>

    <div id="filesModalBody" style="margin-top:10px;"></div>
</div>

<script src="${ctx}/js/user_claims_list.js"></script>
</body>
</html>
