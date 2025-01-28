package my.yogijogi.com.service;

import java.util.Map;

import my.yogijogi.com.vo.MemberVO;

public interface MainService {

	// 로그인
	public int login(MemberVO memberVO);

	// 회원 정보 세션에 저장
	public MemberVO setMberInfo(String mberId);
	
	// 아이디 중복 체크
	public int idCheck(String mberId);

	// 회원 가입
	public int signUp(MemberVO memberVO);

}
