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
                    <div class="info">
                        <h3>7</h3>
                        <p>전체 고객 수</p>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="icon green"><i class="bi bi-person-badge"></i></div>
                    <div class="info">
                        <h3>9</h3>
                        <p>전체 피보험자 수</p>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="icon orange"><i class="bi bi-file-earmark-text"></i></div>
                    <div class="info">
                        <h3>8</h3>
                        <p>전체 계약 수</p>
                    </div>
                </div>
                <div class="summary-card">
                    <div class="icon purple"><i class="bi bi-megaphone"></i></div>
                    <div class="info">
                        <h3>2</h3>
                        <p>전체 공지사항 수</p>
                    </div>
                </div>
            </div>
            
            <!-- 차트 영역 -->
            <div class="dashboard-row">
                <div class="chart-container">
                    <div class="chart-title">📊 월별 계약 수</div>
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
                        <a href="${ctx}/admin/contract" class="btn btn-sm btn-primary">계약 리스트 →</a>
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
                            <tbody>
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
                            <tbody>
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
<script>
// 월별 계약 수 차트
new Chart(document.getElementById('barChart'), {
    type: 'bar',
    data: {
        labels: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        datasets: [{
            label: '계약 수',
            data: [3, 5, 4, 6, 8, 7, 9, 6, 5, 4, 3, 2],
            backgroundColor: '#0d6efd'
        }]
    },
    options: { 
        responsive: true,
        plugins: { legend: { display: false } }
    }
});

// 상품별 계약 분포 차트
new Chart(document.getElementById('pieChart'), {
    type: 'pie',
    data: {
        labels: ['실손보험', '암보험', '운전자보험'],
        datasets: [{
            data: [45, 35, 20],
            backgroundColor: ['#0d6efd', '#198754', '#ffc107']
        }]
    },
    options: { responsive: true }
});
</script>
</body>
</html>
