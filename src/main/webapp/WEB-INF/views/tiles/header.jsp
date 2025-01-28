<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<style>
#logout{
    background: #4f4f4f;
    color: #fff;
    padding: 0px 7px;
    border-radius: 7px;
    font-weight: 600;
}

.headerIcon{
	width: 17px;
	margin-bottom: 4px;
}

.header-title h2{
	color: #333;
	font-weight: 600;
}

.header__top__inner {
	padding-top: 0;
}

.header-member{
	color: #999;
	font-weight: 400;
	letter-spacing: -1;
	font-size: 15px;
}

.header-member:hover{
	color: #333;
}

.header__top__right__links a:after {
    top: -3px;
    right: -20px;
}

.header__top__right__links a {
    margin-right: 30px;
}

.header__menu ul li a {
	letter-spacing: -1;
}

.header__logo h2{
	color: #333;
	font-weight: bold;
}

.checkout__input input {
    height: 40px;
}
</style>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
window.onload = function() {
	console.log("${MBER_INFO}");
}
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<header class="header">
    <div class="header__top">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="header__top__inner" style="display: flex; justify-content: space-between;">
                        <div class="col-lg-4">
                        </div>
                        <div class="col-lg-4 header-title" style="align-content: center; text-align: center;">
                            <a href="/main"><img src="/resources/img/main/YOGIJOGI.png" alt="YOGIJOGI" style="width: 245px;"></a>
							
                        </div>
                        <div class="col-lg-4" style="align-content: center; text-align: right;">
                            <div class="header__top__right__links">
                            	<c:choose>
								  	<c:when test="${MBER_INFO == null}">
								  		 <a class="header-member" href="/goLoginForm">
								  		 	<img class="headerIcon" src="/resources/img/main/login.png" alt="">
								  		 	로그인
								  		 </a>
			                             <a class="header-member" href="/goSignUpForm">
			                             	<img class="headerIcon" src="/resources/img/main/member.png" alt="">
			                             	회원 가입
			                             </a>
								  	</c:when>
								  	<c:otherwise>
								  	  <p style="margin: 0; font-size: 15px;">${MBER_INFO.mberNm}님 환영합니다!
								  	  	<a id="logout" class="btn-getstarted" href="/logout" style="">로그아웃</a>
								  	  </p>
								  	</c:otherwise>
								  </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="canvas__open"><i class="fa fa-bars"></i></div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <nav class="header__menu mobile-menu">
                    <ul class="menu-list">
                        <li class="active"><a href="/main">홈페이지</a></li>
                        <li><a href="#">공지사항</a>
                            <ul class="dropdown">
                                <li><a href="/board/rstrntList">1</a></li>
                                <li><a href="./shoping-cart.html">2</a></li>
                                <li><a href="./checkout.html">3</a></li>
                                <li><a href="./wisslist.html">4</a></li>
                                <li><a href="./Class.html">5</a></li>
                            </ul>
                        </li>
                        <li><a href="/board/rstrntList">맛집찾기</a></li>
                        <li><a href="./shop.html">맛집공유</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</header>
<!-- Header Section End -->
</body>
</html>