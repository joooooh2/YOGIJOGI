package my.yogijogi.com.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.slf4j.Slf4j;
import my.yogijogi.com.service.BoardService;
import my.yogijogi.com.util.ArticlePage;
import my.yogijogi.com.vo.AtchFileVO;
import my.yogijogi.com.vo.MemberVO;
import my.yogijogi.com.vo.RestaurantVO;
import my.yogijogi.com.vo.ReviewVO;

@Slf4j
@RequestMapping("/board")
@Controller
public class BoardController {

	@Autowired
	BoardService boardService;
	
	// 음식점 리스트 페이지로 이동
	@GetMapping("/rstrntList")
	public String rstrntList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "rstrntSort", required = false, defaultValue = "한식") String rstrntSort) {
		
		model.addAttribute("rstrntSort", rstrntSort);
		
		return "board/rstrntList";
	}
	
	// 음식점 리스트 불러오기
	@ResponseBody
	@GetMapping("/getRstrntList")
	public ArticlePage<RestaurantVO> getRstrntList(@RequestParam Map<String, Object> map, Model model) {
		String currentPage = (String) map.get("currentPage");
		log.info("getRstrntList -> currentPage: " + currentPage);
		
		// 음식점 리스트 가져오기
		List<RestaurantVO> rstrntList = boardService.rstrntList(map);
		log.info("getRstrntList -> rstrntList: " + rstrntList);
		
		int total = 0; // 음식점 리스트 수를 담을 변수
		
		// 음식점 리스트가 있는 경우,
		if(rstrntList.size() > 0) {
			// 특정 분류에 맞는 리스트의 개수를 구해서 담아줌
			total = boardService.getRstrntCount(rstrntList.get(0).getRstrntSort());
			log.info("getRstrntList -> total: " + total);
		}

		// 페이지네이션 처리를 위한 데이터 구하기
		ArticlePage<RestaurantVO> data = new ArticlePage<RestaurantVO>(total, Integer.parseInt(currentPage), 6, rstrntList);
		
		return data;
	}
	
	// 음식점 상세 보기
	@GetMapping("/rstrntDetail")
	public String rstrntDetail(Model model,
			@RequestParam("rstrntCd") String rstrntCd,
			@RequestParam(value="rstrntSort", required=false) String rstrntSort) {
		log.info("rstrntDetail -> " + rstrntCd);
		log.info("rstrntDetail -> rstrntSort: " + rstrntSort);
		
		// 음식점 정보 가져오기
		RestaurantVO rstrntVO = boardService.rstrntDetail(rstrntCd);
		log.info("rstrntDetail -> " + rstrntVO);
		
		// 리뷰 정보 가져오기
		List<ReviewVO> reviewVOList = boardService.getReview(rstrntCd);
		
		// 연관된 맛집 가져오기
		List<RestaurantVO> relatedRstrntList = boardService.getRelatedRstrnt(rstrntSort);
		
		model.addAttribute("rstrntVO", rstrntVO);
		model.addAttribute("reviewVOList", reviewVOList);
		model.addAttribute("relatedRstrntList", relatedRstrntList);
		
		return "board/rstrntDetail";
	}
	
	// 리뷰 첨부파일 목록 가져오기
	@ResponseBody
	@GetMapping("/getAtchFileList")
	public List<AtchFileVO> getAtchFileList(@RequestParam("atchFileCd") String atchFileCd, HttpServletRequest request){
		log.info("getAtchFileList -> atchFileCd: " + atchFileCd);
		
		MemberVO memberVO = (MemberVO)request.getSession().getAttribute("MBER_INFO");
		String mberId = memberVO.getMberId();
		log.info("getAtchFileList -> mberId: " + mberId);
		
		AtchFileVO atchFileVO = AtchFileVO.builder()
			.atchFileCd(atchFileCd)
			.mberId(mberId)
			.build();
		
		List<AtchFileVO> atchFileVOList = boardService.getAtchFileList(atchFileVO);
		log.info("getAtchFileList -> atchFileVOList: " + atchFileVOList);
		
		return atchFileVOList;
	}
	
	// 음식점 등록 폼으로 이동
	@GetMapping("/insertRstrntForm")
	public String insertRstrntForm() {
		return "board/insertRstrntForm";
	}
	
	// 음식점 등록
	@ResponseBody
	@PostMapping("/insertRstrnt")
	public int insertRstrnt(@RequestParam("uploadFile") MultipartFile uploadFile,
            @RequestParam("rstrntAddr") String rstrntAddr,
            @RequestParam("rstrntNm") String rstrntNm,
            @RequestParam("rstrntTel") String rstrntTel,
            @RequestParam("rstrntMenu") String rstrntMenu,
            @RequestParam(value= "rstrntBsnTm", required = false) String rstrntBsnTm,
            @RequestParam("rstrntDscrp") String rstrntDscrp,
            @RequestParam("rstrntPrkplce") String rstrntPrkplce,
            @RequestParam("rstrntSort") String rstrntSort,
            @RequestParam("rstrntResve") String rstrntResve) {

		// RestaurantVO 객체 생성
		RestaurantVO rstrntVO = RestaurantVO.builder()
			.rstrntAddr(rstrntAddr)
			.rstrntNm(rstrntNm)
			.rstrntTel(rstrntTel)
			.rstrntMenu(rstrntMenu)
			.rstrntBsnTm(rstrntBsnTm)
			.rstrntDscrp(rstrntDscrp)
			.rstrntPrkplce(rstrntPrkplce)
			.rstrntSort(rstrntSort)
			.rstrntResve(rstrntResve)
			.uploadFile(uploadFile)
			.build();
			
		log.info("insertRstrnt -> rstrntVO: " + rstrntVO);
			
		int result = boardService.insertRstrnt(rstrntVO);
		
		return result;
	}
	
	// 음식점 수정 폼으로 이동
	@PostMapping("/goUpdateRstrntForm")
	public String goUpdateRstrntForm(Model model,
			@RequestParam("rstrntCd") String rstrntCd,
			@RequestParam("atchFileNm") String atchFileNm) {
		log.info("goUpdateRstrntForm -> rstrntCd: " + rstrntCd);
		
		// 음식점 정보 가져오기
		RestaurantVO rstrntVO = boardService.rstrntDetail(rstrntCd);
		log.info("rstrntDetail -> " + rstrntVO);
		
		model.addAttribute("rstrntVO", rstrntVO);
		model.addAttribute("atchFileNm", atchFileNm);
		
		return "board/updateRstrntForm";
	}
		
	// 음식점 정보 수정
	@ResponseBody
	@PostMapping("/updateRstrnt")
	public int updateRstrnt(
			@RequestParam("rstrntCd") String rstrntCd,
			@RequestParam("rstrntAddr") String rstrntAddr,
            @RequestParam("rstrntNm") String rstrntNm,
            @RequestParam("rstrntTel") String rstrntTel,
            @RequestParam("rstrntMenu") String rstrntMenu,
            @RequestParam("rstrntBsnTm") String rstrntBsnTm,
            @RequestParam("rstrntDscrp") String rstrntDscrp,
            @RequestParam("rstrntPrkplce") String rstrntPrkplce,
            @RequestParam("rstrntSort") String rstrntSort,
            @RequestParam("rstrntResve") String rstrntResve,
            @RequestParam("atchFileCd") String atchFileCd,
			@RequestParam(value="uploadFile", required=false) MultipartFile uploadFile) {
		log.info("updateRstrnt -> rstrntNm: " + rstrntNm);
		log.info("updateRstrnt -> uploadFile: " + uploadFile);
		
		// RestaurantVO 객체 생성
		RestaurantVO rstrntVO = RestaurantVO.builder()
			.rstrntCd(rstrntCd)
			.rstrntAddr(rstrntAddr)
			.rstrntNm(rstrntNm)
			.rstrntTel(rstrntTel)
			.rstrntMenu(rstrntMenu)
			.rstrntBsnTm(rstrntBsnTm)
			.rstrntDscrp(rstrntDscrp)
			.rstrntPrkplce(rstrntPrkplce)
			.rstrntSort(rstrntSort)
			.rstrntResve(rstrntResve)
			.uploadFile(uploadFile)
			.atchFileCd(atchFileCd)
			.build();
		
		int result = boardService.updateRstrnt(rstrntVO);		
		log.info("updateRstrnt -> result: " + result);
		
		return result;
	}
	
	// 음식점 삭제
	@ResponseBody
	@GetMapping("/deleteRstrnt")
	public int deleteRstrnt(@RequestParam("rstrntCd") String rstrntCd) {
		log.info("deleteRstrnt -> rstrntCd: " + rstrntCd);
		
		int result = boardService.deleteRstrnt(rstrntCd);
		
		return result;
	}
	
	// 리뷰 등록
	@ResponseBody
	@PostMapping("/insertReview")
	public int insertReview(HttpServletRequest request,
			@RequestParam("uploadFiles") MultipartFile[] uploadFiles,
			@RequestParam("reviewCn") String reviewCn,
			@RequestParam("rating") double rating,
			@RequestParam("rstrntCd") String rstrntCd,
			@RequestParam("visitDate") @DateTimeFormat(pattern="yyyy-MM-dd") Date visitDate) {
		
		MemberVO memberVO = (MemberVO)request.getSession().getAttribute("MBER_INFO");
		String mberId = memberVO.getMberId();
		log.info("insertReview -> mberId: " + mberId);
		
		ReviewVO reviewVO = ReviewVO.builder()
			.reviewCn(reviewCn)
			.rating(rating)
			.rstrntCd(rstrntCd)
			.visitDate(visitDate)
			.mberId(mberId)
			.uploadFiles(uploadFiles)
			.build();
				
		log.info("insertReview -> reviewVO: " + reviewVO);
		
		int result = boardService.insertReview(reviewVO);
		
		return result;
	}
	
	// 리뷰 수정
	@ResponseBody
	@PostMapping("/updateReview")
	public int updateReview(HttpServletRequest request,
			@RequestParam("uploadFiles") MultipartFile[] uploadFiles,
			@RequestParam("reviewCd") String reviewCd,
			@RequestParam("reviewCn") String reviewCn,
			@RequestParam("rating") double rating,
			@RequestParam("visitDate") @DateTimeFormat(pattern="yyyy-MM-dd") Date visitDate,
			@RequestParam(value="atchFileCd", required=false) String atchFileCd,
			@RequestParam("atchFileCds") String[] atchFileCds,
			@RequestParam("atchFileSns") String[] atchFileSns) {
		
		MemberVO memberVO = (MemberVO)request.getSession().getAttribute("MBER_INFO");
		String mberId = memberVO.getMberId();
		
		if(atchFileCd.equals("")) {
			atchFileCd = null;
		}
		
		ReviewVO reviewVO = ReviewVO.builder()
			.reviewCd(reviewCd)
			.reviewCn(reviewCn)
			.rating(rating)
			.visitDate(visitDate)
			.mberId(mberId)
			.uploadFiles(uploadFiles)
			.atchFileCd(atchFileCd)
			.build();
				
		log.info("updateReview -> reviewVO: " + reviewVO);
		
		int result = boardService.updateReview(reviewVO, atchFileCds, atchFileSns);
		
		return result;
	}
	
	// 리뷰 삭제
	@ResponseBody
	@PostMapping("/deleteReview")
	public int deleteReview(@RequestParam("reviewCd") String reviewCd,
							@RequestParam("atchFileCd") String atchFileCd) {
		log.info("deleteReview -> reviewCd: " + reviewCd);
		log.info("deleteReview -> atchFileCd: " + atchFileCd);
		
		int result = boardService.deleteReview(reviewCd, atchFileCd);
		
		return result;
	}
}
