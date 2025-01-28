package my.yogijogi.com.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.extern.slf4j.Slf4j;
import my.yogijogi.com.service.MainService;
import my.yogijogi.com.vo.MemberVO;

@Slf4j
@Controller
public class MainController {
	
	@Autowired
	MainService mainService;
	
	// 메인 홈페이지
	@GetMapping("/main")
	public String main() {
		return "common/mainPage";
	}
	
	// 로그인 페이지로 이동
	@GetMapping("/goLoginForm")
	public String goLoginForm() {
		return "common/loginForm";
	}
	
	// 로그인
	@ResponseBody
	@PostMapping("/login")
	public int login(@RequestBody MemberVO memberVO, HttpServletRequest request) {
		int result = mainService.login(memberVO);
		
		// 세션에 저장
		if(result == 1) {
			MemberVO mberInfo = mainService.setMberInfo(memberVO.getMberId());
			request.getSession().setAttribute("MBER_INFO", mberInfo);
		}
		
		return result;
	}
	
	// 로그아웃
	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		request.getSession().removeAttribute("MBER_INFO");
		
		return "redirect:/main";
	}
	
	// 회원 가입 페이지로 이동
	@GetMapping("/goSignUpForm")
	public String goSignUpForm() {
		return "common/signUpForm";
	}
	
	// 아이디 중복 검사
	@ResponseBody
	@GetMapping("/idCheck")
	public int idCheck(@RequestParam("mberId") String mberId) {
		log.info("idCheck -> mberId: " + mberId);
		
		int result = mainService.idCheck(mberId);
		
		return result;
	}
	
	// 회원 가입
	@ResponseBody
	@PostMapping("/signUp")
	public int signUp(@RequestBody MemberVO memberVO) {
		log.info("signUp -> memberVO: " + memberVO);
		
		int result = mainService.signUp(memberVO);
		
		return result;
	}
}
