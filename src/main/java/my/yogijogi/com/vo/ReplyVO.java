package my.yogijogi.com.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class ReplyVO {
	private String replyCd;
	private String replyCn;
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date replyDate;
	private String mberId;
	private String brdCd;
}
