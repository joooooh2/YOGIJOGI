package my.yogijogi.com.util;

import java.util.List;

import lombok.Data;

@Data
public class ArticlePage<T> {
	private int total;				// 전체글 수
	private int currentPage;		// 현재 페이지 번호
	private int totalPages;			// 전체 페이지수
	private int startPage;			// 블록의 시작 페이지 번호
	private int endPage;			// 블록의 종료 페이지 번호
	private String url = "";		// 요청 URL
	private List<T> content;		// 출력할 데이터
	private String pagingArea = "";	// 페이징 처리
	private int blockSize = 5;		// 페이지 블록 크기
	private String code = "";
	private int listSize;
	
	
	public ArticlePage(int total, int currentPage, int size, List<T> content) {
		// size : 한 화면에 보여질 목록의 행 수
		this.total = total;// 753
		this.currentPage = currentPage;// 1
		this.content = content;

		// 글이 없는 경우
		if (total == 0) {
			totalPages = 0;
			startPage = 0;
			endPage = 0;
		} else { // 글이 있는 경우
			// 전체 페이지 수 = 전체글 수 / 한 화면에 보여질 목록의 행 수
			totalPages = total / size;

			// 나머지가 있다면(출력할 글이 있다면), 페이지 1 증가
			if (total % size > 0) {
				totalPages++;
			}

			// 페이지 블록 시작번호를 구하는 공식
			// 블록시작번호 = 현재페이지 / 페이지크기 * 페이지크기 + 1
			startPage = currentPage / blockSize * blockSize + 1;// 1

			// 현재 페이지 % 페이지 크기 = 0일 때 보정
			if (currentPage % blockSize == 0) {
				startPage -= blockSize;
			}

			// 블록 종료 페이지 = 블록 시작 페이지 + (페이지 블록 크기 - 1)
			// [1][2][3][4][5][다음]
			endPage = startPage + (blockSize - 1);

			// 블록 종료 페이지 > 전체 페이지 수인 경우
			if (endPage > totalPages) {
				endPage = totalPages;
			}
		}
		
		String localUrl = this.url;
		
		pagingArea += "<div class='shop__last__option'>";
		pagingArea += "<div class='row'>";
		pagingArea += "<div class='col-lg-12 col-md-6 col-sm-6'>";
		pagingArea += "<div class='shop__pagination' style='display: flex; justify-content: center;'>";

		// 이전 페이지로 가는 화살표 표기 여부
		pagingArea += "<a class='arrow_carrot-left' ";

		if (this.startPage < blockSize + 1) {
		    pagingArea += "style='display: none;' ";
		    localUrl = "#";
		} else {
		    localUrl = this.url;
		}

		pagingArea += "href='" + localUrl + "?currentPage=" + (this.startPage - blockSize) + "'></a>";

		for (int pNo = this.startPage; pNo <= this.endPage; pNo++) {
		    pagingArea += "<a href='" + this.url + "?currentPage=" + pNo + "' ";
		    if (this.currentPage == pNo) {
		        pagingArea += "class='current-page' style='color: #f08632;' ";
		    }

		    if (pNo == 0) {
		        pagingArea += "style='display:none;' ";
		    }

		    pagingArea += ">";
		    pagingArea += pNo;
		    pagingArea += "</a>";
		}

		// 다음 페이지로 가는 화살표 표기 여부
		pagingArea += "<a class='arrow_carrot-right' ";

		if (this.endPage >= this.totalPages) {
		    pagingArea += "style='display: none;' ";
		    localUrl = "#";
		} else {
		    localUrl = this.url;
		}

		pagingArea += "href='" + localUrl + "?currentPage=" + (this.startPage + blockSize) + "'></a>";

		pagingArea += "</div>";
		pagingArea += "</div>";
		pagingArea += "</div>";
		pagingArea += "</div>";

		
	}// end 생성자
}
