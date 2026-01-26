/* ajax 모듈 */
let adminService = (function(){
	
	/* 관리자 목록 조회 */
	function getList(params, callback, error) { 
		$.ajax({ 
			url: '/admin/employee/rest', 
			type: 'GET', 
			data: params, 
			dataType: 'json', 
			success: function(response) { 
				if (response) { 
					if (callback) { 
						callback(
							response.paging,
							response.allList,
							response.paging.pagingObj.totalDB
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
	
	/* 관리자 등록 */
	function save(contract, callback, error){ 
		$.ajax({
			type: "post",
			url: "/admin/employee/rest/register",
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
	
	/* 관리자 단건 */
	function get(adminIdx, callback, error) {
		$.ajax({
			type: "get",
			url: "/admin/employee/rest/" + adminIdx,
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
	
	/* 관리자 수정  */
	function update(admin, callback, error) {
		$.ajax({
			type: "put",
			url: "/admin/employee/rest/modify/" + admin.adminIdx,
			data: JSON.stringify(admin),
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
	/* 관리자 삭제  */
	function deleteAdmin (adminIdx, callback, error) {
		$.ajax({
			type: "DELETE",
			url: "/admin/employee/rest/delete/" + adminIdx,
			success: function (result, status, xhr) {
				if (callback) {
					callback(result);
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
		let dateObj = new Date(timeValue.replace(' ', 'T')); 
		let today = new Date();
		let gap = today.getTime() - dateObj.getTime();
		if(gap < (1000 * 60 * 60 * 24)) { 
			let hh = dateObj.getHours();
			let mi = dateObj.getMinutes();
			let ss = dateObj.getSeconds();
			return [ (hh > 9 ? '' : '0') + hh, '시간 ', (mi > 9 ? '' : '0') + mi, '분 ', '전' ].join('');
		}else {
			let yy = dateObj.getFullYear();
			let mm = dateObj.getMonth() + 1;
			let dd = dateObj.getDate();
			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/', (dd > 9 ? '' : '0') + dd ].join('');
		}
	}
	
	
	return {
		getList: getList,
		save: save,
		get: get,
		update: update,
		deleteAdmin: deleteAdmin,
		displayTime: displayTime
	};
})();