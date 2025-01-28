<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
.breadcrumb__text h3 {
    font-size: 30px;
    color: #333;
    font-weight: 700;
    font-style: normal;
    font-family: sans-serif;
    text-align: center;
}

.checkout__title{
	letter-spacing: -1;
	color: #333;
	font-weight: bold;
}

.checkout__input span{
	display: inline-block;
	color: #999;
	font-size: 14px;
}

#idCheckBtn, #searchAddrBtn{
/* 	background-color: #f08632; */
	border-radius: 20px;
    font-weight: 600;
    letter-spacing: -1;
}

#signUpBtn{
	border: none;
    height: 40px;
    width: 116px;
    border-radius: 5px;
    color: #fff;
    font-weight: 600;
    background: #f08632;
    font-size: 1.2rem;
}

#mberTel::placeholder{
	color: #bebebe;
}

/* select CSS */
.nice-select{
	width: 100%;
	height: 40px;
	border: solid 1px #ddd;
	border-radius: 0px;
	margin-bottom: 5px;
}

.nice-select .list{
	width: 100%;
}
</style>
<!-- 다음 우편번호 API -->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js" ></script>
<script type="text/javascript">
// 전역 변수
let idChkCount = 0; // 중복 검사 여부

window.onload = function(){
	//이름 정규식 (1~20자 한글)
	let nmReg = /^[가-힣]{1,20}$/;
	// 비밀번호 정규식(영문 대소문자, 숫자, 특수문자 포함한 8~15자리)
	let passReg = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,15}$/;
	// 주민등록번호 정규식
	let IdenNumReg = /^(?:[0-9]{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[1,2][0-9]|3[0,1]))-[1-4][0-9]{6}$/;
	// 전화번호 정규식
	let telReg = /^01([0|1|6|7|8|9|])-([0-9]{3,4})-([0-9]{4})$/;
	// 이메일 정규식
	let mailReg = /^[a-zA-Z0-9_]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
	
	/* 아이디 중복 검사 시작 */
	$("#idCheckBtn").on("click", function(){
		let mberId = document.getElementById("mberId").value;
		let idChkData = document.getElementById("idChkData");
		let inputId = document.getElementById("mberId");
		
		// 아이디를 입력하지 않은 경우
		if(mberId == ""){
			Swal.fire({
				title: '아이디를 입력해 주세요.',
				text: '',
				icon: 'warning',
				confirmButtonText: '확인',
			});
			
			return;
		}
		
		// 아이디 중복 검사
		$.ajax({
			url: "/idCheck",
			type: "GET",
			data: {mberId: mberId},
			dataType: "json",
			success: function(idChkRes){
				if (idChkRes > 0) {
	                idChkData.style.removeProperty("display");
	                inputId.style.setProperty("border", "1px solid #ef7777");
	                inputId.style.setProperty("background", "#fff");
	                inputId.style.setProperty("margin-bottom", "0");
	            } else { // 아이디가 중복되지 않는 경우
	            	idChkCount = 1; // 아이디 중복 검사 완료되면 1
	                idChkData.style.setProperty("display", "none");
	                inputId.style.setProperty("margin-bottom", "20");
	                inputId.style.setProperty("border", "1px solid #ddd");
	                inputId.style.setProperty("background", "#e8f0fe");
	            }
			}
		});
	});
	/* 아이디 중복 검사 끝 */
	
	/* 아이디 입력하면 중복 검사 여부 초기화 */
	$("#mberId").on("input", function(){
		idChkCount = 0;
	});
	
	/* 비밀번호 input 이벤트 시작 */
	$("#password, #passwordChk").on("input", function(){
		let inputPass = document.getElementById("password");
		let inputPassChk = document.getElementById("passwordChk");
		let passChkData = document.getElementById("passChkData");
		
		let password = document.getElementById("password").value;
		let passwordChk = document.getElementById("passwordChk").value;
		
		// 비밀번호가 일치하고, 정규식에 맞는 경우
		if(password == passwordChk && passReg.test(password)){
			inputPass.style.setProperty("border", "1px solid #ddd");
			inputPass.style.setProperty("background", "#e8f0fe");
			inputPassChk.style.setProperty("border", "1px solid #ddd");
			inputPassChk.style.setProperty("background", "#e8f0fe");
			inputPassChk.style.setProperty("margin-bottom", "20");
			passChkData.style.setProperty("display", "none");
		}else{
			inputPass.style.setProperty("border", "1px solid #ef7777");
			inputPass.style.setProperty("background", "#fff");
			inputPassChk.style.setProperty("border", "1px solid #ef7777");
			inputPassChk.style.setProperty("background", "#fff");
			passChkData.style.removeProperty("display");
			inputPassChk.style.setProperty("margin-bottom", "0");
		}
	});
	/* 비밀번호 입력 시 CSS 변경 이벤트 시작 */
	
	/* 이름 input 이벤트 시작 */
	$("#mberNm").on("input", function(){
		let inputNm = document.getElementById("mberNm");
		let mberNm = document.getElementById("mberNm").value;
		
		if(nmReg.test(mberNm)){
			inputNm.style.setProperty("border", "1px solid #ddd");
			inputNm.style.setProperty("background", "#e8f0fe");
		}else{
			inputNm.style.setProperty("border", "1px solid #ef7777");
			inputNm.style.setProperty("background", "#fff");
		}
	});
	/* 이름 input 이벤트 끝 */
	
	/* 전화번호 input 이벤트 시작 */
	$("#mberTel").on("input", function(){
		let inputTel = document.getElementById("mberTel");
		let mberTel = document.getElementById("mberTel").value;
		
		if(telReg.test(mberTel)){
			inputTel.style.setProperty("border", "1px solid #ddd");
			inputTel.style.setProperty("background", "#e8f0fe");
		}else{
			inputTel.style.setProperty("border", "1px solid #ef7777");
			inputTel.style.setProperty("background", "#fff");
		}
	});
	/* 전화번호 input 이벤트 끝 */
	
	/* 주소 input 이벤트*/
	$("#mberAddr").on("change", function(){
		let inputAddr = document.getElementById("mberAddr");
		inputAddr.style.setProperty("background", "#e8f0fe");
	});
	
	/* 이메일 input 이벤트*/
	$("#mberEmail1").on("change", function(){
		let inputMail = document.getElementById("mberEmail1");
		inputMail.style.setProperty("background", "#e8f0fe");
	});
	
	/* 이메일 select 선택 이벤트 시작 */
	$("#mailSelect").on("change", function(){
		let mberEmail2 = document.getElementById("mberEmail2");
		let mailSelect = document.getElementById("mailSelect");
		let mailOption = mailSelect.options[mailSelect.selectedIndex].value;
		
		if(mailOption != "직접 입력"){
			mberEmail2.readOnly = true;
			document.getElementById("mberEmail2").value = mailOption;
		}else{
			mberEmail2.readOnly = false;
			document.getElementById("mberEmail2").value = "";
		}
	});
	/* 이메일 select 선택 이벤트 끝 */
	
	/* 회원 가입 시작 */
	$("#signUpBtn").on("click", function(){
		let mberId = document.getElementById("mberId").value;
		let password = document.getElementById("password").value;
		let passwordChk = document.getElementById("passwordChk").value;
		let mberNm = document.getElementById("mberNm").value;
		let mberAddr = document.getElementById("mberAddr").value;
		let mberTel = document.getElementById("mberTel").value;
		let mberEmail1 = document.getElementById("mberEmail1").value;
		let mberEmail2 = document.getElementById("mberEmail2").value;
		let mberEmail = mberEmail1 + "@" + mberEmail2;
		let ihidnum1 = document.getElementById("ihidnum1").value;
		let ihidnum2 = document.getElementById("ihidnum2").value;
		let ihidnum = ihidnum1 + "-" + ihidnum2;
		
		// 필수 정보 입력란 누락 검사
		if(password == "" ||
		   passwordChk == "" ||
		   mberId == "" ||
		   mberAddr == "" ||
		   mberTel == "" ||
		   mberEmail1 == ""){
			Swal.fire('회원 가입 실패ㅠㅠ', '필수 입력 사항을 입력해 주세요.', 'error');
			
			return;
		}
		
		// 아이디 중복 여부 검사
		if(idChkCount == 0){
			Swal.fire('회원 가입 실패ㅠㅠ', '아이디 중복 검사가 완료되지 않았습니다.', 'error');
			return;
		}
		
		/* 정규식 검사 시작 */
		// 비밀번호 유효성 검사
		if(password != passwordChk && !passReg.test(password)){
			Swal.fire('회원 가입 실패ㅠㅠ', '비밀번호를 다시 확인해 주세요.', 'error');
			return;
		}
		
		// 주민등록번호 유효성 검사
		if(!IdenNumReg.test(ihidnum)){
			Swal.fire('회원 가입 실패ㅠㅠ', '주민등록번호를 다시 확인해 주세요.', 'error');
			return;
		}

		// 이름 검사
		if(!nmReg.test(mberNm)){
			Swal.fire('회원 가입 실패ㅠㅠ', '이름을 다시 확인해 주세요.', 'error');
			return;
		}
		
		// 전화번호 검사
		if(!telReg.test(mberTel)){
			Swal.fire('회원 가입 실패ㅠㅠ', '전화번호를 다시 확인해 주세요.', 'error');
			return;
		}
		
		// 이메일 검사
		if(!mailReg.test(mberEmail)){
			Swal.fire('회원 가입 실패ㅠㅠ', '이메일을 다시 확인해 주세요.', 'error');
			return;
		}
		/* 정규식 검사 끝 */
		
		let data = {
			"mberId": mberId,
			"password": password,
			"mberNm": mberNm,
			"ihidnum": ihidnum,
			"mberAddr": mberAddr,
			"mberTel": mberTel,
			"mberEmail": mberEmail
		}
		
		$.ajax({
			url: "/signUp",
			contentType: "application/json; charset=utf-8",
			type: "POST",
			data: JSON.stringify(data),
			dataType: "json",
			success: function(res){
				if(res > 0){
					Swal.fire({
					   title: '회원 가입 완료!',
					   text: '메인으로 돌아갑니다.',
					   icon: 'success',
					   confirmButtonText: '확인',
					}).then(result => {
						if(result.isConfirmed){
							location.href = "/main";
						}
					});
				}
			}
		});
	});
	
	// 주소 찾기
	$("#searchAddrBtn").on("click", function(){
		new daum.Postcode({
			oncomplete : function(data) {
		        $("#mberAddr").val(data.address + " ");
		        $("#mberAddr").focus();
			}
		}).open();
	});
};
</script>
<meta charset="UTF-8">
<title>회원 가입</title>
</head>
<body>
<div class="breadcrumb-option" style="padding-top: 100px;">
    <div class="container">
        <div class="row" style="justify-content: center;">
            <div class="col-lg-4 col-md-4 col-sm-4">
                <div class="breadcrumb__text">
                    <h3>회원 가입</h3>
                </div>
            </div>
        </div>
    </div>
</div>

<section class="checkout spad" style="padding-top: 50px;">
    <div class="container">
        <div class="checkout__form">
            <form id="signUpForm" action="/signUp" method="POST">
                <div class="row" style="justify-content: center;">
                    <div class="col-lg-6 col-md-6">
                        <h6 class="coupon__code">
                        	<span class="icon_tag_alt"></span> 필수 입력 정보(*)를 모두 입력해 주세요.
                        </h6>
                        <div class="row">
                            <div class="col-lg-9">
                                <div class="checkout__input">
                                    <span>아이디</span><span style="color: #f08632">*</span>
                                    <input id="mberId" name="mberId" type="text">
                                    <span id="idChkData" style="color: #ef7777; font-size: 13px; display: none;">중복된 아이디입니다.</span>
                                </div>
                            </div>
                            <div class="col-lg-3" style="align-content: center;">
                            	<div class="checkout__input">
                                	<input id="idCheckBtn" type="button" value="중복 검사" style="margin-bottom: 0; padding-left: 6px;">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="checkout__input">
                                    <span>비밀번호</span>
                                    <span style="display: inline-block; color: #f08632">*</span>
                                    <span style="display: inline-block; font-size: 10px; display: inline-block; width: 86.7%; text-align: right;">
                                    (영문 대소문자, 숫자, 특수문자를 포함한 8~15자리)</span>
                                    <input id="password" name="password" type="password">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="checkout__input">
                                    <span>비밀번호 확인</span><span style="display: inline-block; color: #f08632">*</span>
                                    <input id="passwordChk" type="password">
                                    <span id="passChkData" style="color: #ef7777; font-size: 13px; display: none;">비밀번호가 일치하지 않거나 형식에 맞지 않습니다.</span>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="checkout__input">
                                    <span>주민등록번호</span><span style="display: inline-block; color: #f08632">*</span>
                                    <input id="ihidnum1" type="text">
                                </div>
                            </div>
                            <span style="position: absolute; right: 287px; bottom: 388px; display: inline-block; color: #999;">-</span>
                            <div class="col-lg-6" style="align-content: center;">
                            	<div class="checkout__input">
	                            	<input id="ihidnum2" type="password" style="margin-bottom: 0;">
	                            </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="checkout__input">
                                    <span>이름</span><span style="display: inline-block; color: #f08632">*</span>
                                    <input id="mberNm" name="mberNm" type="text">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="checkout__input">
                                    <span>전화번호</span><span style="display: inline-block; color: #f08632">*</span>
                                    <span style="display: inline-block; font-size: 10px; display: inline-block; width: 87.7%; text-align: right;">
                                    ('-'를 포함해서 입력)</span>
                                    <input id="mberTel" name="mberTel" type="text" placeholder="010-1234-5678">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-9">
                                <div class="checkout__input">
                                    <span>주소</span><span style="color: #f08632">*</span>
                                    <input id="mberAddr" name="mberAddr" type="text">
                                </div>
                            </div>
                            <div class="col-lg-3" style="align-content: center;">
                            	<div class="checkout__input">
                                	<input id="searchAddrBtn" type="button" value="주소 찾기" style="margin-bottom: 0; padding-left: 6px;">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="checkout__input">
                                    <span>이메일</span><span style="display: inline-block; color: #f08632">*</span>
                                    <input id="mberEmail1" type="text">
                                </div>
                            </div>
                            <div class="checkout__input" style="align-content: center; position: absolute; left: 189px; bottom: 31px;">
                                 <span>@</span>
                            </div>
                            <div class="col-lg-4" style="align-content: center;">
                                <div class="checkout__input">
                                    <input id="mberEmail2" type="text" style="margin-bottom: 0;">
                                </div>
                            </div>
                            <div class="col-lg-4" style="align-content: center;">
                                <div class="checkout__input">
                                	<select id="mailSelect" style="width: 100%; height: 40px; border: 1px solid #ddd;">
                                		<option value="직접 입력" selected>직접 입력</option>
                                		<option value="naver.com">naver.com</option>
                                		<option value="nate.com">nate.com</option>
                                		<option value="daum.net">daum.net</option>
                                		<option value="gmail.com">gmail.com</option>
                                	</select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="text-align: center; margin-top: 40px;">
                	<input id="signUpBtn" type="button" value="가입하기">
                </div>
            </form>
        </div>
    </div>
</section>
</body>
</html>