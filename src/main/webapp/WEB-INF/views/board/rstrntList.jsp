<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<style>
.rstrnt_sort {
	font-size: 16px;
	color: #999;
}

.no-rstrnt{
	align-content: center;
    width: 100%;
    height: 300px;
}

.categories__item__icon h5 {
    letter-spacing: -1.5;
}

.spad{
	padding-bottom: 30px;
}

#insertRstrntBtn{
    padding: 5px;
    text-align: center;
    width: 70px;
    border: none;
    border-radius: 5px;
    background: #333;
    color: #fff;
    font-weight: 600;
    font-size: 17px;
}

#insertRstrntBtn:hover{
    background: #666;
}

/* 맛집 리스트 CSS 시작 */
.product__item {
    margin-bottom: 30px;
}

.product__item__pic {
	height: 370px;
}

.product__item__text {
    padding-top: 0;
}

.product__item__text h6 a {
    color: #333;
    font-size: 1.1rem;
}

.product__item__text h6 {
    margin-bottom: 0;
}
/* 맛집 리스트 CSS 끝 */
</style>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
<script type="text/javascript">
// 전역 변수
var currentPage = "${param.currentPage}"; 	// 현재 페이지
var rstrntSort = "${rstrntSort}"; 			// 음식점 분류
var mberAuth = "${MBER_INFO.mberAuth}"; 	// (세션)회원 권한

window.onload = function() {
    // 음식점 리스트 불러오기(디폴트: 한식)
    getRstrntList(rstrntSort);
	
 	// 음식점 분류에 맞는 음식점 리스트 불러오기
    document.querySelectorAll('.rstrnt-sort').forEach(sort => {
    	sort.addEventListener('click', function() {
            let rstrntSort = sort.querySelector('h5').innerText;
            
            currentPage = 1; // 분류 바꿀 때마다 현재 페이지 초기화
            
            location.href = "/board/rstrntList?currentPage=" + currentPage + "&rstrntSort=" + rstrntSort;
        });
    });

    // (관리자 권한)음식점 등록 폼으로 이동
    if (mberAuth == 0) {
    	document.querySelector("#insertRstrntBtn").addEventListener('click', function() {
            location.href = "/board/insertRstrntForm";
        });
    }
}

// 음식점 리스트 불러오는 함수
function getRstrntList(rstrntSort){
	if(currentPage == ""){
		currentPage = 1;
	}
	
	let data = {
		"currentPage":currentPage,
		"rstrntSort":rstrntSort,
	}
	
    $.ajax({
        url: "/board/getRstrntList",
        contentType:"application/json; charset=utf-8",
        type: "GET",
        data: data,
        dataType: "json",
        success: function(res) {
            let str = "";
            
            // 맛집 정보가 있는 경우
            if(res.content.length > 0){
	            res.content.forEach(function(rv) {
	                let rating = rv.reviewVOList[0].rating;
	
	                str += `
                        <div class="col-lg-4 col-md-6 col-sm-6" style="margin-bottom: 30px;">
                        <div class="product__item">
                        <a href="/board/rstrntDetail?rstrntCd=\${rv.rstrntCd}&rstrntSort=\${rv.rstrntSort}">
                        <img src="/upload/rstrnt/\${rv.atchFileVOList[0].atchFileCours}" class="product__item__pic set-bg" alt="" style="object-fit: cover; border-radius: 5px;">
                        </div>
                        <div class="product__item__text">
                        <h6>\${rv.rstrntNm}</a></h6>
                        <div class="product__item__text" style="font-size: 14px; color: #777; margin-bottom: 5px;">\${rv.rstrntAddr}</div>
                        `;
                        
	                // 평점에 따라 별 출력
	                if (rating > 0) {
	                    for (let i = 0; i < Math.floor(rating); i++) {
	                        str += `<i class="icon_star"></i>`;
	                    }
						
	                    if(rating - Math.floor(rating) >= 0.5){
	                    	str += `<i class="icon_star-half_alt"></i>`;
	                    }
	
	                    str += `(\${rating})`;
	
	                } else {
	                    str += `<p>아직 평점이 등록되지 않았습니다.</p>`;
	                }
	                        
					str += `</div>
	                        </div>
	                        </div>`;
	                
	                // 페이지네이션
		            document.querySelector('.page-container').innerHTML = res.pagingArea;

	            });
	            
            }else{ // 맛집 정보가 없는 경우
            	str += `<div class="no-rstrnt">
            			<p style="text-align: center; color: #999; letter-spacing: -1;">해당 카테고리의 맛집이 존재하지 않습니다 :(</p>
            			</div>`;
            }
            
            document.querySelector('.rstrnt-container').innerHTML = str;
        }
    });
}
</script>
<meta charset="UTF-8">
<title>맛집 리스트</title>
</head>
<body>
	<div class="categories" style="margin-top: 60px;">
		<div class="container">
			<div class="row">
				<div class="categories__slider owl-carousel owl-loaded owl-drag">
					<div class="owl-stage-outer">
						<div class="owl-stage"
							style="transform: translate3d(-952px, 0px, 0px); transition: all 0s ease 0s; width: 3332px;">
							<div class="owl-item cloned"
								style="width: 216px; margin-right: 22px;">
								<div class="categories__item">
									<div class="categories__item__icon rstrnt-sort">
										<span class="flaticon-005-pancake"></span>
										<h5>한식</h5>
									</div>
								</div>
							</div>
							<div class="owl-item cloned" style="width: 216px; margin-right: 22px;">
								<div class="categories__item">
									<div class="categories__item__icon rstrnt-sort">
										<span class="flaticon-030-cupcake-2"></span>
										<h5>중식</h5>
									</div>
								</div>
							</div>
							<div class="owl-item cloned" style="width: 216px; margin-right: 22px;">
								<div class="categories__item">
									<div class="categories__item__icon rstrnt-sort">
										<span class="flaticon-006-macarons"></span>
										<h5>일식</h5>
									</div>
								</div>
							</div>
							<div class="owl-item cloned" style="width: 216px; margin-right: 22px;">
								<div class="categories__item">
									<div class="categories__item__icon rstrnt-sort">
										<span class="flaticon-029-cupcake-3"></span>
										<h5>양식</h5>
									</div>
								</div>
							</div>
							<div class="owl-item cloned" style="width: 216px; margin-right: 22px;">
								<div class="categories__item">
									<div class="categories__item__icon rstrnt-sort">
										<span class="flaticon-034-chocolate-roll"></span>
										<h5>기타</h5>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- 관리자 권한에서만 음식점 등록 버튼 활성화 -->
					<div class="insert-btn" style="margin-top: 30px;">
						<c:if test="${MBER_INFO.mberAuth == 0}">
							<input id="insertRstrntBtn" type="button" value="등록">
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
	<section class="product spad">
		<div class="container">
			<!-- 음식점 리스트 -->
			<div class="row rstrnt-container"></div>
		</div>
	</section>
	
	<!-- 페이지네이션 -->
	<div class="page-container" style="margin-bottom: 40px;"></div>
</body>
</html>