<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<style>
#map{
	width: 1000px;
	height: 500px;
}

.heart__btn{
    border: 1px solid #bbb;
    border-radius: 3px;
    height: 42px;
    width: 50px;
    background: #fff;
}

.product__details__text ul li{
	font-size: 14px;
	color: #333;
}

.product__details__text ul {
    margin-bottom: 20px;
}

.product-details {
    padding-top: 100px;
}

.section-title h2 {
    font-size: 30px;
    color: #666666;
    font-family: sans-serif;
    font-style: normal;
    letter-spacing: -1.5px;
}

#rstrntDscrp{
	border-bottom: 1px solid #aaa;
	padding-bottom: 17px;
	font-size: 15px;
	height: 132px;
	overflow: auto;
}

#rstrntDscrp::-webkit-scrollbar {
   width: 5px;
}
#rstrntDscrp::-webkit-scrollbar-thumb {
   background-color: #e6e6e6;
   border-radius: 7px;
}
#rstrntDscrp::-webkit-scrollbar-track {
   border-radius: 7px;
   background-color: #f5f5f5;
}

.rstrnt-detail-info{
    display: inline-block;
    width: 80px;
    color: #999;
}

.swal2-title {
    font-size: 1.65em;
}

.product__details__tab .tab-content p {
	padding-top: 3px;
	text-align: left;
    line-height: 1.2;
}

.product__details__text ul li span {
	font-weight: 600;
}

.product__details__big__img {
	width: 97%;
}

/* 리뷰란 CSS 시작 */
.blog__details__comment__item__pic img {
    height: 55px;
    width: 55px;
}

.blog__details__comment__item__pic {
    float: left;
    margin-right: 17px;
}

.review-images{
    width: 70px;
    height: 70px;
    object-fit: cover;
    border-radius: 5px;
    margin-right: 6px;
    cursor: pointer;
}

.review-btn-container p{
	font-size: 15px;
/* 	color: #777; */
	cursor: pointer;
}
/* 리뷰란 CSS 끝 */

/* 평점 CSS 시작 */
.rating-container {
    display: flex;
    justify-content: center;
    align-items: center;
}

.rating-stars {
    display: none;
}

.rating-label {
    font-size: 28px;
    color: #ddd;
    cursor: pointer;
}

.rating-container input[type=radio]{
	width: 20px;
}
/* 평점 CSS 끝 */

/* 리뷰 등록 모달 버튼 CSS 시작 */
.primary-btn {
    font-size: 14px;
    font-weight: 600;
    padding: 3px 30px;
    letter-spacing: -1px;
    height: 34px;
}

.blog__details__comment .primary-btn {
	border: none;
	top: -4px;
}
/* 리뷰 등록 모달 버튼 CSS 끝 */

/* 모달 CSS */
.modal {
    position:fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex; 
    justify-content: center;
    align-items: center; 
}

.hidden {
	display: none;
}

.modal-background {
    background-color: rgba(0,0,0,0.6);
    width: 100%;
    height: 2450px;
    position: absolute;
}

.modal-container {
    position: relative;
    margin: auto;
    padding: 35px 20px;
	border: 1px solid #888;
    width: 80%;
    max-width: 500px;
    background-color: #fff;
    border-radius: 10px;

    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

.modal-content{
	justify-content: center;
	width: 100%;
    height: 500px;
    border: none;
    flex-direction: row;
}

.modal-title h4{
    font-size: 24px;
    font-weight: 600;
    color: #333;
    text-align: center;
    text-decoration-line: underline;
    text-decoration-color: #f5a464;
    text-decoration-thickness: 7px;
}

.contact__form form input {
    margin-top: 30px;
    margin-bottom: 0;
}

/* 모달 CSS 끝 */

#insertReviewBtn, #updateReviewBtn, #closeModalBtn{
	padding: 5px;
    text-align: center;
    width: 60px;
    border: none;
    border-radius: 5px;
    color: #fff;
    font-weight: 600;
}

#closeModalBtn{
    background: #777;
}

#insertReviewBtn, #updateReviewBtn{
    background: #333;
}

.contact__form form textarea {
	margin-bottom: 0;
	height: 170px;
}
</style>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e03ac7f006917848896c4f551e98f356"></script>
<script type="text/javascript" src="/resources/js/function.js"></script>
<script type="text/javascript">
// 전역 변수
let mberId = "${MBER_INFO.mberId}"; // 로그인한 회원 아이디
let rstrntCd = "${rstrntVO.rstrntCd}"; // 음식점코드
let rstrntNm = "${rstrntVO.rstrntNm}"; // 음식점명
let rstrntSort = "${rstrntVO.rstrntSort}"; // 음식점분류
let rating = 0; // 평점
let myAtchFileCd = ""; // 내가 올린 리뷰의 첨부파일 코드

let uploadFilesArr = []; // 업로드 파일
let atchFileCds = []; // 파일 개별 삭제 시 기본키를 담을 배열
let atchFileSns = [];

window.onload = function(){
	let openReviewInsertModalBtn = document.getElementById("openReviewInsertModal");
	let closeModalBtn = document.getElementById("closeModalBtn");
	let insertReviewBtn = document.getElementById("insertReviewBtn");
    let allStars = document.querySelectorAll(".rating-stars");
    let allLabels = document.querySelectorAll(".rating-label");
    
    document.querySelector(".map-info").addEventListener("click", function(){
	    initMap(rstrntNm); // 맵 불러오기
    });
	
	/* 리뷰 등록 모달 띄우기 */
	openReviewInsertModalBtn.addEventListener("click", function(){
		// 로그인한 회원이 아닐 경우
		if(mberId == ""){
			Swal.fire({
	           title: '로그인 화면으로 이동하시겠습니까?',
	           text: '로그인한 회원만 리뷰를 작성할 수 있습니다.',
	           icon: 'info',
	           showCancelButton: true,
	           confirmButtonText: '확인',
	           cancelButtonText: '취소',
			}).then(result => {
				if(result.isConfirmed){
					location.href = "/goLoginForm"; // 로그인 폼으로 이동
				}
			});
			
			return;
		
		}else{ // 로그인한 회원일 경우
			openReviewInsertModal(); // 리뷰 등록 모달 띄우기
			resetRating(); // 평점 초기화
		}	
	});
    
	/* 평점 주기 이벤트 */
	allStars.forEach((stars) => {
    	stars.addEventListener("click", function() {
            resetRating(); // 평점 초기화

         	// 체크된 평점의 id 가져오기
            let checkedStar = this.id; // star3

            // 해당 평점의 인덱스 알아내기
            let starsIdx = parseInt(checkedStar.substring(4)); // 3
            rating = starsIdx;

            // 체크된 평점과 그 이하의 라디오 버튼들을 체크
            for (let i = 1; i <= starsIdx; i++) {
            	document.getElementById('star' + i).checked = true;
            	document.querySelector("label[for='star"+i+"']").style.setProperty("color", "#ffc107");
            }
        });
    });
	
	/* 파일 업로드 시 파일 썸네일 출력하는 이벤트 */
    document.getElementById("uploadFiles").addEventListener("change", function() {
        let files = document.getElementById("uploadFiles").files;

        for (var i = 0; i < files.length; i++) {
        	uploadFilesArr.push(files[i]); // 전역 변수에 업로드한 파일들 담기
        }

        let imageDiv = document.querySelector(".image-container");

        for (var i = 0; i < uploadFilesArr.length; i++) {
            let imgTag = document.createElement('img'); // 이미지 태그 동적 생성
            imgTag.setAttribute('id', 'images' + i);
            imgTag.setAttribute('class', 'review-images');
            imgTag.setAttribute('src', '/upload/menu/' + uploadFilesArr[i].name);

            imageDiv.appendChild(imgTag);
        }
    });

    /* 파일 개별 삭제 */
    document.querySelector(".image-container").addEventListener("click", function(event) {
        if (event.target.classList.contains("review-images")) {
            let imagesId = event.target.id; // 이미지 아이디
            let imageIdx = imagesId.substring(6); // 이미지 아이디에서 인덱스 추출
            
            uploadFilesArr.splice(imageIdx, 1); // 파일 삭제
            document.getElementById("images" + imageIdx).remove(); // 파일 썸네일 삭제
            console.log(uploadFilesArr);
            
            // 삭제한 첨부파일의 코드와 순번 가져오기
            let atchFileCd = event.target.dataset.atchfilecd;
            let atchFileSn = event.target.dataset.atchfilesn;
            
            atchFileCds.push(atchFileCd);
            atchFileSns.push(atchFileSn);
        }
    });
	
	/* 리뷰 등록 */
	insertReviewBtn.addEventListener("click", function(){
		let reviewCn = document.getElementById("reviewCn").value;
		let visitDate = document.getElementById("visitDate").value;
		
		// 내용 미입력 시 처리
	    if(reviewCn == "" || reviewCn == null){
			Swal.fire('리뷰 등록 실패!', '내용을 입력해 주세요.', 'error');
			return;
	    }
	    
		// 평점 미등록 시 처리
	    if(rating == 0){
	    	Swal.fire('리뷰 등록 실패!', '평점을 등록해 주세요.', 'error');
	    	return;
	    }
	    
		// 등록할 데이터 담기
	    let formData = new FormData();
	    formData.append("reviewCn", reviewCn);
	    formData.append("rating", rating);
	    formData.append("rstrntCd", rstrntCd);
	    formData.append("visitDate", visitDate);
	    
	    for (var i = 0; i < uploadFilesArr.length; i++) {
		    formData.append("uploadFiles", uploadFilesArr[i]);
	    };
	    
	    $.ajax({
	    	url: "/board/insertReview",
	    	contentType: false,
	    	processData: false,
	    	data: formData,
	    	type: "POST",
	    	dataType: "text",
	    	success: function(res){
	    		if(res > 0){
	    			confirmAlert1('리뷰가 등록되었습니다.', '', 'success');
	    		}
	    	}
	    })
	});
	
	/* 리뷰 수정 데이터 가져오기 */
	document.querySelectorAll(".openUpdateReviewModalBtn").forEach(btn => {
		btn.addEventListener("click", function(){
			openReviewInsertModal(); // 모달 띄우는 함수 호출
            resetRating(); // 평점 초기화
			
			document.getElementById("insertReviewBtn").style.setProperty("display", "none");
			document.getElementById("updateReviewBtn").style.removeProperty("display");
			document.getElementById("modalTitle").innerText = "리뷰 수정";
			
			let cont = this.closest(".review-container");
			let reviewCd = cont.querySelector(".reviewCd").value;
			let atchFileCd = cont.querySelector("#atchFileCd").value;
			myAtchFileCd = atchFileCd;
			
			let reviewCn = cont.querySelector(".review-cn").innerText;
			let stars = cont.querySelectorAll(".icon_star");
			
			stars.forEach(r => {
				rating++;
			})
			
			let visitDateObj = cont.querySelector(".visit-date").innerText;
			let date = new Date(visitDateObj);
			let visitDate = dateFormat(date);
			
			// 값 다시 넣어주기
			document.querySelector(".reviewCd").value = reviewCd;
            document.getElementById("reviewCn").value = reviewCn;
            document.getElementById("visitDate").value = visitDate;
            
            // 체크된 평점과 그 이하의 라디오 버튼들을 체크
            for (let i = 1; i <= rating; i++) {
            	document.getElementById('star' + i).checked = true;
            	document.querySelector("label[for='star" + i + "']").style.setProperty("color", "#ffc107");
            }
            
			// 첨부파일 목록 가져오기
			getAtchFileList(atchFileCd).then(function(res){
				let atchFileList = res;
				
	            let imageDiv = document.querySelector(".image-container");
	            
	            for (var i = 0; i < atchFileList.length; i++) {
	            	// 이미지 태그 동적 생성
	                let imgTag = document.createElement('img');
	                imgTag.setAttribute('id', 'images' + i);
	                imgTag.setAttribute('class', 'review-images');
	                imgTag.setAttribute('src', '/upload/menu/' + atchFileList[i].atchFileNm);
	                imgTag.setAttribute('data-atchFileCd', atchFileList[i].atchFileCd);
	                imgTag.setAttribute('data-atchFileSn', atchFileList[i].atchFileSn);
	
	                imageDiv.appendChild(imgTag);
	            }
			});
		});
	});
	
	/* 리뷰 수정 */
	document.getElementById("updateReviewBtn").addEventListener("click", function(){
		let uploadFiles = document.getElementById("uploadFiles").files;
		let reviewCd = document.querySelector(".reviewCd").value;
		let reviewCn = document.getElementById("reviewCn").value;
		let visitDate = document.getElementById("visitDate").value;
		
		// 내용 미입력 시 처리
	    if(reviewCn == "" || reviewCn == null){
			Swal.fire('리뷰 등록 실패!', '내용을 입력해 주세요.', 'error');
			return;
	    }
		
		// 수정할 데이터 담기
	    let formData = new FormData();
	    formData.append("reviewCd", reviewCd);
	    formData.append("reviewCn", reviewCn);
	    formData.append("visitDate", visitDate);
	    formData.append("atchFileCd", myAtchFileCd);
	    formData.append("atchFileCds", atchFileCds);
	    formData.append("atchFileSns", atchFileSns);

	    for (var i = 0; i < uploadFiles.length; i++) {
		    formData.append("uploadFiles", uploadFiles[i]);
	    };

	    if(rating > 0) formData.append("rating", rating); // 평점을 바꿨을 때만 데이터 담아줌

	    
	    $.ajax({
	    	url: "/board/updateReview",
	    	contentType: false,
	    	processData: false,
	    	data: formData,
	    	type: "POST",
	    	dataType: "text",
	    	success: function(res){
	    		if(res > 0){
	    			confirmAlert1('리뷰가 수정되었습니다.', '', 'success');
	    		}
	    	}
	    })
	});
	
	// 리뷰 삭제
	document.querySelectorAll(".deleteReviewBtn").forEach(btn => {
		btn.addEventListener("click", function(){
			let con = this.closest(".review-container");
			let reviewCd = con.querySelector(".reviewCd").value;
			let atchFileCd = con.querySelector("#atchFileCd").value;
			
			Swal.fire({
	           title: '리뷰를 정말 삭제하시겠습니까?',
	           text: '삭제하면 되돌릴 수 없습니다!',
	           icon: 'warning',
	           showCancelButton: true,
	           confirmButtonText: '확인',
	           cancelButtonText: '취소',
			}).then(result => {
				if(result.isConfirmed){
					$.ajax({
				    	url: "/board/deleteReview",
				    	data: {reviewCd: reviewCd, atchFileCd: atchFileCd},
				    	type: "POST",
				    	dataType: "text",
				    	success: function(res){
				    		if(res > 0){
						    	location.href = "/board/rstrntDetail?rstrntCd=" + rstrntCd + "&rstrntSort=" + rstrntSort;
				    		}
				    	}
					});
				}
			});
		});
	});
	
	// 음식점 삭제
	document.getElementById("deleteRstrntBtn").addEventListener("click", function(){
		Swal.fire({
           title: '음식점을 정말 삭제하시겠습니까?',
           text: '삭제하면 해당 음식점은 숨김 처리됩니다.',
           icon: 'warning',
           showCancelButton: true,
           confirmButtonText: '확인',
           cancelButtonText: '취소',
		}).then(result => {
			if(result.isConfirmed){
				$.ajax({
					url: "/board/deleteRstrnt",
					type: "GET",
					data: { rstrntCd: rstrntCd },
					dataType: "text",
					success: function(res){
						location.href = "/board/rstrntList";
					}
				})
			}
		});
	});
	
	// 평점 초기화하는 함수
	function resetRating(){
		rating = 0;
		
		allStars.forEach(stars => {
    		stars.checked = false;
    	});
    	
        allLabels.forEach(labels => {
        	labels.style.removeProperty("color", "#ffc107");
        });
	};
}

/* 리뷰 등록 모달 여는 함수 */
function openReviewInsertModal(){
    let modal = document.querySelector('.modal');
    modal.classList.remove('hidden');
    
    let imageElement = document.querySelector(".image-container .review-images");
    
    if (imageElement) {
        myAtchFileCd = imageElement.dataset.atchFileCd;
    }
        
    document.getElementById("reviewCn").focus();
};

/* 리뷰 등록 모달 닫는 함수 */
function closeReviewInsertModal(){
	document.getElementById("insertReviewBtn").style.removeProperty("display");
	document.getElementById("updateReviewBtn").style.setProperty("display", "none");
	document.getElementById("modalTitle").innerText = "리뷰 등록";
	
	// 내용 비우기
	document.getElementById("reviewCn").value = "";
    document.getElementById("visitDate").value = "";
    document.getElementById("uploadFiles").value = "";
    
    let imageDiv = document.querySelector(".image-container");
    imageDiv.innerHTML = ""; // 이미지 컨테이너 초기화
	
    // 담았던 데이터 비우기
	atchFileCds.length = 0;
	atchFileSns.length = 0;
	uploadFilesArr.length = 0;
	
	let modal = document.querySelector('.modal');
	modal.classList.add('hidden');
};

/* 첨부파일 목록 가져오기 */
function getAtchFileList(atchFileCd) {
    return new Promise((resolve, reject) => {
        $.ajax({
            url: "/board/getAtchFileList",
            contentType: "application/json;charset=utf-8",
            type: "GET",
            data: { atchFileCd: atchFileCd },
            dataType: "json",
            success: function(res) {
                resolve(res);
            }
        });
    });
};

//지도 API
function initMap(rstrntNm) {
    // 기본 좌표 설정 (대전광역시 좌표)
    let y = 36.450701;
    let x = 127.270667;

    $.ajax({
        url: "https://dapi.kakao.com/v2/local/search/keyword.json",
        contentType: "application/json; charset=UTF-8;",
        data: {"query": rstrntNm},
        headers: {"Authorization": "KakaoAK ed3b8c773b19e104fc3ab5f2ce2e548c"},
        method: "get",
        dataType: "json",
        success: function(res) {
            let found = false;
            
            res.documents.forEach(function(item) {
                if (item.place_name === rstrntNm && !found) {
                    x = item.x;
                    y = item.y;
                    
                    found = true;
                }
            });

            var container = document.getElementById('map');

            // 지도 생성 옵션 설정
            var options = {
                center: new kakao.maps.LatLng(y, x), // 지도의 중심 좌표
                level: 2 // 지도의 확대 레벨 (숫자가 작을수록 더 확대)
            };

            // 지도 객체 생성 및 리턴
            var map = new kakao.maps.Map(container, options);

            // 지도 중심 좌표에 마커를 생성
            var marker = new kakao.maps.Marker({
                position: new kakao.maps.LatLng(y, x)
            });

            // 지도에 마커 표시
            marker.setMap(map);
        }
    });
}
</script>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<section class="product-details spad">
    <div class="container">
        <div class="row">
            <div class="col-lg-6">
 				<!-- 음식점 정보 시작 ================================================================== -->           
                <div class="product__details__img">
                    <div class="product__details__big__img" style="height: 500px;">
                        <img src="/upload/rstrnt/${rstrntVO.atchFileVOList[0].atchFileCours}" class="product__item__pic set-bg" alt="" style="object-fit: cover; height: 100%; width: 100%">
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="product__details__text">
		        	<form action="/board/goUpdateRstrntForm" method="post">
	                    <div class="product__label">${rstrntVO.rstrntSort}</div>
	                    <h4 style="margin-bottom: 10px;">${rstrntVO.rstrntNm}</h4>
	                    <p style="border-bottom: 1px solid #aaa; color: #999; padding-bottom: 5px;">${rstrntVO.rstrntAddr}</p>
	                    <p id="rstrntDscrp" style="">${rstrntVO.rstrntDscrp}</p>
	                    <input type="hidden" name="rstrntCd" value="${rstrntVO.rstrntCd}">
	                    <input type="hidden" name="atchFileCd" value="${rstrntVO.atchFileVOList[0].atchFileCd}">
	                    <input type="hidden" name="atchFileNm" value="${rstrntVO.atchFileVOList[0].atchFileNm}">
	                    <ul>
	                        <li><span class="rstrnt-detail-info" style="color: #f08632;">대표메뉴</span>${rstrntVO.rstrntMenu}</li>
	                        <li><span class="rstrnt-detail-info">전화번호</span>${rstrntVO.rstrntTel}</li>
	                        <li><span class="rstrnt-detail-info">영업시간</span>${rstrntVO.rstrntBsnTm}</li>
	                        <li><span class="rstrnt-detail-info" style="letter-spacing: 7px;">주차장</span>${rstrntVO.rstrntPrkplce}</li>
	                        <li><span class="rstrnt-detail-info">예약정보</span>${rstrntVO.rstrntResve}</li>
	                    </ul>
	                    <!-- 음식점 정보 끝 ================================================================== -->   
	                    <div class="product__details__option">
	                    	<!-- 관리자 권한일 경우 음식점 수정/삭제 버튼 활성화 -->
		                    <c:if test="${MBER_INFO.mberAuth == 0}">
		                        <input type="submit" class="primary-btn" value="수정" style="height: 42px; border: none; border-radius: 3px; margin-right: 10px;">
		                        <input id="deleteRstrntBtn" type="button" class="primary-btn" value="삭제" style="height: 42px; border: none; border-radius: 3px; margin-right: 10px; background: #666;">
							</c:if>
							<input type="button" class="primary-btn" value="목록으로" onclick="location.href='/board/rstrntList'" style="background: #ccc; height: 42px; border: none; border-radius: 3px; margin-right: 10px;">
<!-- 	                        <button class="heart__btn" style="height: 42px;"><i class="icon_heart_alt" style="color: #e64242"></i></</button> -->
	                    </div>
					</form>
                </div>
            </div>
        </div>
        <div class="product__details__tab">
            <div class="col-lg-12">
                <ul class="nav nav-tabs" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#tabs-1" role="tab" aria-selected="true">회원 리뷰</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link map-info" data-toggle="tab" href="#tabs-2" role="tab" aria-selected="false">위치 정보</a>
                    </li>
                </ul>
                <div class="tab-content">
                	<!-- 회원 리뷰 시작 ============================================= -->
                    <div class="tab-pane active" id="tabs-1" role="tabpanel">
                    	<div class="row d-flex justify-content-center">
                            <div class="col-lg-8">
                            	<div class="blog__details__comment" style="margin-top: 50px;">
		                            <div class="review-title">
			                            <h5>회원 리뷰</h5>
			                            <button id="openReviewInsertModal" class="primary-btn" style="border-radius: 5px; margin-top: 5px;">
			                            	리뷰 등록
			                            </button>
		                            </div>
		                            <c:choose>
		                            	<c:when test="${not empty reviewVOList}">
			                            	<c:forEach var="reviewVO" items="${reviewVOList}" varStatus="status">
				                            <div class="blog__details__comment__item review-container">
				                                <div class="blog__details__comment__item__pic">
				                                    <img src="/resources/img/icon/profile.png" alt="">
				                                </div>
				                                <div class="blog__details__comment__item__text">
				                                    <div style="display: flex; justify-content: space-between;">
					                                    <h6 style="text-transform: none;">${reviewVO.mberId}</h6>
					                                    <div class="review-btn-container" style="display: flex; justify-content: space-between;">
						                                    <c:choose>
							                                    <%-- 본인의 리뷰인 경우 수정/삭제 버튼 활성화 --%>
						                                    	<c:when test="${MBER_INFO.mberId == reviewVO.mberId}">
							                                        <p class="openUpdateReviewModalBtn">수정 |&nbsp;</p>
							                                        <p class="deleteReviewBtn">삭제</p>
						                                    	</c:when>
						                                    </c:choose>
					                                    </div>
				                                    </div>
				                                    <input class="reviewCd" type="hidden" value="${reviewVO.reviewCd}">
				                                    <p class="visit-date" style="font-size: 12px; color: #999; margin-bottom: 5px;">방문한 날: 
				                     				<fmt:formatDate value="${reviewVO.visitDate}" pattern="yyyy-MM-dd"/></p>
				                                    <span>
				                                    	<c:forEach var="i" begin="1" end="${reviewVO.rating}">
				                                    		<i class="icon_star"></i>
				                                    	</c:forEach>
				                                    	<c:if test="${5 - reviewVO.rating >= 0.5 && 5 - reviewVO.rating < 1}">
				                                    		<i class="icon_star-half_alt"></i>
				                                    	</c:if>
				                                    </span>
				                                    <p class="review-cn" style="font-size: 14px;">${reviewVO.reviewCn}</p>
				                                    <div class="review-img-container" style="margin-top: 20px;">
				                                    	<c:choose>
				                                    		<c:when test="${reviewVO.atchFileVOList[0].atchFileCd != null}">
							                                    <c:forEach var="atchFileVO" items="${reviewVO.atchFileVOList}" varStatus="status">
								                                    <img src="/upload/review/${atchFileVO.atchFileCours}" alt="" style="width: 100px; height: 100px; object-fit: cover; border-radius: 5px;">
							                                    	<input id="atchFileCd" type="hidden" value="${atchFileVO.atchFileCd}">
							                                    </c:forEach>
				                                    		</c:when>
				                                    		<c:otherwise>
						                                    	<input id="atchFileCd" type="hidden" value="">
				                                    		</c:otherwise>
				                                    	</c:choose>
				                                    </div>
				                                </div>
				                            </div>
			                                </c:forEach>
		                            	</c:when>
		                            	<c:otherwise>
		                            		<p>등록된 리뷰가 없습니다.</p>
		                            	</c:otherwise>
		                            </c:choose>
		                        </div>
                            </div>
                        </div>
                    </div>
                    <!-- 회원 리뷰 끝 =============================================== -->
                    
                    <!-- 위치 정보 시작 =============================================== -->
                    <div class="tab-pane" id="tabs-2" role="tabpanel" style="margin-top: 40px;">
                        <div class="row d-flex justify-content-center">
                            <div class="col-lg-8" id="map"></div>
                        </div>
                    </div>
                    <!-- 위치 정보 끝 =============================================== -->
                </div>
            </div>
        </div>
    </div>
</section>

<!-- 추천 맛집 시작 =============================================== -->
<section class="related-products spad">
	<div class="container">
		<div class="row">
			<div class="col-lg-12 text-center">
				<div class="section-title">
					<h2>추천 맛집</h2>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="related__products__slider owl-carousel owl-loaded owl-drag">
				<div class="owl-stage-outer">
					<div class="owl-stage" style="transform: translate3d(-2160px, 0px, 0px); transition: all 1.2s ease 0s; width: 3360px;">
						<c:forEach var="rstrntVO" items="${relatedRstrntList}" varStatus="status">
							<a href="/board/rstrntDetail?rstrntCd=${rstrntVO.rstrntCd}&rstrntSort=${rstrntVO.rstrntSort}">
							<div class="owl-item" style="width: 240px;">
								<div class="col-lg-3">
									<div class="product__item">
										<div class="product__item__pic set-bg"
											data-setbg="/upload/rstrnt/${rstrntVO.atchFileVOList[0].atchFileCours}"
											style="background-image: url(&quot;/resources/img/shop/product-3.jpg&quot;);">
										</div>
										<div class="product__item__text" style="padding-top: 20px;">
											<h6 style="margin-bottom: 3px;"><a href="#">${rstrntVO.rstrntNm}</a></h6>
											<div class="">${rstrntVO.rstrntAddr}</div>
										</div>
									</div>
								</div>
							</div>
							</a>
						</c:forEach>
					</div>
				</div>
				<div class="owl-nav">
					<button type="button" role="presentation" class="owl-prev">
						<span class="arrow_carrot-left"><span></span></span>
					</button>
					<button type="button" role="presentation" class="owl-next">
						<span class="arrow_carrot-right"><span></span></span>
					</button>
				</div>
				<div class="owl-dots disabled"></div>
			</div>
		</div>
	</div>
</section>
<!-- 추천 맛집 끝 =============================================== -->

	<!-- 리뷰 등록 모달 시작 =============================================== -->
	<div class="modal modal-background hidden" id="insert-modal">
		<div class="modal">
			<div class="modal-container">
				<div class="modal-title" style="margin-bottom: 10px;">
					<h4 id="modalTitle">리뷰 등록</h4>
				</div>
				<div class="modal-content">
					<div class="row">
		                <div class="col-lg-12">
		                    <div class="contact__form" style="margin-top: 20px;">
		                        <form action="#">
		                            <div class="col-lg-12" style="margin-bottom: 10px;">
		                            	<h4 style="font-size: 16px; color: #555; text-align: center; letter-spacing: -0.5;">이 가게는 어땠나요?</h4>
		                            </div>
		                            <div class="col-lg-12 rating-container" style="margin-bottom: 20px; height: 25px;">
								        <input type="radio" id="star1" class="rating-stars">
								        <label for="star1" class="rating-label">&#9733;</label>
								        
								        <input type="radio" id="star2" class="rating-stars">
								        <label for="star2" class="rating-label">&#9733;</label>
								        
								        <input type="radio" id="star3" class="rating-stars">
								        <label for="star3" class="rating-label">&#9733;</label>
								        
								        <input type="radio" id="star4" class="rating-stars">
								        <label for="star4" class="rating-label">&#9733;</label>
								        
								        <input type="radio" id="star5" class="rating-stars">
								        <label for="star5" class="rating-label">&#9733;</label>
   									</div>
		                            <div class="col-lg-12">
		                                <textarea id="reviewCn" placeholder="리뷰를 작성해 주세요" style="height: 120px;"></textarea>
		                            </div>
		                            <div class="col-lg-12" style="margin-top: 20px;">
		                            	<span style="color: #999; font-size: 12px;">언제 방문하셨나요?</span>
		                                <input id="visitDate" type="date" style="align-content: center; padding-right: 10px; margin-top: 0;">
		                            </div>
		                            <div class="col-lg-12" style="margin-top: 20px;">
										<span style="color: #999; font-size: 12px;">사진을 올리면 회원들에게 많은 도움이 돼요!</span>
									    <input id="uploadFiles" name="uploadFiles" type="file" value="사진 추가" multiple style="align-content: center; margin-top: 0;">
		                            </div>
		                            <div class="col-lg-12" style="margin-top: 20px;">
		                            	<div class="image-container"></div>
		                            </div>
		                        </form>
		                    </div>
		                </div>
            		</div>
				</div>
				<div class="modal-btn" style="text-align: center;">
					<button id="insertReviewBtn">등록</button>
					<button id="updateReviewBtn" style="display: none;">수정</button>
					<button id="closeModalBtn" onclick="closeReviewInsertModal()">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 리뷰 등록 모달 끝 =============================================== -->
</body>
</html>