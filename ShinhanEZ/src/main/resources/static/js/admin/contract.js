$(document).ready(()=>{
	let pageNum = 1;
	let pageSize = 10;
	/* ajax 모듈 */
	let contractService = (function(){
		
		/* 계약 목록 조회 */
		function getList(params, callback, error) { 
			$.ajax({ 
				url: '/admin/contract/rest', 
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
		
		/* 계약 단건 읽기 | 처리 필요*/
		function get(ctrId, callback, error) {
			$.ajax({
				type: "get",
				url: "/rest/" + ctrId,
				success: function (result, status, xhr) {
					if (callback) {
						callback(result);
					} else { 
						if (error) error(response.message || '데이터 조회 실패'); 
					} 
				},
				error: function (xhr, status, error) {
					if (error) {
						if (error) error('서버 오류가 발생했습니다.'); 
					}
				}
			});
		}
		
		/* 계약 등록 */
		function save(contract, callback, error){ 
			$.ajax({
				type: "post",
				url: "/rest/register",
				data: JSON.stringify(contract),
				contentType: "application/json; charset=utf-8",
				success: function (result, status, xhr) {
					if (callback) {
						callback(result);
					} else { 
						if (error) error(response.message || '저장실패'); 
					} 
				},
				error: function (xhr, status, error) {
					if (error) {
						if (error) error('서버 오류가 발생했습니다.'); 
					}
				}
			});
		}
	   
		/* 계약 수정 */
		function update(reply, callback, error) {
			$.ajax({
				type: "put",
				url: "/replies/" + reply.rno,
				data: JSON.stringify(reply),
				contentType: "application/json; charset=utf-8",
				success: function (result2, status, xhr) {
				if (callback) {
					callback(result2);
					}
				},
				error: function (xhr, status, er) {
					if (error) {
						error(er);
					}
				},
			});
		}
		
		/* 시간 처리 */
		function displayTime(timeValue) { 
			let today = new Date();
			let gap = today.getTime() - timeValue;
			let dateObj = new Date(timeValue); 
			if(gap < (1000 * 60 * 60 * 24)) { 
				let hh = dateObj.getHours();
				let mi = dateObj.getMinutes();
				let ss = dateObj.getSeconds();
				return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi, ':', (ss > 9 ? '' : '0') + ss ].join('');
			}else {
				let yy = dateObj.getFullYear();
				let mm = dateObj.getMonth() + 1;
				let dd = dateObj.getDate();
				return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd ].join('');
			}
		}
		return {
			getList: getList,
			get: get,
			save: save,
			update: update,
			displayTime: displayTime,
		};
	})();
	
	/* ajax 처리 */
	/* 계약 목록 조회 */

	// 초기 로드
	showList();
	
	// 계약 리스트 조회
	function showList(page = 1) {
	    pageNum = page;

	    const searchParams = {
	        pageNum: pageNum,
	        pageSize: pageSize,
	        searchType: $('select[name="searchType"]').val(),
	        searchKeyword: $('input[name="searchKeyword"]').val(),
	        contractDate: $('select[name="contractDate"]').val(),
	        startDate: $('input[name="startDate"]').val(),
	        endDate: $('input[name="endDate"]').val(),
	        contractStatus: $('select[name="contractStatus"]').val()
	    };

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
	            </tr>
	        `;
	        tbody.append(row);
	    });
	}

	// 페이지네이션
	function renderPagination(paging) {
	    const pgUl = $('.contract-pagination');
	    pgUl.empty();

	    if (paging.hasPrev) {
	        pgUl.append(`<li><a href="#" data-page="${paging.startPage - 1}">&laquo;</a></li>`);
	    } else {
	        pgUl.append(`<li><a href="#" class="disabled">&laquo;</a></li>`);
	    }
		
	    for (let i = paging.paging.pageNum; i <= paging.paging.endPage; i++) {
	        const activePage = i === paging.paging.pageNum ? 'activePage' : '';
	        pgUl.append(`<li><a href="#" class="${activePage}" data-page="${i}">${i}</a></li>`);
	    }

	    if (paging.hasNext) {
	        pgUl.append(`<li><a href="#" data-page="${paging.paging.endPage + 1}">&raquo;</a></li>`);
	    } else {
	        pgUl.append(`<li><a href="#" class="disabled">&raquo;</a></li>`);
	    }
	}

	// 총 건수 업데이트
	function updateTotalCount(totalCount) {
	    $('.totalContractInner').text(totalCount.toLocaleString());
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
		
	// 모달 폼 데이터
	// 샘플 데이터
    const customers = [
        { id: 'C001', name: '김철수' },
        { id: 'C002', name: '이영희' },
        { id: 'C003', name: '박민수' },
        { id: 'C004', name: '최지현' },
        { id: 'C005', name: '정수진' }
    ];

    const insureds = [
        { id: 'I001', name: '김철수' },
        { id: 'I002', name: '이영희' },
        { id: 'I003', name: '박민수' },
        { id: 'I004', name: '홍길동' },
        { id: 'I005', name: '강감찬' }
    ];

    const products = [
        { id: 'P001', name: '종합보험 플러스' },
        { id: 'P002', name: '암보험 프리미엄' },
        { id: 'P003', name: '실손의료보험' },
        { id: 'P004', name: '운전자보험' },
        { id: 'P005', name: '연금저축보험' }
    ];
	
	// 자동완성 초기화
    function initAutocomplete(inputName, resultsId, hiddenId, dataSource) {
        const input = document.getElementById(inputName);
        const results = document.getElementById(resultsId);
        const hidden = document.getElementById(hiddenId);

        input.addEventListener('input', function() {
            const value = this.value.trim();
            
            if (value === '') {
                results.classList.remove('active');
                hidden.value = '';
                return;
            }

            const filtered = dataSource.filter(item => 
                item.name.toLowerCase().includes(value.toLowerCase()) ||
                item.id.toLowerCase().includes(value.toLowerCase())
            );

            if (filtered.length > 0) {
                results.innerHTML = filtered.map(item => `
                    <div class="autocomplete-item" data-id="${item.id}" data-name="${item.name}">
                        <div class="autocomplete-id">${item.id}</div>
                        <div class="autocomplete-name">${item.name}</div>
                    </div>
                `).join('');
                results.classList.add('active');
            } else {
                results.classList.remove('active');
            }
        });

        results.addEventListener('click', function(e) {
            const item = e.target.closest('.autocomplete-item');
            if (item) {
                const id = item.dataset.id;
                const name = item.dataset.name;
                input.value = name;
                hidden.value = id;
                results.classList.remove('active');
            }
        });

        // 외부 클릭시 자동완성 닫기
        document.addEventListener('click', function(e) {
            if (!input.contains(e.target) && !results.contains(e.target)) {
                results.classList.remove('active');
            }
        });
    }
	// 자동완성 초기화
    initAutocomplete('customerName', 'customerResults', 'customerId', customers);
    initAutocomplete('insuredName', 'insuredResults', 'insuredId', insureds);
	initAutocomplete('productName', 'productResults', 'productId', products);
	
	// 모달 닫기
	$('#contractModal').on('click', '.modal-close, #cancelContract', function() {
		closeContractModal();
	});
	
	function closeContractModal() {
		$('#contractModal, #contractModalOverlay').removeClass('active');
		document.getElementById('customerId').value = '';
	    document.getElementById('insuredId').value = '';
	    document.getElementById('productId').value = '';
	}
	
	/* 계약 등록 */
	$('#contractForm').on('click', '#saveContract', function() {
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
