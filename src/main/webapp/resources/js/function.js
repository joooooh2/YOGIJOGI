/**
 * 함수 모음 
 */
 
// 날짜 포맷 함수
function dateFormat(date){
	var selectDate = new Date(date);
	var d = selectDate.getDate();
	var m = selectDate.getMonth() + 1;
	var y = selectDate.getFullYear();
   
	if(m < 10) m = "0" + m;
	if(d < 10) d = "0" + d;
   
	return y + "-" + m + "-" + d; 
};

// 확인만 있는 alert 함수(reload)
function confirmAlert1(title, text, icon){
	Swal.fire({
	   title: title,
	   text: text,
	   icon: icon,
	   confirmButtonText: '확인',
	}).then(result => {
		if(result.isConfirmed){
			location.reload();
		}
	});
}

// 확인만 있는 alert 함수(rstrntList)
function confirmAlert2(title, text, icon){
	Swal.fire({
	   title: title,
	   text: text,
	   icon: icon,
	   confirmButtonText: '확인',
	}).then(result => {
		if(result.isConfirmed){
			location.href = "/board/rstrntList";
		}
	});
}
