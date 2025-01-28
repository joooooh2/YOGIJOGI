package my.yogijogi.com.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BoardVO {
	private String brdCd;
	private String brdSj;
	private String brdCn;
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date brdDate;
	private int cnt;
	private String atchFile;
	private String mberId;
	
	private MultipartFile uploadFiles;
}
