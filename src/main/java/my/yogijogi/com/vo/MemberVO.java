package my.yogijogi.com.vo;

import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class MemberVO {
	private String mberId;		// 회원 아이디
	private String password;	// 비밀번호
	private String mberNm;		// 회원명
	private String ihidnum;		// 주민등록번호
	private String mberTel;		// 전화번호
	private String mberAddr;	// 회원 주소
	private String mberEmail;	// 회원 이메일
	private int mberAuth;		// 회원 권한
}
