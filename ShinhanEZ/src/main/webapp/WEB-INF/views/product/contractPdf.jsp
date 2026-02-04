<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>보험 계약서</title>
    <style>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'NotoSansKR', sans-serif;
            font-size: 11px;
            color: #000;
            line-height: 1.4;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 100%;
            margin: 0 auto;
            padding: 10px;
        }

        h1 {
            text-align: center;
            margin-bottom: 15px;
            font-size: 20px;
        }

        h2 {
            border-bottom: 2px solid #333;
            padding-bottom: 3px;
            margin-top: 12px;
            margin-bottom: 6px;
            font-size: 13px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 8px;
        }

        th, td {
            border: 1px solid #444;
            padding: 5px 8px;
        }

        th {
            background-color: #f2f2f2;
            width: 20%;
            text-align: left;
            font-size: 11px;
        }

        td {
            font-size: 11px;
        }

        .notice {
            margin-top: 8px;
            padding-left: 20px;
        }

        .notice li {
            margin-bottom: 3px;
            font-size: 10px;
        }

        .signature {
            margin-top: 15px;
        }

        .signature h2 {
            margin-top: 15px;
        }

        .signature-table tr {
        	display: table-row;
    	}
        .signature-table td {
        	display: table-cell;
        	width: 16.7%;
            height: 40px;
            text-align: center;
            vertical-align: middle;
            border-right: 0;
            font-size: 11px;
        }
        .signature-table td:nth-child(2),
        .signature-table td:nth-child(4){
        	display: table-cell;
        	width: 33.3%;
        }
        .signature-table td:last-child {
            border-right: 1px solid #444;
        }

        .footer {
            margin-top: 20px;
            text-align: left;
            font-size: 9px;
		    font-weight: 400;
		    color: #313749;
        }
        .footer .corpInfo {
        	display: table;
    		width: 100%;       	
        }
        .footer address>span {
		    display: table-cell;
		    vertical-align: middle;
		}
		.footer address>span:last-child{
			width: 30%;
			text-align: right;
		}
		.footer .copyright {
	        margin-top: 5px;
		}
    </style>
</head>
<body>
	<div class="container">
	
	    <h1>보험 계약서</h1>
	
	    <!-- 계약자 정보 -->
	    <h2>계약자 정보</h2>
	    <table>
	        <tr>
	            <th>성명</th>
	            <td>${customer.name}</td>
	            <th>성별</th>
	            <td>${customer.gender}</td>
	        </tr>
	        <tr>
	            <th>생년월일</th>
	            <td>${formattedCustomerBirth}</td>
	            <th>연락처</th>
	            <td>${customer.phone}</td>
	        </tr>
	        <tr>
	            <th>이메일</th>
	            <td colspan="3">${customer.email}</td>
	        </tr>
	    </table>
	
	    <!-- 피보험자 정보 -->
	    <h2>피보험자 정보</h2>
	    <table>
	        <tr>
	            <th>성명</th>
	            <td>${insured.name}</td>
	            <th>성별</th>
	            <td>${insured.gender}</td>
	        </tr>
	        <tr>
	            <th>생년월일</th>
	            <td>${formattedInsuredBirth}</td>
	            <th>연락처</th>
	            <td>${insured.phone}</td>
	        </tr>
	        <tr>
	            <th>이메일</th>
	            <td colspan="3">${insured.email}</td>
	        </tr>
	    </table>
	
	    <!-- 보험 상품 정보 -->
	    <h2>보험 상품 정보</h2>
	    <table>
	        <tr>
	            <th>상품명</th>
	            <td colspan="3">${contract.productName}</td>
	        </tr>
	        <tr>
	            <th>보장내용</th>
	            <td colspan="3">${contract.contractCoverage}</td>
	        </tr>
	        <tr>
	          	<th>보험료</th>
	            <td>${contract.premiumAmount}</td>
	            <th>납부주기</th>
	            <td>${contract.paymentCycle}</td>
	        </tr>
	        <tr>
	            <th>계약일</th>
	            <td>${formattedRegDate}</td>
	            <th>만료일</th>
	            <td>${formattedExpiredDate}</td>
	        </tr>
	    </table>
	
	    <!-- 안내사항 -->
	    <h2>안내사항</h2>
	    <ul class="notice">
	        <li>본 계약서는 보험계약의 주요 내용을 요약한 것입니다.</li>
	        <li>자세한 보장내용 및 제한사항은 보험약관을 참조하시기 바랍니다.</li>
	        <li>청약철회는 계약일로부터 15일 이내 가능합니다.</li>
	        <li>보험금 청구 시 관련 서류를 제출하셔야 합니다.</li>
	        <li>계약 전 상품설명서 및 약관을 반드시 확인하시기 바랍니다.</li>
	    </ul>
	
	    <!-- 서명 -->
	    <div class="signature">
	        <h2>서명</h2>
	        <table class="signature-table">
	            <tr>
	            	<td>
	            		서명일자
	            	</td>
	            	<td>
	            		${formattedSignedDate }
	            	</td>
	                <td>
	                    계약자 서명
	                </td>
	                <td>
	                	<c:if test="${not empty imageFormatSign }">
							(서명)
	                	</c:if>
	                </td>
	            </tr>
	        </table>
	    </div>
	
	    <div class="footer">
			<address class="corpInfo">
		      <span>04522 서울특별시 중구 남대문로 113 DB다동빌딩 5층 신한EZ손해보험 주식회사</span>
		      <span>사업자등록번호 220-86-65241</span>
		    </address>
		    <div class="copyright">ⓒ Shinhan EZ General Insurance Co., Ltd.</div>
	    </div>
	</div>
</body>
</html>
