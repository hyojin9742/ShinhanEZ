$(document).ready(()=>{
	/* ajax 처리 */
	// 초기 로드
	showList();
	
	// 관리자 목록 조회
	function showList(page,size,param) {
		pageNum = page || 1;
		pageSize = size || 10;

		const searchParams = {
	        pageNum: pageNum,
	        pageSize: pageSize,
			searchType: $('select[name="searchType"]').val(),
			searchKeyword: $('input[name="searchKeyword"]').val(),
			adminRole: $('select[name="adminRole"]').val()
	    };

	    adminService.getList(
	        searchParams,
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

	// 관리자 리스트
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
	            <tr data-admin-idx="${admin.adminIdx}" class="admin-row">
	                <td>${admin.adminIdx}</td>
	                <td>${admin.adminId}</td>
	                <td>${admin.adminName}</td>
	                <td>${admin.adminRole}</td>
	                <td>${admin.department}</td>
	                <td>${adminService.displayTime(admin.lastLogin)}</td>
					<td>
                        <a href="/admin/employee/view?adminIdx=${admin.adminIdx}" class="btn btn-sm btn-outline getAdmin">상세</a>
                        <a class="btn btn-sm btn-warning modAdmin">수정</a>
						<a class="btn btn-sm btn-danger delAdmin">삭제</a>
                    </td>
	            </tr>
	        `;
	        tbody.append(row);
	    });
	}

	// 페이지네이션
	function renderPagination(paging) {
	    const pgUl = $('.admin-pagination');
	    pgUl.empty();
		
		const pageInfo = paging.pagingObj;
		
	    if (paging.hasPrev) {
	        pgUl.append(`<li><a href="#" data-page="${paging.startPage - 1}">&laquo;</a></li>`);
	    }
		
	    for (let i = pageInfo.pageNum; i <= pageInfo.endPage; i++) {
	        const activePage = i === pageInfo.pageNum ? 'activePage' : '';
	        pgUl.append(`<li><a href="#" class="${activePage}" data-page="${i}">${i}</a></li>`);
	    }

	    if (paging.hasNext) {
	        pgUl.append(`<li><a href="#" data-page="${pageInfo.endPage + 1}">&raquo;</a></li>`);
	    }
	}
	// 페이지네이션 클릭 이벤트
	$(document).on('click', '.admin-pagination a', function(e) {
	    e.preventDefault();
	    const page = $(this).data('page');
	    if (page) {
	        showList(page,pageSize);
	    }
	});
	// 페이지 사이즈 변경 이벤트
	$(document).on('change', 'select[name="pageSize"]', function () {
	    const newSize = parseInt($(this).val(), 10);

	    pageSize = newSize;
	    pageNum = 1;

	    showList(pageNum, pageSize);
	});
	// 총 건수 업데이트
	function updateTotalCount(totalCount) {
	    $('.totalAdminInner').text(totalCount.toLocaleString());
	}
	// 검색 기능
	$('.searchBtn button[type="submit"]').on('click',function(e){
		e.preventDefault();
		let searchForm = $('.adminSearchForm');
		let searchJsonForm = formToJson(searchForm);
		pageNum = 1;
		const pageSize = $('select[name="pageSize"]').val();
		showList(pageNum,pageSize,searchJsonForm);
		
	});
	// 검색어 초기화 처리
	$('.searchBtn button[type="reset"]').on('click',function(e){
		e.preventDefault();
		let searchForm = $('.adminSearchForm');
		let searchJsonForm = formToJson(searchForm);
		pageNum = 1;
		const pageSize = $('select[name="pageSize"]').val();
		searchForm[0].reset();
		showList(pageNum,pageSize,searchJsonForm);
	});
	/* 모달 */
    // 등록 버튼 클릭
    $('.page-title-area .btn-primary').on('click', function(e) {
        e.preventDefault();
        openAdminModal();
    });
	
    // 모달 열기
    function openAdminModal(adminIdx = null) {
	    $('#adminModalOverlay, #adminModal').addClass('active');
	    
		if (adminIdx) {
			const adminIdxInput = `
				<label class="form-label">관리자 번호 <span>*</span></label>
				<input type="text" class="form-control" id="adminIdx" name="adminIdx" readonly>
			`;
			const lastLogin = `
				<label class="form-label">마지막 로그인</label>
				<input type="text" class="form-control" id="lastLogin" name="lastLogin" readonly disabled>
			`;
			$('#adminForm .form-group.adminIdx').append(adminIdxInput);
			$('#adminForm .form-group.lastLogin').append(lastLogin);
		    $('.modal-title').text('관리자 수정');
		    $('#saveAdmin').text('수정').removeClass('registerAdmin').addClass('modifyAdmin');
		    loadAdminData(adminIdx);
		} else {
			$('#adminId').prop('readonly',false);
		    $('.modal-title').text('관리자 등록');
		    $('#saveAdmin').text('등록').removeClass('modifyAdmin').addClass('registerAdmin');
		    // 폼 초기화
		    $('#adminForm')[0].reset();
		}
	}
	// 모달 닫기
	$('#adminModal').on('click', '.modal-close, #cancelAdmin', function() {
		closeAdminModal();
	});
	function closeAdminModal(){
		$('#adminModal, #adminModalOverlay').removeClass('active');
		// 모달 닫을 때 내용 초기화
	    const formEl = $('#adminForm')[0];
	    formEl.reset();
		$('#adminId').val('');
		$('#adminPw').val('');
		$('#adminName').val('');
		$('#department').val('');
		$('#adminRole').val('');
		$('#adminForm .form-group.adminIdx label').remove();
		$('input#adminIdx').remove();
		$('#adminForm .form-group.lastLogin label').remove();
		$('input#lastLogin').remove();
	}
	/* 관리자 등록 */
	$(document).on('click', '.registerAdmin', function() {
		const form = $('#adminForm');
		
	    if (!form[0].checkValidity()) {
	        form[0].reportValidity();
	        return;
	    }
	    let jsonForm = formToJson(form);
		adminService.save(
			jsonForm,
			function (response) {
	            showAlert('success', '관리자가 등록되었습니다.');
	            closeAdminModal();
	            showList(pageNum);
	        },
	        function (errorMsg) {
	            showAlert('error', errorMsg);
	        }
		);
	});	
	// 관리자 수정 모달창 오픈
	$(document).on('click', '.modAdmin', function (e) {
	    e.preventDefault();
	   	const adminIdx = $(this)
	        .closest('tr')
	        .data('adminIdx');
		openAdminModal(adminIdx);
	});
	// 상세페이지 수정 모달창 오픈
	$(document).on('click', '.viewModAdmin', function (e) {
	    e.preventDefault();
	   	const adminIdx = $(this).data('adminIdx');
		openAdminModal(adminIdx);
	});
	
	// 관리자 상세 함수
	function loadAdminData(adminIdx){
		adminService.get(
		    adminIdx,
		    function (data) {
		        $('#adminIdx').val(data.adminIdx).prop('readonly',true);
				$('#adminId').val(data.adminId).prop('readonly',true);
				
				$('#adminPw').val(data.adminPw);
				$('#adminName').val(data.adminName);
				$('#department').val(data.department);
				$('#adminRole').val(data.adminRole);
				$('#lastLogin').val(data.lastLogin);
		    },
		    function (err) {
		        console.error(err);
		    }
		);
	}
	// 관리자 수정
	$(document).on('click', '.modifyAdmin', function() {
		const form = $('#adminForm');
		
	    if (!form[0].checkValidity()) {
	        form[0].reportValidity();
	        return;
	    }
	    let jsonForm = formToJson(form);
		adminService.update(
			jsonForm,
			function (response) {
	            showAlert('success', '관리자가 수정되었습니다.');
	            closeAdminModal();
				setTimeout(function() {				
		            location.href = `/admin/employee/view?adminIdx=${jsonForm.adminIdx}`
				}, 600);
	        },
	        function (errorMsg) {
	            showAlert('error', errorMsg);
	        }
		);
	});
	// 관리자 삭제
	$(document).on('click', '.delAdmin', function(e) {
		e.preventDefault();

		if (!confirm('정말 삭제하시겠습니까?')) return;
		
		const adminIdx = $(this).closest('tr').data('adminIdx');
		
		adminService.deleteAdmin(
			adminIdx,
			function (response) {
	            showAlert('success', '관리자가 삭제되었습니다.');
				setTimeout(function() {				
					location.href='/admin/employee';
				}, 600);
	        },
	        function (errorMsg) {
	            showAlert('error', errorMsg);
	        }
		);
	});
	// 상세페이지 관리자 삭제
	$(document).on('click', '.viewDelAdmin', function(e) {
		e.preventDefault();

		if (!confirm('정말 삭제하시겠습니까?')) return;
		
		const adminIdx = $(this).data('adminIdx');
		
		adminService.deleteAdmin(
			adminIdx,
			function (response) {
	            showAlert('success', '관리자가 삭제되었습니다.');
				setTimeout(function() {				
					location.href='/admin/employee';
				}, 600);
	        },
	        function (errorMsg) {
	            showAlert('error', errorMsg);
	        }
		);
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
	   
		$('#alert-area').append(alertHtml);
	   
		setTimeout(function() {
			$('.alert').fadeOut(300, function() {
				$(this).remove();
			});
		}, 600);
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
