$(document).ready(()=>{
	/* ajax 모듈 */
	let contractService = (function(){
		
		/* 계약 목록 조회 */
		function getList(param, callback, error) {
			let pageNum = param.pageNum || 1;
			let pageSize = param.pageSize || 10;
			$.getJSON("/admin/contract/rest"+"?pageNum="+pageNum+"&pageSize="+pageSize, 
				function (data) {
					if (callback) {
						callback(data.paging, data.allList);
					}
			}).fail(function (xhr, status, err) {
					if (error) {
						error();
				}
			});
		}
		
		/* 계약 단건 읽기 */
		function get(rno, callback, error) {
			$.ajax({
				type: "get",
				url: "/replies/" + rno + ".json",
				success: function (result, status, xhr) {
					if (callback) {
						callback(result);
					}
				},
				error: function (xhr, status, er) {
					if (error) {
						error(er);
					}
				},
			});
		}
		
		/* 계약 등록 */
		function add(reply, callback, error){ 
			$.ajax({
				type: "post",
				url: "/replies/new",
				data: JSON.stringify(reply),
				contentType: "application/json; charset=utf-8",
				success: function (result, status, xhr) {
					if (callback) {
					callback(result);
					}
				},
				error: function (xhr, status, er) {
					if (error) {
						error(er);
					}
				},
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
			add: add,
			getList: getList,
			update: update,
			get: get,
			displayTime: displayTime,
		};
	})();
	
	/* ajax 처리 */
	/* 계약 목록 조회 */
	let listBody = $(".contractContent");
	showList(1,10);

	function showList(pageNum, pageSize) {
		contractService.getList(
	    {
	       pageNum : pageNum,
		   pageSize : pageSize
	    },
	    function(paging,allList) {
			let totalCount = $(".totalContractInner");
			totalCount.html(paging.totalDB);
			let row = "";
			if ( !allList || allList.length === 0) {
				listBody.html("");
				return;
			}
			for (let i=0; i<allList.length; i++) {
				row += `
					<tr>
						<td>${allList[i].contractId}</td>
						<td>${allList[i].customerName}</td>
						<td>${allList[i].insuredName}</td>
						<td>${allList[i].productName}</td>
						<td>${contractService.displayTime(
							allList[i].regDate)}</td>
						<td>${contractService.displayTime(
							allList[i].expiredDate)}</td>
						<td><span class="statusTd">${allList[i].contractStatus}</span></td>
						<td>${contractService.displayTime(
							allList[i].updateDate)}</td>
						<td>${allList[i].adminName}</td>
					</tr>
				`;
			}
			listBody.html(row);          
			showContractPage(paging)
	    });
	} // /showList
	
	/* 페이징 처리 */
	let contractPageFooter = $(".contract-pagination");
	       
	function showContractPage(paging){
		let pg = "";
	            
		if(paging.hasPrev){
			pg+= '<li><a href="'+(paging.paging.startPage -1)+'">&laquo;</a></li>';
		}
	            
		for(let i = paging.paging.startPage ; i <= paging.paging.endPage; i++){
	              
			let active = paging.paging.pageNum == i? "active":"";
	              
			pg+= '<li><a href="'+i+'" class="'+active+'">'+i+'</a></li>';
		}
	            
		if(paging.hasNext){
			pg+= '<li><a href="'+(paging.paging.endPage + 1)+'">&raquo;</a></li>';
		}	            
		contractPageFooter.html(pg);
	}
	/* 페이징 링크 처리 */
	contractPageFooter.on("click","li a", function(e){
		e.preventDefault();
		let targetPageNum = $(this).attr("href");
		pageNum = targetPageNum;
		showList(pageNum, 10);
	});

	
	
	
}); // /documnet.ready
