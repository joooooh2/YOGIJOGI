package my.yogijogi.com.service.serviceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import my.yogijogi.com.mapper.MainMapper;
import my.yogijogi.com.service.MainService;
import my.yogijogi.com.vo.MemberVO;

@Service
public class MainServiceImpl implements MainService {

	@Autowired
	MainMapper mainMapper;
	
	// 로그인
	@Override
	public int login(MemberVO memberVO) {
		return this.mainMapper.login(memberVO);
	}

	// 회원 정보 세션에 저장
	@Override
	public MemberVO setMberInfo(String mberId) {
		return this.mainMapper.setMberInfo(mberId);
	}

	// 아이디 중복 체크
	@Override
	public int idCheck(String mberId) {
		return this.mainMapper.idCheck(mberId);
	}

	// 회원 가입
	@Override
	public int signUp(MemberVO memberVO) {
		return this.mainMapper.signUp(memberVO);
	}

}
