$(document).ready(()=>{
	let pageNum = 1;
	let pageSize = 10;
	/* ajax 처리 */
	/* 계약 목록 조회 */

	// 초기 로드
	showList();
	
	// 계약 리스트 조회
	function showList(page = pageNum) {
	    pageNum = page;

	    const params = {
	        pageNum: pageNum,
	        pageSize: pageSize
	    };

	    adminService.getList(
	        params,
	        function(paging, allList, totalCount) {
	            renderPagination(paging);
	            renderAdminList(allList);
	            updateTotalCount(totalCount);
	        },
	        function(errorMsg) {
	            showAlert('error', errorMsg);
	        }
	    );
	}

	// 계약 리스트
	function renderAdminList(allList) {
	    const tbody = $('.adminList');
	    tbody.empty();

	    if (!allList || allList.length === 0) {
	        tbody.append(`
	            <tr>
	                <td colspan="9" style="text-align: center; padding: 40px;">
	                    조회된 내역이 없습니다.
	                </td>
	            </tr>
	        `);
	        return;
	    }

	    allList.forEach(admin => {
	        const row = `
	            <tr data-contract-id="${admin.contractId}" class="contract-row">
	                <td>${admin.adminIdx}</td>
	                <td>${admin.adminId}</td>
	                <td>${admin.adminName}</td>
	                <td>${admin.adminRole}</td>
	                <td>${admin.department}</td>
	                <td>${adminService.displayTime(admin.lastLogin)}</td>
	            </tr>
	        `;
	        tbody.append(row);
	    });
	}

	// 페이지네이션
	function renderPagination(paging) {
	    const pgUl = $('.admin-pagination');
	    pgUl.empty();
		
	    if (paging.hasPrev) {
	        pgUl.append(`<li><a href="#" data-page="${paging.startPage - 1}">&laquo;</a></li>`);
	    }
		
	    for (let i = paging.paging.pageNum; i <= paging.paging.endPage; i++) {
	        const activePage = i === paging.paging.pageNum ? 'activePage' : '';
	        pgUl.append(`<li><a href="#" class="${activePage}" data-page="${i}">${i}</a></li>`);
	    }

	    if (paging.hasNext) {
	        pgUl.append(`<li><a href="#" data-page="${paging.paging.endPage + 1}">&raquo;</a></li>`);
	    }
	}

	// 총 건수 업데이트
	function updateTotalCount(totalCount) {
	    $('.totalAdminInner').text(totalCount.toLocaleString());
	}

	/* 모달 */
    // 계약 등록 버튼 클릭
    $('.page-title-area .btn-primary').on('click', function(e) {
        e.preventDefault();
        openContractModal();
    });
	
    // 계약 등록 모달 열기
    function openContractModal(contractId = null) {
	    $('#contractModalOverlay, #contractModal').addClass('active');
	    
	    // 관리자 목록 로드
	    // loadAdminList();
	    
	    // 수정인 경우 데이터 로드
	    if (contractId) {
	        loadContractData(contractId);
	    }
	}
	// 모달 닫기
	$('#contractModal').on('click', '.modal-close, #cancelContract', function() {
		$('#contractModal, #contractModalOverlay').removeClass('active');
		// 모달 닫을 때 내용 초기화
	    const formEl = $('#contractForm')[0];
	    formEl.reset();

	    $('#customerId').val('');
	    $('#insuredId').val('');
	    $('#productId').val('');
	});
	
	/* 유틸리티 함수 */
	// 예외처리
	function showAlert(type, message) {
		const icon = type === 'success' ? 'bi-check-circle' : 'bi-exclamation-circle';
		const alertHtml = `
			<div class="alert alert-${type} custom-alert">
				<i class="bi ${icon}"></i> ${message}
			</div>
		`;
       
		$('body').append(alertHtml);
       
		setTimeout(function() {
			$('.alert').fadeOut(300, function() {
				$(this).remove();
			});
		}, 800);
	}
	// 폼 -> JSON 변환
	function formToJson($form) {
	    const jsonForm = {};
	    $form.serializeArray().forEach(item => {
	        jsonForm[item.name] = item.value;
	    });
	    return jsonForm;
	}
}); // /documnet.ready
