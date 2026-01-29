$(document).ready(()=>{
	let products = [];
	/* ajax 처리 */
	/* 계약 목록 조회 */

	// 초기 로드
	showList();
	
	// 계약 리스트 조회
	function showList(page,size,param) {
	    pageNum = page || 1;
		pageSize = size || 10;
	    const searchParams = {
	        pageNum: pageNum,
	        pageSize: pageSize,
			searchType: $('select[name="searchType"]').val(),
			searchKeyword: $('input[name="searchKeyword"]').val(),
			contractStatus: $('select[name="contractStatus"]').val()
	    };
		const startDate = $('input[name="startDate"]').val();
		const endDate = $('input[name="endDate"]').val();
		const dateCriteria = $('select[name="dateCriteria"]').val();

		if (startDate) searchParams.startDate = startDate;
		if (endDate) searchParams.endDate = endDate;
		if (dateCriteria) searchParams.dateCriteria = dateCriteria;
		
	    contractService.getList(
	        searchParams,
	        function(paging, allList, totalCount) {
	            renderPagination(paging);
	            renderContractList(allList);
	            updateTotalCount(totalCount);
	        },
	        function(errorMsg) {
	            showAlert('error', errorMsg);
	        }
	    );
	}

	// 계약 리스트
	function renderContractList(allList) {
	    const tbody = $('.contractContent');
	    tbody.empty();

	    if (!allList || allList.length === 0) {
	        tbody.append(`
	            <tr>
	                <td colspan="9" style="text-align: center; padding: 40px;">
	                    조회된 계약 내역이 없습니다.
	                </td>
	            </tr>
	        `);
	        return;
	    }

	    allList.forEach(contract => {
	        const row = `
	            <tr data-contract-id="${contract.contractId}" class="contract-row">
	                <td>${contract.contractId}</td>
	                <td>${contract.customerName}</td>
	                <td>${contract.insuredName}</td>
	                <td>${contract.productName}</td>
	                <td>${contractService.displayTime(contract.regDate)}</td>
	                <td>${contractService.displayTime(contract.expiredDate)}</td>
	                <td><span class="statusTd">${contract.contractStatus}</span></td>
	                <td>${contractService.displayTime(contract.updateDate)}</td>
	                <td>${contract.adminName}</td>
					<td>
                        <a href="/admin/contract/view?contractId=${contract.contractId}" class="btn btn-sm btn-outline">상세</a>
                        <a href="/admin/contract/rest/update/{contractId}" class="btn btn-sm btn-warning contract-update">수정</a>
                    </td>
	            </tr>
	        `;
	        tbody.append(row);
	    });
	}

	// 페이지네이션
	function renderPagination(paging) {
	    const pgUl = $('.contract-pagination');
	    pgUl.empty();
	    
	    const pageInfo = paging.paging;
	    
	    if (paging.hasPrev) {
	        pgUl.append(`<li><a href="#" data-page="${pageInfo.startPage - 1}">&laquo;</a></li>`);
	    }
	    
	    for (let i = pageInfo.startPage; i <= pageInfo.endPage; i++) {
	        const activePage = i === pageInfo.pageNum ? 'activePage' : '';
	        pgUl.append(`<li><a href="#" class="${activePage}" data-page="${i}">${i}</a></li>`);
	    }

	    if (paging.hasNext) {
	        pgUl.append(`<li><a href="#" data-page="${pageInfo.endPage + 1}">&raquo;</a></li>`);
	    }
	}
	// 페이지네이션 클릭 이벤트
	$(document).on('click', '.contract-pagination a', function(e) {
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
	    $('.totalContractInner').text(totalCount.toLocaleString());
	}
	// 검색 기능
	$('.searchBtn button[type="submit"]').on('click',function(e){
		e.preventDefault();
		let searchForm = $('.contractSearchForm');
		let searchJsonForm = formToJson(searchForm);
		pageNum = 1;
		const pageSize = $('select[name="pageSize"]').val();
		showList(pageNum,pageSize,searchJsonForm);
		
	})
	// 검색어 초기화 처리
	$('.searchBtn button[type="reset"]').on('click',function(e){
		e.preventDefault();
		let searchForm = $('.contractSearchForm');
		let searchJsonForm = formToJson(searchForm);
		pageNum = 1;
		const pageSize = $('select[name="pageSize"]').val();
		searchForm[0].reset();
		showList(pageNum,pageSize,searchJsonForm);
	})
	/* 모달 */
    // 계약 등록 버튼 클릭
    $('.page-title-area .btn-primary').on('click', function(e) {
        e.preventDefault();
        openContractModal();
    });
	
    // 계약 모달 열기
    function openContractModal(contractId = null) {
	    $('#contractModalOverlay, #contractModal').addClass('active');

	    if (contractId) {
			const status =`
			<label class="form-label">계약상태 <span>*</span></label>
           	<select class="form-control" name="contractStatus" id="contractStatus" required>
                <option value="">상태변경</option>
                <option value="활성">활성</option>
                <option value="만료">만료</option>
                <option value="해지">해지</option>
            </select>
			`;
			const contractIdHidden = `<input type="hidden" name="contractId" id="contractId"/>`;
			$('.form-group.contractStatus').html(status);
			$('#contractForm').append(contractIdHidden);
	        $('.modal-title').text('계약 수정');
	        $('#saveContract').text('수정').removeClass('registerContract').addClass('modifyContract');
	        loadContractData(contractId);
	    } else {
			$('#customerName').prop('readonly',false);
			$('#insuredName').prop('readonly',false);
			$('#productName').prop('readonly',false);
			$('#regDate').prop('readonly',false);
	        $('.modal-title').text('계약 등록');
	        $('#saveContract').text('등록').removeClass('modifyContract').addClass('registerContract');
	        // 폼 초기화
	        $('#contractForm')[0].reset();
	        $('.autocomplete-results').hide();
	    }
	}
	
	/* 자동완성 */	
	// 디바운스 함수
	function debounce(func, delay = 300) {
	    let timer;
	    return function (...args) {
	        clearTimeout(timer);
	        timer = setTimeout(() => func.apply(this, args), delay);
	    };
	}
	// 보장내용 체크박스 생성 함수
	function coverageChk(productNo) {
	    const product = products.find(p =>  p.productNo === productNo);
	    const riderList = $('.riderList');
	    
        riderList.empty();
	    if (!product || !product.coverageRange) {
	        return;
	    }

	    const coverages = product.coverageRange.split(',').map(c => c.trim());

	    let rider = '';
	    coverages.forEach((coverage, index) => {
	        rider += `
	            <div class="coverage-item">
	                <input type="checkbox" 
	                       id="coverage_${index}" 
	                       name="contractCoverage" 
	                       value="${coverage}">
	                <label for="coverage_${index}">${coverage}</label>
	            </div>
	        `;
	    });
	    
	    riderList.html(rider);
	}
			
	// 자동완성 함수
	function autocomplete(inputName, resultsId, hiddenId, ajaxUrl, paramName) {
	    const input = $('#' + inputName);
	    const results = $('#' + resultsId);
	    const hidden = $('#' + hiddenId);
		
		const debounceSearch = debounce(function(){
	        const value = $.trim(input.val());
			if (value === '') {
	            results.removeClass('active').empty();
	            hidden.val('');
	            return;
	        }
			
			const params = {};
	        params[paramName] = value;
			
			contractService.ajaxAutoComplete(
				ajaxUrl,
				params,
				function (list) {
	                if (!list || list.length === 0) {
	                    results.removeClass('active').empty();
	                    return;
	                }
					if (inputName === 'productName') {
			            products = list;
			        }
	                const html = list.map(item => {					                    
	                    let id, name;
						
	                    if (inputName === 'customerName' || inputName === 'insuredName') {
	                        id = item.customerId;
	                        name = item.name;
	                    } else if (inputName === 'productName') {
	                        id = item.productNo;
	                        name = item.productName;
	                    } else if (inputName === 'adminName') {
	                        id = item.adminIdx;
	                        name = item.adminName;
	                    }
	                    
					return `
	                    <div class="autocomplete-item"
	                         data-id="${id}"
	                         data-name="${name}">
	                        <div class="autocomplete-id">${id}</div>
	                        <div class="autocomplete-name">${name}</div>
	                    </div>
	                `}).join('');
	                results.html(html).addClass('active');
	            }
			); // /contractService.ajaxAutoComplete
		},300); // /debounceSearch
		
	    // 입력 이벤트
	    input.on('input', debounceSearch);
		
		// 유효성 검증
	    input.on('blur', function () {
	        setTimeout(() => {
	            if (input.val() && !hidden.val()) {
	                alert('목록에서 선택해주세요.');
	                input.val('');
	            }
	            results.removeClass('active');
	        }, 150);
	    });
		
	    // 자동완성 항목 클릭
	    results.on('click', '.autocomplete-item', function () {
	        const id = $(this).data('id');
	        const name = $(this).data('name');
	        input.val(name);
	        hidden.val(id);
	        results.removeClass('active');
			
			// 보장내용
			if (inputName === 'productName') {
	        	coverageChk(id);
	        }

	    });

	    // 외부 클릭 시 자동완성 닫기
	    $(document).on('click', function (e) {
	        if (
	            !input.is(e.target) &&
	            !results.is(e.target) &&
	            results.has(e.target).length === 0
	        ) {
	            results.removeClass('active');
	        }
	    });
	}// /autocomplete

	// 자동완성 초기화
    autocomplete('customerName', 'customerResults', 'customerId', '/admin/contract/search/customers','customerName');
    autocomplete('insuredName', 'insuredResults', 'insuredId', '/admin/contract/search/customers','customerName');
	autocomplete('productName', 'productResults', 'productId', '/admin/contract/search/insurances','productName');
	autocomplete('adminName', 'adminResults', 'adminIdx', '/admin/contract/search/admins','adminName');
	
	// 모달 닫기
	$('#contractModal').on('click', '.modal-close, #cancelContract', function() {
		closeContractModal();
	});
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
		$('input#contractId').remove();
	}
	
	/* 계약 등록 */
	$(document).on('click', '.registerContract', function() {
		const form = $('#contractForm');
		
        if (!form[0].checkValidity()) {
            form[0].reportValidity();
            return;
        }
        let jsonForm = formToJson(form);
		contractService.save(
			jsonForm,
			function (response) {
	            showAlert('success', '계약이 등록되었습니다.');
	            closeContractModal();
	            showList(pageNum);
	        },
	        function (errorMsg) {
	            showAlert('error', errorMsg);
	        }
		);
    });
	// 계약 수정 모달창 오픈
	$(document).on('click', '.contract-update', function (e) {
	    e.preventDefault();
	   	const contractId = $(this)
	        .closest('tr')
	        .data('contractId');
		openContractModal(contractId);
	});
	// 상품 번호로 보험 가져오기
	function getCoverageById(productId,currentCoverage) {
		const currentCoverages = currentCoverage.split(',').map(c => c.trim());
		console.log('currentCoverages : '+currentCoverages);
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
	// 계약 상세 함수
	function loadContractData(contractId){
		contractService.get(
		    contractId,
		    function (data) {
		        $('#contractId').val(data.contractId);
				
				$('#customerName').val(data.customerName).prop('readonly',true);
				$('#customerId').val(data.customerId);
				
				$('#insuredName').val(data.insuredName).prop('readonly',true);
				$('#insuredId').val(data.insuredId);
				
				$('#productName').val(data.productName).prop('readonly',true);
				$('#productId').val(data.productId);
				
				getCoverageById(data.productId,data.contractCoverage);
				
				$('#regDate').val(data.regDate).prop('readonly',true);
				$('#expiredDate').val(data.expiredDate);
				$('#premiumAmount').val(data.premiumAmount);
				$('#paymentCycle').val(data.paymentCycle);
				
				$('#adminName').val(data.adminName);
				$('#adminIdx').val(data.adminIdx);
				$('#contractStatus').val(data.contractStatus);
		    },
		    function (err) {
		        console.error(err);
		    }
		);
	}
	// 계약 수정
	$(document).on('click', '.modifyContract', function() {
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
	            location.href = `/admin/contract/view?contractId=${jsonForm.contractId}`
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
