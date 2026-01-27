// 대쉬보드 상단 카운트바
const usercountcontainer = document.querySelector('.allusercount h3');
const customercountcontainer = document.querySelector('.allcustomercount h3');
const contractcountcontainer = document.querySelector('.allcontractcount h3');

function dashBoardCount() {
	fetch('/admin/dashboard/api/allcount')
	.then(res => res.json())
	.then(counts => {
		
		usercountcontainer.innerText=counts['allusers'];
		customercountcontainer.innerText=counts['allcustomers'];
		contractcountcontainer.innerText=counts['allcontracts'];
	})
	.catch(error => console.error('Error:', error)); 
		
}

dashBoardCount();


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




let monthLabels=[];
let monthData=[];
// 월별 계약 수 차트
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
        plugins: { legend: { display: false } }
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


	
	
let productLabels=[];
let productData=[];


// 상품별 계약 분포 차트
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