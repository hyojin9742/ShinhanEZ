$(document).ready(function(){
	/* 모달 */
	// 계약 등록 버튼 클릭
	$('.btn-subscribe').on('click', function(e) {
	    e.preventDefault();
	    openContractModal();
	});

	// 모달 열기 함수
	function openContractModal() {
	    $('#contractModalOverlay, #contractModal').addClass('active');
		showUser();
		coverageChk();
	}
	// 인증 정보 + 데이터 입력
	function showUser(){
	    $.ajax({
	        url: "/userContract/authInfo",
	        method: "GET",
	        dataType: "json",
	        success: function(user) {
	            if (user) {
	                if (user.name) {
	                    $('#customerName').val(user.name);
						$('#insuredName').val(user.name)
	                }
	                if (user.gender) {
						if (user.gender === 'M') {
						    $('#gen_male').prop('checked', true);
						} else if (user.gender === 'F') {
						    $('#gen_female').prop('checked', true);
						}
	                }
	                if (user.birth) {
						var birthDate = new Date(user.birth);
						var formattedDate = birthDate.getFullYear() + '-' 
						                  + String(birthDate.getMonth() + 1).padStart(2, '0') + '-' 
						                  + String(birthDate.getDate()).padStart(2, '0');
	                    $('#birth_date').val(formattedDate);
	                }
					if(user.phone){
						$('#phone').val(user.phone);
					}
					if(user.email){
						$('#email').val(user.email);
					}
					if(user.id){
						$('#loginId').val(user.id);
					}
					isUserExist(user)
						.then(customer => {
						    $('#customerId').val(customer.customerId);
						    $('#insuredId').val(customer.customerId);
							$('#address').val(customer.address);
						})
						.catch(err => {
							console.error(err.message);
						});
	            } else {
	                console.log("인증된 사용자 정보가 없습니다."); // 에러 처리 확인
	            }
	        },
	        error: function(xhr, status, error) {
	            console.error("사용자 정보를 가져오는데 실패했습니다:", error);
	        }
	    });
	}
	/* 기존 고객 확인 | 고객번호 반환 */
	async function isUserExist(user) {
	    try {
	        const response = await $.ajax({
	            url: '/userContract/rest/' + user.id,
	            method: 'GET'
	        });

	        if (response) {
	            return response; // 성공적으로 고객 ID 반환
	        } else {
	            // 이름/전화로 고객 조회 (Promise 반환한다고 가정)
	            return await getCustomerByNamePhone(user);
	        }
	    } catch (error) {
	        // 에러 발생 시에도 이름/전화로 조회 시도
	        return await getCustomerByNamePhone(user);
	    }
	}
	async function getCustomerByNamePhone(user) {
	    try {
	        const response = await $.ajax({
	            url: '/userContract/rest/' + user.name + '/' + user.phone,
	            method: 'GET'
	        });

	        if (response) {
	            return response;
	        } else {
	            throw new Error('고객이 존재하지 않습니다.');
	        }
	    } catch (error) {
	        throw new Error('고객 조회 실패: ' + (error.responseJSON?.message || error.statusText));
	    }
	}
	/* ==================== 보장내용 체크박스 처리 ==================== */
	// 보장내용 체크박스 생성 함수
	function coverageChk() {
	    const coverageRange = $('.coverage-list li').data('coverage');
	    const riderList = $('.riderList');
	    
	    riderList.empty();
	    if (!coverageRange) {
	        return;
	    }

	    const coverages = coverageRange.split(',').map(c => c.trim());

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
		// 체크박스 선택시 보험료 변경
		$('input[name="contractCoverage"]').on('change', calcPremium);
	}
	// 특약 보험료 누적 함수
	function calcPremium(){
		const basePremium = Number($('#premiumAmount').data('basePremium'));
		console.log('basepremium => '+basePremium);
		const checkedCount = $('input[name="contractCoverage"]:checked').length;
		const extra = basePremium / 3 * checkedCount;
		const total = basePremium + extra;

		$('#premiumAmount').val(Math.floor(total));
	}
	/* ==================== 피보험자 선택 처리 ==================== */
	// 피보험자 본인, 본인 외 선택 처리
	$('#insuredType').on('change', function() {
	    const insuredValue = $(this).val();
		const userName = $('#customerName').val();
		const userId = $('#customerId').val();
		const insuredSelf = `
			<input type="hidden" name="insuredName" id="insuredName"/>                 
	        <input type="hidden" name="insuredId" id="insuredId"/>   
		`;
	    const insuredOther = `
		<div class="infoInner">
	    	<label class="form-label">피보험자 추가정보</label>
	    	<div class="form-group nameInner">
	        	<label class="form-label">이름<span>*</span></label>
	            <input type="text" class="form-control" name="insuredName" id="insuredName" autocomplete="off" required>
				<div class="autocomplete-suggestions insured-suggestions"></div>
	            <input type="hidden" id="insuredId" name="insuredId">
	    	</div>
	    	<div class="form-group">
				<label class="form-label">성별 <span>*</span></label>
				<ul class="gender">
					<li>
						<input type="radio" name="insured_gender" id="insured_gen_male" value="M" checked>
						<label for="insured_gen_male">남자</label>
					</li>
					<li>
						<input type="radio" name="insured_gender" id="insured_gen_female" value="F">
						<label for="insured_gen_female">여자</label>
					</li>
				</ul>
	    	</div>
	    	<div class="form-group">
	        	<label class="form-label">생년월일<span>*</span></label>
	            <input type="date" class="form-control" name="birth_date" id="insured_birth_date" autocomplete="off" required>
	    	</div>
	    	<div class="form-group">
	        	<label class="form-label">핸드폰<span>*</span></label>
	            <input type="tel" class="form-control" name="phone" id="insured_phone" autocomplete="off" required>
	    	</div>
	    	<div class="form-group">
	        	<label class="form-label">이메일<span>*</span></label>
	            <input type="text" class="form-control" name="email" id="insured_email" autocomplete="off" required>
	    	</div>
	    	<div class="form-group">
	        	<label class="form-label">주소<span>*</span></label>
	            <input type="text" class="form-control" name="address" id="insured_address" autocomplete="off" required>
	    	</div>
		</div>
		`;
	    if (insuredValue === 'other') {
	        // 본인 외 선택 시 피보험자 추가 정보 표시
			$('.extraInsuredInfo').empty().append(insuredOther).slideDown(300);
	    } else {
	        // 본인 선택 시 피보험자 추가 정보 숨김
			$('.extraInsuredInfo').empty().append(insuredSelf);
			$('#insuredName').val(userName);
			$('#insuredId').val(userId);
	    }
	});
	// 피보험자 검색처리
	let insuredTimeout;
	let selectedInsured = null;
	
	// 피보험자 검색
	function searchInsured(searchTerm) {
	    $.ajax({
	        url: '/userContract/rest/search/insured',
	        method: 'GET',
	        data: { name: searchTerm },
	        success: function(insuredList) {
	            if (insuredList && insuredList.length > 0) {
	                renderInsuredList(insuredList);
	            } else {
	                removeInsuredList();
	            }
	        },
	        error: function(error) {
	            console.error('피보험자 검색 오류:', error);
	            removeInsuredList();
	        }
	    });
	}
	// 피보험자 목록 렌더링
	function renderInsuredList(insuredList) {
	    // 기존 제안 목록 제거
	    $('.insured-suggestions').empty();
	    
	    const suggestions = $('.autocomplete-suggestions.insured-suggestions');
	    
	    insuredList.forEach(function(insured) {
			var insuredBirth = new Date(insured.birthDate);
			var formatBirthDate = insuredBirth.getFullYear() + '-' 
			                  + String(insuredBirth.getMonth() + 1).padStart(2, '0') + '-' 
			                  + String(insuredBirth.getDate()).padStart(2, '0');
	        const item = $(`
	            <div class="autocomplete-item">
	                <div class="insured-name">${insured.name}</div>
	                <div class="insured-info">${formatBirthDate || ''}&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;${insured.phone || ''}</div>
	            </div>
	        `);
	        
	        item.on('mousedown', function(e) {
				e.preventDefault();
	            selectInsured(insured);
	        });
	        
	        suggestions.append(item);
	    });
	}
	function removeInsuredList() {
	    $('.insured-suggestions').empty();
	}
	// 피보험자 선택
	function selectInsured(insured) {
	    selectedInsured = insured;
	    
	    // 피보험자 정보 입력
	    $('.extraInsuredInfo #insuredName').val(insured.name);
	    $('.extraInsuredInfo #insuredId').val(insured.customerId);
		if (insured.gender === 'M') {
		    $('#insured_gen_male').prop('checked', true);
		} else if (insured.gender === 'F') {
		    $('#insured_gen_female').prop('checked', true);
		}
		var insuredBirth = new Date(insured.birthDate);
		var formatBirthDate = insuredBirth.getFullYear() + '-' 
		                  + String(insuredBirth.getMonth() + 1).padStart(2, '0') + '-' 
		                  + String(insuredBirth.getDate()).padStart(2, '0');
	    $('.extraInsuredInfo #insured_birth_date').val(formatBirthDate || '');
	    $('.extraInsuredInfo #insured_phone').val(insured.phone || '');
	    $('.extraInsuredInfo #insured_email').val(insured.email || '');
	    $('.extraInsuredInfo #insured_address').val(insured.address || '');
	    
	    removeInsuredList();
	}
	// 필드 초기화
	function clearInsuredFields() {
	    $('#insured_gen_male').prop('checked', true);
	    $('.extraInsuredInfo #insured_birth_date').val('');
	    $('.extraInsuredInfo #insured_phone').val('');
	    $('.extraInsuredInfo #insured_email').val('');
	    $('.extraInsuredInfo #insured_address').val('');
	}
	$(document).on('blur', '#insuredName', function() {
	    setTimeout(function() {
	        removeInsuredList();
	    }, 200);
	});
	// 검색이벤트
	$(document).on('input', '#insuredName',function() {
	    const searchTerm = $(this).val().trim();
	    // 기존 선택 초기화
	    if (selectedInsured && selectedInsured.name !== searchTerm) {
	        selectedInsured = null;
	        $('#insuredId').val('');
	        clearInsuredFields();
	    }
	    
	    clearTimeout(insuredTimeout);
	     
	    insuredTimeout = setTimeout(function() {
	        searchInsured(searchTerm);
	    }, 300);
	});
	/* ================================ 계약 등록 처리 ================================ */
	/* 고객번호 생성 */
	async function makeCustomerId(){
		try {
			const maxId = await $.ajax({
				url:'/userContract/rest/newCustomerId',
				method: 'GET'
			});
			const numericPart = parseInt(maxId.replace(/^C/, ''), 10);
			const newNumber = numericPart + 1;
			const newCustomerId = 'C' + String(newNumber).padStart(3, '0');
			return newCustomerId;				
		} catch(error) {
			throw new Error('새 고객 ID 생성 실패: ' + (error.responseJSON?.message || error.statusText));
		}
	}
	/* 고객 등록 분기 처리 */
	async function processCustomer() {
	    const customerId = $('#customerId').val();

	    // 기존 고객인 경우
	    if (customerId) {
	        return customerId;
	    }

	    // 새 고객 등록
		const newCustomerId = await makeCustomerId();
		const customerGender = $('input[name="gender"]:checked').val();
	    const customerData = {
			customerId: newCustomerId,
			loginId: $('#loginId').val().trim(),
	        name: $('#customerName').val().trim(),
	        gender: customerGender,
	        birthDate: $('#birth_date').val(),
	        phone: $('#phone').val().trim(),
	        email: $('#email').val().trim(),
	        address: $('#address').val().trim()
	    };

	    try {
	        const response = await $.ajax({
	            url: '/userContract/rest/registerCustomer',
	            method: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify(customerData)
	        });

	        return response.customerId;
	    } catch (error) {
	        throw new Error('고객 등록 실패: ' + (error.responseJSON?.message || error.statusText));
	    }
	}
	/* 피보험자 분기 처리 */
	async function processInsured() {
	    const insuredId = $('#insuredId').val();

	    // 기존 피보험자인 경우
	    if (insuredId) {
	        return insuredId;
	    }
		const newInsuredId = await makeCustomerId();
		const insuredGender = $('input[name="insured_gender"]:checked').val();
	    // 새 피보험자 등록
	    const insuredData = {
			customerId: newInsuredId,
	        name: $('#insuredName').val().trim(),
	        gender: insuredGender,
	        birthDate: $('#insured_birth_date').val(),
	        phone: $('#insured_phone').val().trim(),
	        email: $('#insured_email').val().trim(),
	        address: $('#insured_address').val().trim()
	    };

	    try {
	        const response = await $.ajax({
	            url: '/userContract/rest/registerInsured',
	            method: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify(insuredData)
	        });

	        return response.insuredId;
	    } catch (error) {
	        throw new Error('피보험자 등록 실패: ' + (error.responseJSON?.message || error.statusText));
	    }
	}
	/* 계약 등록 처리 */
	async function registerContract(customerId, insuredId) {
	    // 선택된 특약 수집
		let contractCoverage = '주계약';
		$('.riderList input[type="checkbox"]:checked').each(function () {
		    contractCoverage += ',' + $(this).val();
		});
	    const contractData = {
	        customerId: customerId,
	        insuredId: insuredId,
	        productId: $('#productId').val(),
			contractCoverage: contractCoverage,
	        regDate: $('#regDate').val(),
	        expiredDate: $('#expiredDate').val(),
	        premiumAmount: $('#premiumAmount').val(),
	        paymentCycle: $('#paymentCycle').val()
	    };

	    try {
	        const response = await $.ajax({
	            url: '/userContract/rest/userRegisterContract',
	            method: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify(contractData)
	        });

	        return response;
	    } catch (error) {
	        throw new Error('계약 등록 실패: ' + (error.responseJSON?.message || error.statusText));
	    }
	}
	/* 계약 최종 처리 */
	async function processContractRegistration() {
	    try {
	        // 1. 고객 처리
	        const customerId = await processCustomer();
	        // 2. 피보험자 처리
	        let insuredId = customerId;
	        if ($('#insuredType').val() === 'other') {
	            insuredId = await processInsured();
	        }
	        // 3. 계약 등록
	        await registerContract(customerId, insuredId);
	        
	        // 성공 처리
	        alert('계약이 성공적으로 등록되었습니다.');
	        closeContractModal();
	        location.reload();
	        
	    } catch (error) {
	        console.error('계약 등록 오류:', error);
	        alert('계약 등록 중 오류가 발생했습니다: ' + (error.message || '알 수 없는 오류'));
	    }
	}
	$('#saveContract').on('click',function(){
		processContractRegistration();
	})
	// 모달 닫기
	$('#contractModal').on('click', '.modal-close, #cancelContract', function() {
		if (confirm('작성 중인 내용이 사라집니다. 계속하시겠습니까?')) {
			closeContractModal();			
		}
	});
	// 모달 닫기 함수
	function closeContractModal(){
		$('#contractModal, #contractModalOverlay').removeClass('active');
		// 모달 닫을 때 내용 초기화
		const userName = $('#customerName').val();
		const userId = $('#customerId').val();
	    const formEl = $('#contractForm')[0];
	    formEl.reset();

	    $('#customerId').val('');
	    $('#insuredId').val('');
	    $('#productId').val('');

	    $('.riderList').empty();

	    $('input[type="checkbox"][value="주계약"]').prop('checked', true);
		const insuredSelf = `
			<input type="hidden" name="insuredName" id="insuredName"/>                 
		    <input type="hidden" name="insuredId" id="insuredId"/>   
		`;
		$('.extraInsuredInfo').empty().append(insuredSelf);
		$('#insuredName').val(userName);
		$('#insuredId').val(userId);
	}
});
