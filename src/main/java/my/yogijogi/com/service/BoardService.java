package my.yogijogi.com.service;

import java.util.List;
import java.util.Map;

import my.yogijogi.com.vo.AtchFileVO;
import my.yogijogi.com.vo.RestaurantVO;
import my.yogijogi.com.vo.ReviewVO;

public interface BoardService {

	// 맛집 리스트
	public List<RestaurantVO> rstrntList(Map<String, Object> map);

	// 맛집 정보 가져오기
	public RestaurantVO rstrntDetail(String rstrntCd);
	
	// 맛집 리스트 수
	public int getRstrntCount(String rstrntSort);

	// 리뷰 정보 가져오기
	public List<ReviewVO> getReview(String rstrntCd);
	
	// 연관된 맛집 리스트
	public List<RestaurantVO> getRelatedRstrnt(String rstrntSort);

	// 음식점 등록
	public int insertRstrnt(RestaurantVO rstrntVO);
	
	// 음식점 수정
	public int updateRstrnt(RestaurantVO rstrntVO);
	
	// 음식점 삭제
	public int deleteRstrnt(String rstrntCd);
	
	// 첨부파일 등록
	public int insertAtchFile(List<AtchFileVO> atchFileVOList);
	
	// 첨부파일코드 생성
	public String getAtchFileCd();

	// 리뷰 등록
	public int insertReview(ReviewVO reviewVO);

	// 첨부파일 목록 가져오기
	public List<AtchFileVO> getAtchFileList(AtchFileVO atchFileVO);

	// 특정 첨부파일 삭제
	public int deleteAtchFile(List<AtchFileVO> atchFileVOList);

	// 리뷰 수정
	public int updateReview(ReviewVO reviewVO, String[] atchFileCds, String[] atchFileSns);
	
	// 순번 구하기
	public int getAtchFileSn(String atchFileCd);

	// 리뷰 삭제
	public int deleteReview(String reviewCd, String atchFileCd);

	// 리뷰 삭제 -> 첨부파일 삭제
	public int deleteAllAtchFile(String atchFileCd);
	
	// 음식점 첨부파일 수정
	public int updateAtchFile(AtchFileVO atchFileVO);
	
	// 첨부파일 개수 구하기
	public int atchFileCount(String atchFileCd);

}
