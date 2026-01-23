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
	
	/* 계약 단건 읽기 */
	function get(contractId, callback, error) {
		$.ajax({
			type: "get",
			url: "/admin/contract/rest/" + contractId,
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
			url: "/admin/contract/rest/register",
			data: JSON.stringify(contract),
			contentType: "application/json; charset=utf-8",
			success: function (result, status, xhr) {
				if (callback) {
					callback(result);
				} else { 
					if (error) error(response.message || '저장실패'); 
				} 
			},
			error: function(xhr) {
			    let msg = '서버 오류가 발생했습니다.';

			    if (xhr.responseJSON && xhr.responseJSON.message) {
			        msg = xhr.responseJSON.message;
			    }

			    if (error) error(msg);
			}
		});
	}
   
	/* 계약 수정  */
	function update(contract, callback, error) {
		$.ajax({
			type: "put",
			url: "/admin/contract/rest/update/" + contract.contractId,
			data: JSON.stringify(contract),
			contentType: "application/json; charset=utf-8",
			success: function (result, status, xhr) {
				if (callback) {
					callback(result);
				} else { 
					if (error) error(response.message || '저장실패'); 
				} 
			},
			error: function(xhr) {
			    let msg = '서버 오류가 발생했습니다.';

			    if (xhr.responseJSON && xhr.responseJSON.message) {
			        msg = xhr.responseJSON.message;
			    }

			    if (error) error(msg);
			}
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
	
	/* 자동완성 모듈 */
	function ajaxAutoComplete (url, params, success, error) {
	    $.ajax({
	        url: url,
	        type: 'GET',
	        data: params,
	        dataType: 'json',
	        success: function (res) {
	            if (success) {
	                success(res);
	            }
	        },
	        error: function (xhr, status, error) {
	            console.error('[Autocomplete AJAX Error]', error);
	            if (error) {
	                error(xhr, status, error);
	            }
	        }
	    });
	}
	/* 상품번호 이용 보험 정보 가져오기 */
	function getProductById(productId, success, error){
		$.ajax({
	        url: '/admin/contract/search/insurances/'+productId,
	        type: 'GET',
	        dataType: 'json',
	        success: function (res) {
	            if (success) {
	                success(res);
	            }
	        },
	        error: function (xhr, status, error) {
	            if (error) {
	                error(xhr, status, error);
	            }
	        }
	    });
	}
	
	return {
		getList: getList,
		get: get,
		save: save,
		update: update,
		displayTime: displayTime,
		ajaxAutoComplete: ajaxAutoComplete,
		getProductById: getProductById
	};
})();