<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
h3{
    font-size: 35px;
}

.hero__text span{
	font-size: 2.0rem;
	font-weight: bold;
	letter-spacing: -2px;
}
.hero__text p{
	letter-spacing: -1.5px;
}
.hero__text a{
	border-radius: 30px;
	letter-spacing: -1.5px;
}

.main-food-img{
	height: 200px;
	object-fit: cover;
}
</style>
<head>
<meta charset="UTF-8">
<title>YOGIJOGI</title>
</head>
<body>
<section class="hero">
	<div class="hero__slider owl-carousel">
		<div class="hero__item set-bg" data-setbg="/resources/img/main/steak.jpg">
			<div class="container">
				<div class="row d-flex justify-content-center">
					<div class="col-lg-8">
						<div class="hero__text" style="background-color: rgb(255, 255, 255, 0.83);">
							<span style="color: #f08632;">대전<span style="color: #333">에서 맛집을 찾고 있으신가요?</span></span>
							<p>엄선한 최고의 맛집만을 보여드립니다!</p>
							<a href="/board/rstrntList" class="primary-btn" style="z-index: 999;">맛집 요기조기 찾으러 가기</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<section class="instagram spad">
	<div class="container">
		<div class="row">
			<div class="col-lg-4 p-0">
				<div class="instagram__text">
					<div class="section-title">
						<span style="letter-spacing: -1.5;">대전에서 어디 가지?</span>
						<h3 style="color: #333; font-weight: 600; letter-spacing: -1;">대전에 숨은 맛집이<br>이렇게 많습니다!</h3>
					</div>
					<h5>
						<i class="fa fa-instagram"></i>
					</h5>
				</div>
			</div>
			<div class="col-lg-8">
				<div class="row">
					<div class="col-lg-4 col-md-4 col-sm-4 col-6">
						<div class="instagram__pic">
							<img class="main-food-img" src="/resources/img/main/main-food1.jpg" alt="">
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-4 col-6">
						<div class="instagram__pic middle__pic">
							<img class="main-food-img" src="/resources/img/main/main-food2.jpg" alt="">
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-4 col-6">
						<div class="instagram__pic">
							<img class="main-food-img" src="/resources/img/main/main-food3.jpg" alt="">
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-4 col-6">
						<div class="instagram__pic">
							<img class="main-food-img" src="/resources/img/main/main-food4.jpg" alt="">
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-4 col-6">
						<div class="instagram__pic middle__pic">
							<img class="main-food-img" src="/resources/img/main/main-food5.jpg" alt="">
						</div>
					</div>
					<div class="col-lg-4 col-md-4 col-sm-4 col-6">
						<div class="instagram__pic">
							<img class="main-food-img" src="/resources/img/main/main-food6.jpg" alt="">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
</body>
</html>