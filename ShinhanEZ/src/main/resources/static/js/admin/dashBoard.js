// 대쉬보드 상단 카운트바
const usercountcontainer = document.querySelector('.allusercount h3');
const customercountcontainer = document.querySelector('.allcustomercount h3');
const contractcountcontainer = document.querySelector('.allcontractcount h3');
const boardcountcontainer = document.querySelector('.allboardcount h3');

function dashBoardCount() {
	fetch('/admin/dashboard/api/allcount')
	.then(res => res.json())
	.then(counts => {
		
		usercountcontainer.innerText=counts['allusers'];
		customercountcontainer.innerText=counts['allcustomers'];
		contractcountcontainer.innerText=counts['allcontracts'];
		boardcountcontainer.innerText=counts['allboards'];
	})
	.catch(error => console.error('Error:', error)); 
		
}
dashBoardCount();



// 대쉬보드 차트
const container = document.getElementById('yearSelect');
let chart;
let chart2;

function yearBtnCreate() {
	fetch('/admin/dashboard/api/yearlist')
	.then(res => res.json())
	.then(years => {	    
	    
	    const option = document.createElement('option');
	    const latestYear = Math.max(...years.map(y => parseInt(y)));
	    years.forEach(year => {
	        const option = document.createElement('option');
	        option.value = year;
            option.text = year;
            if(parseInt(year) === latestYear) {
                option.selected = true;
            }
	        container.appendChild(option);
	    });
	    changeYear(latestYear);
	    changeYear2(latestYear);
	})
	.catch(error => console.error('Error:', error));
}

yearBtnCreate();

// 월별 계약 수 차트
let monthLabels=[];
let monthData=[];
chart=new Chart(document.getElementById('barChart'), {
    type: 'bar',
    data: {
        labels: monthLabels,
        datasets: [{
            label: '계약 수',
            data: monthData,
            backgroundColor: [ '#ffc107','#0d6efd','#198754','#fd7e14', '#6f42c1','#0dcaf0','#d63384','#adb5bd', '#6610f2','#fd198c','#198754','#0d6efd' ]
        }]
    },
    options: { 
        responsive: true,
        plugins: { legend: { display: false } },
	scales: {
	            y: {
	                beginAtZero: true, // 0부터 시작
	                ticks: {
	                    stepSize: 1,   // 1단위로 증가 (소수점 제거 핵심)
	                    precision: 0   // 강제로 소수점 없애기 (안전장치)
	                }
	            }
	        }	
    }
});

function changeYear(year){
	if(!year) return;
	fetch(`/admin/dashboard/api/list2?year=${year}`)
	.then(res => res.json())
	.then(list => {
		monthLabels.length = 0;
      	monthData.length = 0;
      	
		list.forEach(i => {
			monthLabels.push(i.regDate);
			monthData.push(i.count);
	    });
		chart.update();
		
		})
	    .catch(err => console.error(err));	
}

container.addEventListener("change", e => changeYear(e.target.value));


	
// 상품별 계약 분포 차트	
let productLabels=[];
let productData=[];

chart2=new Chart(document.getElementById('pieChart'), {
    type: 'pie',
    data: {
        labels: productLabels,
        datasets: [{
            data: productData,
            backgroundColor: [ '#ffc107','#0d6efd','#198754','#fd7e14', '#6f42c1','#0dcaf0','#d63384','#adb5bd', '#6610f2','#fd198c','#198754','#0d6efd' ]
        }]
    },
    options: { responsive: true }
});

function changeYear2(year){
	if(!year) return;
	fetch(`/admin/dashboard/api/list?year=${year}`)
	.then(res => res.json())
	.then(list => {
		productLabels.length = 0;
		productData.length = 0;
      	
		list.forEach(i => {
			productLabels.push(i.productName);
			productData.push(i.count);
	    });
		chart2.update();
		
		})
	    .catch(err => console.error(err));	
}
container.addEventListener("change", e => changeYear2(e.target.value));


const allConstractsContainer = document.getElementById('allConstracts');
const allNoticeContainer = document.getElementById('allBoards');


// 하단 최근 게시판 페이지 로드 시 자동으로 1페이지 요청 
document.addEventListener("DOMContentLoaded", () => {
    loadCurrentContractBoard(1);
	loadCurrentNoticeBoard(1);
});


// 최근 계약자 게시판 로드
function loadCurrentContractBoard(pageNum = 1) {
    fetch(`/admin/dashboard/api/allconstracts?pageNum=${pageNum}`)
        .then(res => res.json())
        .then(data => {
            renderList(data.list);     // 리스트 그리기
            renderPaging(data.paging); // 페이징 버튼 그리기
        })
        .catch(err => console.error("Error loading board:", err));
}

// 최근 공지사항 게시판 로드
function loadCurrentNoticeBoard(pageNum = 1) {
    fetch(`/admin/dashboard/api/allboards?pageNum=${pageNum}`)
        .then(res => res.json())
        .then(data => {
            renderList2(data.list);     // 리스트 그리기
            renderPaging2(data.paging); // 페이징 버튼 그리기
        })
        .catch(err => console.error("Error loading board:", err));
}



// 최근 계약자 리스트 렌더링 함수
function renderList(list) {
    
    let html = "";    

    list.forEach(i => {
        html += 
		`<tr onclick="location.href='/admin/contract/view?contractId=${i.contractId}'" style="cursor:pointer;">
						            <td>${i.id}</td>
						            <td>${i.cusName}</td>
						            <td>${i.insurName}</td>
						            <td>${i.productName}</td>
						            <td>${i.regDate}</td>
						            <td><span class="badge badge-primary">${i.status}</span></td>
						        </tr>`;
    });

    allConstractsContainer.innerHTML = html;
}


// 최근 계약자 페이징 렌더링 함수
function renderPaging(p) {
    const div = document.getElementById("constractspagination");
    let html = "";

    if (p.hasPrev) {
        html += `<button onclick="loadBoard(${p.pageNum - 1})">&lt;</button> `;
    }

    for (let i = p.startPage; i <= p.endPage; i++) {
        if (i === p.pageNum) {
            html += `<button class="active" disabled>${i}</button> `;
        } else {
            html += `<button onclick="loadBoard(${i})">${i}</button> `;
        }
    }

    if (p.hasNext) {
        html += `<button onclick="loadBoard(${p.pageNum + 1})">&gt;</button>`;
    }

    div.innerHTML = html;
}



// 최근 공지사항 렌더링 함수
function renderList2(list) {
    let html = "";    
    list.forEach(i => {
        html += 
		`<tr onclick="location.href='/admin/notice/view?idx=${i.lineNum}'" style="cursor:pointer;">
						            <td>${i.lineNum}</td>
						            <td>${i.title}</td>
						            <td>${i.id}</td>
						            <td>${i.regDate}</td>
						        </tr>`;
    });
    allNoticeContainer.innerHTML = html;
}


// 최근 공지사항 페이징 렌더링 함수
function renderPaging2(p) {
    const div = document.getElementById("noticepagination");
    let html = "";

    if (p.hasPrev) {
        html += `<button onclick="loadBoard(${p.pageNum - 1})">&lt;</button> `;
    }

    for (let i = p.startPage; i <= p.endPage; i++) {
        if (i === p.pageNum) {
            html += `<button class="active" disabled>${i}</button> `;
        } else {
            html += `<button onclick="loadBoard(${i})">${i}</button> `;
        }
    }

    if (p.hasNext) {
        html += `<button onclick="loadBoard(${p.pageNum + 1})">&gt;</button>`;
    }

    div.innerHTML = html;
}








