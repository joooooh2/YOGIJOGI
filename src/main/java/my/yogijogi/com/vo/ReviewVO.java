package my.yogijogi.com.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Builder
@ToString
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ReviewVO {
	private String reviewCd;
	private String reviewCn;
	private double rating;
	private String mberId;
	private String rstrntCd;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date visitDate;
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date reviewDate;
	private String atchFileCd;
	
	private MultipartFile[] uploadFiles;
	
	// 조인 시 사용
	private List<AtchFileVO> atchFileVOList;
}
