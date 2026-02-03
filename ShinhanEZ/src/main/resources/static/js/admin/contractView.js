$(document).ready(()=>{
	const productId = $('#productId').val();
	/* ajax 처리 */
	
	/* 모달 */
    // 계약 모달 열기
    function openContractModal() {
	    $('#contractModalOverlay, #contractModal').addClass('active');
		if (!$('#adminName').val() || $('#adminName').val() == null) {
	        setAuthAdmin();
	    }
	}
	
	// 모달 닫기 이벤트
	$('#contractModal').on('click', '.modal-close, #cancelContract', function() {
		closeContractModal();
	});
	// 모달 닫기 함수
	function closeContractModal(){
		$('#contractModal, #contractModalOverlay').removeClass('active');
		// 모달 닫을 때 내용 초기화
	    const formEl = $('#contractForm')[0];
	    formEl.reset();

	    $('#customerId').val('');
	    $('#insuredId').val('');
	    $('#productId').val('');

	    $('.autocomplete-results').removeClass('active').empty();

	    $('.riderList').empty();

	    $('input[type="checkbox"][value="주계약"]').prop('checked', true);
	}
	// 계약 수정 모달창 오픈
	$(document).on('click', '.contract-update', function (e) {
	    e.preventDefault();
		openContractModal();
		getCoverageById(productId);
	});
	// 보장 목록 ajax 처리
	function getCoverageById(productId) {
		const currentCoverages = $('.currentCoverage').text().split(',').map(c => c.trim());

		contractService.getProductById(
			productId,
			function(coverage) {
				renderCoverages(coverage, currentCoverages);
			},
			function(xhr, status, error) {
				showAlert('error', '보장내역을 불러오는데 실패했습니다.');
			}
		);
	}
	
	// 보장내역 체크박스 렌더링
	function renderCoverages(coverage, currentCoverages) {
		const riderList = $('.riderList');
		riderList.empty();
		
		if (!coverage || !coverage.coverageRange) {
			riderList.append('<p class="text-muted">보장내역이 없습니다.</p>');
			return;
		}
	    const coverageItems = coverage.coverageRange
	        .split(',')
	        .map(item => item.trim());

	    coverageItems.forEach((item, index) => {
	        if (item === '주계약' || item === '') return;

	        const isChecked = currentCoverages.includes(item);

	        const checkboxHtml = `
	            <div class="coverage-item">
	                <input
	                    type="checkbox"
	                    name="contractCoverage"
	                    value="${item}"
	                    id="coverage_${index}"
	                    ${isChecked ? 'checked' : ''}
	                />
	                <label for="coverage_${index}">
	                    ${item}
	                </label>
	            </div>
	        `;

	        riderList.append(checkboxHtml);
	    });
	}
	// 현재 로그인한 관리자 정보
	function setAuthAdmin() {
	    $.ajax({
	        url: '/admin/contract/rest/auth/adminInfo',
	        type: 'GET',
	        success: function(response) {
	            if (response && response.adminName && response.adminIdx) {
	                $('#adminName').val(response.adminName);
	                $('#adminIdx').val(response.adminIdx);
	            } else {
	                alert('담당관리자를 목록에서 선택해주세요.');
	                $('#adminName').val('');
	                $('#adminIdx').val('');
	            }
	        },
	        error: function() {
	            alert('담당관리자 정보를 가져올 수 없습니다.');
	            $('#adminName').val('');
	            $('#adminIdx').val('');
	        }
	    });
	}
	// 계약 수정
	$(document).on('click', '#saveContract', function() {
		const form = $('#contractForm');
		
        if (!form[0].checkValidity()) {
            form[0].reportValidity();
            return;
        }
        let jsonForm = formToJson(form);
		
		contractService.update(
			jsonForm,
			function (response) {
	            showAlert('success', '계약이 수정되었습니다.');
	            closeContractModal();
	            location.reload();
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
       
		$('body').append(alertHtml);
       
		setTimeout(function() {
			$('.alert').fadeOut(300, function() {
				$(this).remove();
			});
		}, 800);
	}
	// 폼 -> JSON 변환
	function formToJson(form) {
	    const jsonForm = {};
	    form.serializeArray().forEach(item => {
	        jsonForm[item.name] = item.value;
	    });

	    const coverages = ['주계약'];

	    $('input[name="contractCoverage"]:checked')
	        .each(function() {
	            const value = $(this).val();
	            coverages.push(value);
	        });
	    
	    jsonForm.contractCoverage = coverages.join(',');
	    return jsonForm;
	}
}); // /documnet.ready
