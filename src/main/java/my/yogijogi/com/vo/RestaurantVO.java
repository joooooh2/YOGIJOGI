package my.yogijogi.com.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Builder
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class RestaurantVO {
	private String rstrntCd;		// 음식점코드
	private String rstrntNm;		// 음식점명
	private String rstrntAddr;		// 음식점주소
	private String rstrntTel;		// 음식점전화번호
	private String rstrntMenu;		// 음식점대표메뉴
	private String rstrntSort;		// 음식점분류
	private String rstrntDscrp;		// 음식점상세설명
	private String rstrntBsnTm;		// 음식점영업시간
	private String rstrntPrkplce;	// 음식점주차장여부
	private String rstrntResve;		// 음식점예약정보
	private int rstrntOperStt;		// 음식점운영상태
	private String atchFileCd;		// 첨부파일코드
	
	// 파일 업로드 시 사용
	private MultipartFile uploadFile;
	
	// 조인 시 사용
	private List<ReviewVO> reviewVOList;
	private List<AtchFileVO> atchFileVOList;
	
}
