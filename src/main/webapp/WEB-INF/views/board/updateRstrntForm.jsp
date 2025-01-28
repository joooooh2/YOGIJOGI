<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
#fileLabel{
	border: 1px solid #999;
	border-radius: 5px;
 	width: 100%;
    height: 40px;
    align-content: center;
    font-size: 14px;
    padding: 5px;
    text-align: center;
    cursor: pointer;
}

#closeBtn{
    padding: 5px;
    text-align: center;
    width: 60px;
    border: none;
    border-radius: 5px;
    background: #333;
    color: #fff;
    font-weight: 600;
}

.contact__form input[type=text]{
	height: 40px;
}

.contact__form form input {
	padding-left: 20px;
	margin-bottom: 23px;
}

.nice-select, .nice-select ul{
	width: 100%;
}

.form-control::placeholder{
	color: #999;
	font-size: 14px;
}

.rstrnt-info-form{
    border: 1px solid #ddd;
    padding: 50px;
    width: 700px;
    border-radius: 10px;
}

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
    height: 100%;
    position: absolute;
}

.modal-title h4{
    font-size: 24px;
    font-weight: 600;
    color: #333;
    text-align: center;
    text-decoration-line: underline;
    text-decoration-color: #f5a464;
    text-decoration-thickness: 7px;
    margin-bottom: 20px;
    letter-spacing: -1;
}

.modal-container {
    position: relative;
    margin: auto;
    padding: 20px;
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
}

.search-content{
	display: flex;
	justify-content: center;
	padding: 30px 0 35px;
}

.search-result-container{
	padding: 0px;
	overflow: auto;
	height: 370px;
}

.search-result-container p{
	text-align: center;
	color: #999;
/* 	font-weight: bold; */
}

#search-result-text{
	text-align: center;
	font-weight: bold;
	color: #666;
	letter-spacing: -1;
	margin: 0 0 5px 0;
	font-size: 18px;
}

.rstrnt-list{
	margin: 7px;
	padding: 8px 20px;
	border-bottom: 1px solid #ddd;
}

.rstrnt-list p{
	margin: 3px;
	text-align: left;
    font-size: 14.5px;
/*     font-weight: 600; */
    letter-spacing: -0.5;
}

#updateRstrntBtn{
    height: 40px;
    width: 116px;
    border-radius: 8px;
    color: #fff;
    font-weight: 600;
    background: #f08632;
    font-size: 1.3rem;
    margin: 0px 15px;
    padding-right: 20px;
}

/* 스크롤바 시작 */
.search-result-container::-webkit-scrollbar {
   width: 5px;
}
.search-result-container::-webkit-scrollbar-thumb {
   background-color: #e6e6e6;
   border-radius: 7px;
}
.search-result-container::-webkit-scrollbar-track {
   border-radius: 7px;
   background-color: #f5f5f5;
}
/* 스크롤바 끝 */
}
</style>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=7039108d362ca58cbb7dcbfedef7be8e"></script>
<script type="text/javascript" src="/resources/js/jquery.min.js" ></script>
<script type="text/javascript" src="/resources/js/function.js"></script>
<script type="text/javascript">
// 전역변수
let atchFileCd = "${rstrntVO.atchFileCd}";
let rstrntCd = "${rstrntVO.rstrntCd}";

$(function(){
	const searchAddrBtn = document.getElementById('searchAddrBtn');
	const closeBtn = document.getElementById('closeBtn');
	const searchBtn = document.getElementById('searchBtn');
	const modal = document.querySelector('.modal');
	
	/* 주소 찾기 시작 */
	// 네이버 지도 API
	const getRstrntInfo = function(searchRstrntNm){
	    $.ajax({
	        url: "https://dapi.kakao.com/v2/local/search/keyword.json",
	        contentType: "application/json; charset=UTF-8;",
	        data: {"query": searchRstrntNm},
	        headers: {"Authorization": "KakaoAK ed3b8c773b19e104fc3ab5f2ce2e548c"},
	        method: "get",
	        dataType: "json",
	        async: false,
	        success: function(res){
	            let str = "";
	            
	            if(res.documents.length > 0){
	                res.documents.forEach(function(item){
	                    const itemStr = JSON.stringify(item);
	                    str += `
	                        <div class="col-md-12" style="margin-top: 15px;">
	                            <div class="rstrnt-list">
	                                <p class="rstrnt-item" style="text-align: left; color: #333; font-size: 16px;" data-rstrnt='\${itemStr}'>\${item.place_name}</p>
	                                <p style="text-align: left;">\${item.address_name}</p>
	                            </div>
	                        </div>
	                	`;
	                });
	            } else {
	                str += `<p>검색 결과가 없습니다.</p>`;
	            }
				
	            document.querySelector('.search-result-content').innerHTML = str;
	        }
	    });
	};
	
	// 찾은 음식점 정보 가져오기
	$(document).on('click', '.rstrnt-item', function(e){
		let item = JSON.parse(e.target.getAttribute('data-rstrnt'));
		
	    document.getElementById("rstrntAddr").value = item.address_name;
	    document.getElementById("rstrntNm").value = item.place_name;
	    document.getElementById("rstrntTel").value = item.phone;
	    
	    modal.classList.add('hidden');
	});
	
	// 모달 창 열기/닫기 이벤트
	searchAddrBtn.addEventListener('click', function(){
		modal.classList.remove('hidden');
		
		// 찾기 버튼 클릭 이벤트
		searchBtn.addEventListener('click', function(){
			let searchRstrntNm = document.getElementById('searchRstrntNm').value;
	
			getRstrntInfo(searchRstrntNm);
		});
	});
	
	closeBtn.addEventListener('click', function(){
		modal.classList.add('hidden');
	});
	/* 주소 찾기 끝 */
	
	// 업로드한 파일명 가져오는 이벤트
	document.getElementById('uploadFile').addEventListener('change', function(){
		let uploadFile = document.getElementById("uploadFile").files[0];
		document.getElementById("fileName").value = uploadFile.name;
		
	});

	/* 음식점 수정 시작 */
	document.getElementById('updateRstrntBtn').addEventListener('click', function(){
		// 입력 정보 가져오기
		let rstrntAddr = document.getElementById("rstrntAddr").value;
		let rstrntNm = document.getElementById("rstrntNm").value;
		let rstrntTel = document.getElementById("rstrntTel").value;
		let rstrntMenu = document.getElementById("rstrntMenu").value;
		let rstrntBsnTm = document.getElementById("rstrntBsnTm").value;
		let rstrntDscrp = document.getElementById("rstrntDscrp").value;
		let rstrntPrkplce = document.getElementById("rstrntPrkplce").value;
		let rstrntResve = document.getElementById("rstrntResve").value;
		
		// 음식점 분류 가져오기
		let select = document.getElementById("selectSort");
		let rstrntSort = select.options[select.selectedIndex].value;
		
		// 업로드한 파일 가져오기
		let uploadFile = document.getElementById("uploadFile").files[0];
		
		let formData = new FormData();
		
		formData.append("rstrntCd", rstrntCd);
		formData.append("rstrntAddr", rstrntAddr);
		formData.append("rstrntNm", rstrntNm);
		formData.append("rstrntTel", rstrntTel);
		formData.append("rstrntMenu", rstrntMenu);
		formData.append("rstrntBsnTm", rstrntBsnTm);
		formData.append("rstrntDscrp", rstrntDscrp);
		formData.append("rstrntPrkplce", rstrntPrkplce);
		formData.append("rstrntSort", rstrntSort);
		formData.append("rstrntResve", rstrntResve);
		formData.append("atchFileCd", atchFileCd);
		
		if(uploadFile != null){
			formData.append("uploadFile", uploadFile);
		}
		
		$.ajax({
			url: "/board/updateRstrnt",
			processData: false,
			contentType: false,
			type: "POST",
			data: formData,
			dataType: "text",
			success: function(res){
				confirmAlert2('음식점이 수정되었습니다.', '', 'success');
			}
		});	// end ajax
	});
	/* 음식점 등록 끝 */
});
</script>
<meta charset="UTF-8">
<title>음식점 등록</title>
<body>
<section class="contact spad">
    <div class="container">
        <div class="row" style="justify-content: center;">
            <div class="col-lg-7">
                <div class="contact__form">
                    <form action="#">
                        <div class="row" style="box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); border-radius: 10px; padding: 40px 45px;">
                        	<div class="col-lg-12 insert-rstrnt-title" style="margin-bottom: 35px;">
                        		<h3 style="text-align: center; font-weight: 600; color: #555; letter-spacing: -2px;">음식점 수정</h3>
                        	</div>
							<div class="col-lg-10">
								<input type="text" id="rstrntAddr" value="${rstrntVO.rstrntAddr}" class="form-control" placeholder="음식점주소" required style="color: #999;">
							</div>
							<div class="col-lg-2" style="padding-left: 5px;">
								<input id="searchAddrBtn" type="button" class="form-control" value="검색" style="background-color: #777; color: #fff; border-radius: 20px; height: 40px; font-weight: 600; padding-left: 10px;">
							</div>
							<div class="col-lg-6">
                                <input type="text" id="rstrntNm" name="rstrntNm" value="${rstrntVO.rstrntNm} "class="form-control" placeholder="음식점명" required>
                            </div>
                            <div class="col-lg-6">
                            	<select id="selectSort" style="width: 100%;">
         							<option value="한식" selected>한식</option>
						         	<option value="중식">중식</option>
						         	<option value="일식">일식</option>
						         	<option value="양식">양식</option>
						         	<option value="기타">기타</option>
           						</select>
                            </div>
                            <div class="col-lg-6">
                                <input type="text" id="rstrntTel" value="${rstrntVO.rstrntTel}" class="form-control" placeholder="음식점 전화번호" required>
                            </div>
                            <div class="col-lg-6">
                                <input type="text" id="rstrntBsnTm" value="${rstrntVO.rstrntBsnTm}" class="form-control" placeholder="음식점 영업시간" required="">
                            </div>
                            <div class="col-lg-12">
                                <input type="text" id="rstrntMenu" value="${rstrntVO.rstrntMenu}" class="form-control" placeholder="음식점 대표 메뉴" required style="height: 40px;">
                            </div>
                            <div class="col-lg-12">
                                <textarea id="rstrntDscrp" class="form-control" rows="6" placeholder="음식점 상세 설명" required style="resize: none;">${rstrntVO.rstrntDscrp}</textarea>
                            </div>
                            <div class="col-lg-6">
                                <input type="text" id="rstrntPrkplce" value="${rstrntVO.rstrntPrkplce}" class="form-control" placeholder="주차장 유무" required>
                            </div>
                            <div class="col-lg-6">
                                <input type="text" id="rstrntResve" value="${rstrntVO.rstrntResve}" class="form-control" placeholder="예약 관련 정보">
                            </div>
                            <div class="col-lg-3" style="height: 40px; align-content: center;">
                            	<label id="fileLabel" for="uploadFile" style="border: 1px solid #999">파일 첨부</label>
                                <input type="file" id="uploadFile" name="uploadFile" class="form-control" value="파일 첨부" required style="align-content: center; display: none;">
                            </div>
                            <div class="col-lg-9">
                            	<input id="fileName" type="text" value="${atchFileNm}">
                            </div>
                            <div class="col-lg-12" style="text-align: center; margin-top: 10px;">
	                            <input id="updateRstrntBtn" type="button" value="수정" style="">
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>
    
    <!-- 모달 시작 ===================================================================== -->
    <div class="modal modal-background hidden">
      <div class="modal">
        <div class="modal-container">
          <div class="modal-title">
          	<h4>음식점 검색</h4>
          </div>
          <div class="modal-content">
            <div class="search-content">
	          <input id="searchRstrntNm" type="text" value="" placeholder="음식점명을 입력하세요" class="form-control" style="width: 70%;">
	          <input id="searchBtn" type="button" value="검색" class="form-control" style="background: #f1f1f1; width: 20%; margin-left: 10px;">
            </div>
			<p id="search-result-text">검색 결과</p>
	        <div class="search-result-container">
	          <div class="search-result-content" style="border: none;">

	          </div>
	        </div>
          </div>
          <div class="modal-btn" style="text-align: center; margin-top: 30px;">
          	<button id="closeBtn">닫기</button>
          </div>
        </div>
      </div>
    </div>
    <!-- 모달 끝 ===================================================================== -->
</body>
