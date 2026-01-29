<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="inc/head.jsp"/>
    <style>
        /* 대시보드 전용 스타일 */
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .summary-card {
            background: var(--white);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .summary-card .icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        .summary-card .icon.blue { background: #e7f1ff; color: #0d6efd; }
        .summary-card .icon.green { background: #d1e7dd; color: #198754; }
        .summary-card .icon.orange { background: #fff3cd; color: #fd7e14; }
        .summary-card .icon.purple { background: #e2d9f3; color: #6f42c1; }
        .summary-card .info h3 { margin: 0; font-size: 28px; font-weight: 700; }
        .summary-card .info p { margin: 5px 0 0; color: var(--text-muted); font-size: 14px; }
        
        .dashboard-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        .chart-container {
            background: var(--white);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .chart-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border-color);
        }
        
        /* 페이징 컨테이너 */
		.paging {
		    display: flex;
		    justify-content: center; /* 가운데 정렬 */
		    align-items: center;
		    gap: 8px; /* 버튼 사이 간격 */
		    margin-top: 30px; /* 위쪽 여백 */
		    margin-bottom: 30px;
		}
		
		
		.paging button {
		    min-width: 32px; /* 최소 너비 */
		    height: 32px;
		    padding: 0 8px;
		    border: 1px solid #dfe3e8; /* 연한 회색 테두리 */
		    background-color: #ffffff;
		    color: #212529;
		    font-size: 14px;
		    font-weight: 500;
		    border-radius: 4px; /* 살짝 둥근 모서리 */
		    cursor: pointer;
		    transition: all 0.2s ease; /* 부드러운 애니메이션 */
		}
		
		/* 마우스 올렸을 때 (Hover) */
		.paging button:hover:not(:disabled) {
		    background-color: #f1f3f5;
		    border-color: #c5c9cd;
		    color: #0056b3;
		    transform: translateY(-1px); /* 살짝 떠오르는 효과 */
		}
		
		/* 현재 선택된 페이지 (Active) */
		.paging button.active {
		    background-color: #007bff; /* 메인 파란색 */
		    border-color: #007bff;
		    color: white;
		    font-weight: bold;
		    cursor: default;
		    box-shadow: 0 2px 4px rgba(0, 123, 255, 0.3); /* 그림자 효과 */
		}
		
		/* 비활성화된 버튼 (이전/다음 없을 때 등) - 필요시 */
		.paging button:disabled:not(.active) {
		    background-color: #f8f9fa;
		    color: #adb5bd;
		    cursor: not-allowed;
		    border-color: #ebedf0;
		}
		
		.select-container {
			 display: inline-block;
			 position: relative;
			 width: 200px;
		}
		
		#yearSelect {
		  /* 1. 기본 브라우저 스타일 제거 (가장 중요) */
		  -webkit-appearance: none;
		  -moz-appearance: none;
		  appearance: none;
		
		  /* 2. 크기 및 폰트 설정 */
		  width: 100%;
		  padding: 12px 15px;
		  font-size: 16px;
		  font-family: 'Noto Sans KR', sans-serif; /* 폰트는 프로젝트에 맞춰 변경 */
		  color: #333;
		  background-color: #fff;
		
		  /* 3. 테두리 및 둥근 모서리 */
		  border: 1px solid #ddd;
		  border-radius: 8px;
		  cursor: pointer;
		  transition: all 0.3s ease;
		
		  /* 4. 커스텀 화살표 아이콘 (SVG 사용) */
		  /* 우측 끝에 화살표 배치 */
		  background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23333%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E");
		  background-repeat: no-repeat;
		  background-position: right 15px center;
		  background-size: 12px;
		}
		
		
		
        
        
    </style>
</head>
<body class="admin-page">
<div class="admin-wrapper">
    
    <!-- 사이드바 -->
    <jsp:include page="inc/sidebar.jsp">
        <jsp:param name="menu" value="dashboard"/>
    </jsp:include>
    
    <!-- 메인 영역 -->
    <div class="admin-main">
        
        <!-- 헤더 -->
        <jsp:include page="inc/header.jsp">
            <jsp:param name="page" value="대시보드"/>
        </jsp:include>
        
        <!-- 콘텐츠 -->
        <main class="admin-content">

            <!-- 요약 카드 -->
            <div class="summary-cards">
                <div class="summary-card">
                    <div class="icon blue"><i class="bi bi-people"></i></div>
                    <div class="info allusercount">
                        <h3>7</h3>
                        <p>전체 회원 수</p>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="icon green"><i class="bi bi-person-badge"></i></div>
                    <div class="info allcustomercount">
                        <h3>0</h3>
                        <p>전체 고객 수</p>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="icon orange"><i class="bi bi-file-earmark-text"></i></div>
                    <div class="info allcontractcount">
                        <h3>0</h3>
                        <p>전체 계약 수</p>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="icon purple"><i class="bi bi-megaphone"></i></div>
                    <div class="info allboardcount">
                        <h3>0</h3>
                        <p>전체 공지사항 수</p>
                    </div>
                </div>
            </div>
            
            <!-- 차트 영역 -->
            <div class="dashboard-row">
                <div class="chart-container">
                    <div class="chart-title">📊 월별 계약 수</div>
                    <div class="select-container">
					  <select id="yearSelect">
					  </select>
					</div>
                    <canvas id="barChart" height="200"></canvas>
                    
                </div>
                <div class="chart-container">
                    <div class="chart-title">🥧 상품별 계약 분포</div>
                    <canvas id="pieChart" height="200"></canvas>
                </div>
            </div>
            
            <!-- 최근 목록 -->
            <div class="dashboard-row">
                <div class="card">
                    <div class="card-header">
                        <span>📋 최근 등록 계약</span>
                        <a href="${ctx}/admin/contract/list" class="btn btn-sm btn-primary">계약 리스트 →</a>
                    </div>
                    <div class="card-body" style="padding:0;">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>고객ID</th>
                                    <th>고객명</th>
                                    <th>피보험자명</th>
                                    <th>상품명</th>
                                    <th>계약일</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody id="allConstracts">
                                <tr onclick="location.href='<%=ctx%>/admin/contract/view/1'" style="cursor:pointer;">
                                    <td>hoonlee222</td>
                                    <td>훈이</td>
                                    <td>훈이짱</td>
                                    <td>실손보험</td>
                                    <td>2025-07-15</td>
                                    <td><span class="badge badge-primary">유지</span></td>
                                </tr>
                                <tr onclick="location.href='<%=ctx%>/admin/contract/view/2'" style="cursor:pointer;">
                                    <td>kidubu</td>
                                    <td>지혜</td>
                                    <td>지혜짱</td>
                                    <td>암보험</td>
                                    <td>2025-02-01</td>
                                    <td><span class="badge badge-primary">유지</span></td>
                                </tr>
                                <tr onclick="location.href='<%=ctx%>/admin/contract/view/3'" style="cursor:pointer;">
                                    <td>seoyoon0327</td>
                                    <td>서윤</td>
                                    <td>서윤짱</td>
                                    <td>암보험</td>
                                    <td>2025-04-01</td>
                                    <td><span class="badge badge-success">완료</span></td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="paging" id="constractspagination"></div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <span>📢 최근 공지사항</span>
                        <a href="<%=ctx%>/admin/notice/write" class="btn btn-sm btn-primary">+ 공지사항 등록</a>
                    </div>
                    <div class="card-body" style="padding:0;">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody id="allBoards">
                                <tr onclick="location.href='<%=ctx%>/admin/notice/view?idx=3'" style="cursor:pointer;">
                                    <td>3</td>
                                    <td><span class="badge badge-danger">중요</span> 제목</td>
                                    <td>관리자</td>
                                    <td>2025-07-17</td>
                                </tr>
                                <tr onclick="location.href='<%=ctx%>/admin/notice/view?idx=2'" style="cursor:pointer;">
                                    <td>2</td>
                                    <td>공지사항 제목 수정</td>
                                    <td>관리자</td>
                                    <td>2025-07-17</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="paging" id="noticepagination"></div>
                    </div>
                </div>
            </div>
            
            
            
        </main>
        
        <!-- 푸터 -->
        <jsp:include page="inc/footer.jsp"/>
        
    </div>
</div>

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="${ctx}/js/admin/dashboard.js"></script>
<script>




</script>
</body>
</html>
