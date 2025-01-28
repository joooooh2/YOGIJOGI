package my.yogijogi.com.vo;

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
public class AtchFileVO {
	private String atchFileCd;
	private int atchFileSn;
	private String atchFileNm;
	private String atchFileTy;
	private String atchFileCours;
	private String mberId;
}
