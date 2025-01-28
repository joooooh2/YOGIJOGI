<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
h3{
	font-family: sans-serif;
	font-weight: bold;
}

.spad {
    padding-top: 130px;
}

.chefs .team-member .member-info {
   padding: 50px 15px 20px 15px;
}

input::placeholder {
    font-size: 13px;
    font-family: sans-serif;
    color: #999;
}

.input-info{
	border: 1px solid #ccc;
    border-radius: 3px;
    padding: 5px;
}

.class__form form input {
	margin-bottom: 30px;
}

.login-container{
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
}

#loginBtn{
	background: #333;
    color: #fff;
    font-size: 18px;
    text-align: center;
}
</style>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
window.onload = function() {
	let loginBtn = document.querySelector("#loginBtn");
	
	loginBtn.addEventListener("click", function() {
	    let mberId = document.querySelector("#mberId").value;
	    let password = document.querySelector("#password").value;
	    
	    let data = {
	        "mberId": mberId,
	        "password": password
	    }
	    
	    /* 로그인 */
        $.ajax({
            url: "/login",
            contentType: "application/json;charset=utf-8",
            type: "POST",
            data: JSON.stringify(data),
            dataType: "json",
            success: function(res) {
				if(res == 1){ // 로그인 성공
					location.href = "/main";
				}else{ // 로그인 실패
					Swal.fire('로그인 실패!', '비밀번호가 일치하지 않거나 존재하지 않는 회원입니다.', 'error');
					return;
				}
            }
        });
    });
}
</script>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
<section class="class spad">
    <div class="container" style="display: flex; justify-content: center;">
        <div class="col-lg-5">
            <div class="class__form">
            	<div class="login-container" style="background: #fff; padding: 40px 60px; height: 420px;">
	                <div class="section-title" style="text-align: center;">
	                    <h3>YOGIJOGI</h3>
	                </div>
	                <form action="#">
	                    <input id="mberId" type="text" placeholder="아이디" style="border: 1px solid #ddd;">
	                    <input class="form-control" id="password" type="password" placeholder="비밀번호" style="border: 1px solid #ddd;">
	                    <button id="loginBtn" class="site-btn" type="button" style="margin-top: 10px;">로그인</button>
	                	<p style="font-size: 14px; color: #999; text-align: center; margin-top: 9px;">아직 회원이 아니신가요?
	                		<span onclick="location.href='/goSignUpForm'" style="display: inline-block; margin-left: 5px; border-bottom: 1px solid #555; color: #555; cursor: pointer;">가입하러 가기</span>
	                	</p>
	                </form>
            	</div>
            </div>
        </div>
    </div>
</section>
</body>
</html>