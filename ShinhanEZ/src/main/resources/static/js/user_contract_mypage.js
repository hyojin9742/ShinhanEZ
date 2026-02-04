$(document).ready(function(){
	showList();

	// 계약 리스트 조회
	function showList(page,size) {
	    pageNum = page || 1;
		pageSize = size || 10;
	    const searchParams = {
	        pageNum: pageNum,
	        pageSize: pageSize,
	    };
		
	    getList(
	        searchParams,
	        function(paging, allList, totalCount) {
	            renderContractList(allList);
	        },
	        function(errorMsg) {
				console.error(errorMsg);
	        }
	    );
	}
	// 계약 목록 읽어오기
	function getList(params, callback, error) { 
		$.ajax({ 
			url: '/mypage/rest/contractList', 
			type: 'GET', 
			data: params, 
			dataType: 'json', 
			success: function(response) { 
				if (response) { 
					if (callback) { 
						callback(
							response.paging,
							response.allList,
							response.paging.paging.totalDB
						); 
					} 
				} else { 
					if (error) error(response.message || '데이터 조회 실패'); 
				} 
			}, 
			error: function(xhr, status, err) { 
				if (error) error('서버 오류가 발생했습니다.'); 
			} 
		}); 
	}
	
	// 계약 리스트
	function renderContractList(allList) {
	    const contracttbody = $('#mypageContract');
	    contracttbody.empty();

	    if (!allList || allList.length === 0) {
	        contracttbody.append(`
	            <tr>
	                <td colspan="9" style="text-align: center; padding: 40px;">
	                    조회된 계약 내역이 없습니다.
	                </td>
	            </tr>
	        `);
	        return;
	    }

	    allList.forEach(contract => {
			let displayAdminName = null;
			if(contract.adminName == null){
				displayAdminName = "";
			} else {
				displayAdminName=contract.adminName;
			}
			let statusClass = null;
			switch(contract.contractStatus) {
				case '활성':
					statusClass = "PAID";
					break;
				case '만료':
					statusClass = "OVERDUE";
					break;
				default:
					statusClass = "PENDING";
			}
					
	        const row = `
	            <tr data-contract-id="${contract.contractId}" class="contract-row">
	                <td>${contract.customerName}</td>
	                <td>${contract.insuredName}</td>
	                <td>${contract.productName}</td>
	                <td>${displayTime(contract.regDate)}</td>
	                <td>${displayTime(contract.expiredDate)}</td>
	                <td class="amount">${contract.premiumAmount}</td>
	                <td><span class="status-badge status-${statusClass}">${contract.contractStatus}</span></td>
	                <td>${displayAdminName}</td>
					<td>
						<button
			              type="button"
						  class="downloadContract"
			            >다운로드</button>
	                </td>
	            </tr>
	        `;
	        contracttbody.append(row);
	    });
	}
	$(document).on("click",'.downloadContract',function(){
		const contractId = $(this).closest('tr').data('contractId');
		const pdfUrl = `/userContract/downloadPdf/${contractId}`;
		const newWindow = window.open(pdfUrl, '_blank');
		if (!newWindow) {
		    // 팝업 차단 시
		    alert('팝업이 차단되었습니다. 팝업 차단을 해제해주세요.');
		    reject(new Error('팝업 차단'));
		    return;
		}
	})
	/* 시간 처리 */
	function displayTime(timeValue) { 
		let dateObj = new Date(timeValue); 
		let yy = dateObj.getFullYear();
		let mm = dateObj.getMonth() + 1;
		let dd = dateObj.getDate();
		return [ yy, '-', (mm > 9 ? '' : '0') + mm, '-', (dd > 9 ? '' : '0') + dd ].join('');

	}
});
