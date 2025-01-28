package my.yogijogi.com.service.serviceImpl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.slf4j.Slf4j;
import my.yogijogi.com.mapper.BoardMapper;
import my.yogijogi.com.service.BoardService;
import my.yogijogi.com.vo.AtchFileVO;
import my.yogijogi.com.vo.RestaurantVO;
import my.yogijogi.com.vo.ReviewVO;

@Slf4j
@Service
public class BoardServiceImpl implements BoardService {

	@Autowired
	BoardMapper boardMapper;
	
	@Autowired
	String uploadFolder;
	
	// 맛집 리스트
	@Override
	public List<RestaurantVO> rstrntList(Map<String, Object> map) {
		return this.boardMapper.rstrntList(map);
	}
	
	// 맛집 정보 가져오기
	@Override
	public RestaurantVO rstrntDetail(String rstrntCd) {
		return this.boardMapper.rstrntDetail(rstrntCd);
	}
	
	// 맛집 리스트 수
	@Override
	public int getRstrntCount(String rstrntSort) {
		return this.boardMapper.getRstrntCount(rstrntSort);
	}
	
	// 리뷰 정보 가져오기
	@Override
	public List<ReviewVO> getReview(String rstrntCd) {
		return this.boardMapper.getReview(rstrntCd);
	}

	// 음식점 등록
	@Override
	public int insertRstrnt(RestaurantVO rstrntVO) {
		log.info("insertRstrnt -> rstrntVO(전): " + rstrntVO);
		
		// 업로드한 파일 가져오기
		MultipartFile mf = rstrntVO.getUploadFile();
		
		// 파일 이름 중복 방지를 위한 처리
		UUID uuid = UUID.randomUUID();
		
		// 첨부파일코드(기본키) 생성
		String atchFileCd = this.boardMapper.getAtchFileCd();
		log.info("insertRstrnt -> atchFileCd: " + atchFileCd);
		
		// 1. 첨부파일 테이블에 담을 데이터 처리
		AtchFileVO atchFileVO = AtchFileVO.builder()
			.atchFileCd(atchFileCd)
			.atchFileNm(mf.getOriginalFilename())
			.atchFileCours(uuid + "_" + mf.getOriginalFilename())
			.atchFileSn(1)
			.atchFileTy(mf.getContentType())
			.build();
		
		// 2. 음식점 테이블에 담을 데이터 처리
		rstrntVO = RestaurantVO.builder()
			.rstrntNm(rstrntVO.getRstrntNm())
			.rstrntAddr(rstrntVO.getRstrntAddr())
			.rstrntTel(rstrntVO.getRstrntTel())
			.rstrntMenu(rstrntVO.getRstrntMenu())
			.rstrntSort(rstrntVO.getRstrntSort())
			.rstrntDscrp(rstrntVO.getRstrntDscrp())
			.rstrntResve(rstrntVO.getRstrntResve())
			.rstrntPrkplce(rstrntVO.getRstrntPrkplce())
			.rstrntBsnTm(rstrntVO.getRstrntBsnTm())
			.atchFileCd(atchFileCd)
			.build();
		
		log.info("insertRstrnt -> rstrntVO(후): " + rstrntVO);
		
		try {
		    // 업로드할 파일 경로 설정
		    Path uploadPath = Paths.get(uploadFolder, "rstrnt", uuid + "_" + mf.getOriginalFilename());
		    
		    // 파일 복사
		    Files.copy(mf.getInputStream(), uploadPath);
		} catch (IOException e) {
		    e.printStackTrace();
		}
		
		log.info("insertRstrnt -> atchFileVO: " + atchFileVO);

		List<AtchFileVO> atchFileVOList = new ArrayList<AtchFileVO>();
		atchFileVOList.add(atchFileVO);
		
		// 1. 첨부파일 테이블 insert
		int result1 = boardMapper.insertAtchFile(atchFileVOList);
		
		// 2. 음식점 테이블 insert
		int result2 = boardMapper.insertRstrnt(rstrntVO);
		
		return result1 + result2;
	}
	
	// 음식점 수정
	@Override
	public int updateRstrnt(RestaurantVO rstrntVO) {
		log.info("updateRstrnt -> rstrntVO(전): " + rstrntVO);
		
		int result1 = 0;
		
		// 업로드한 파일 가져오기
		MultipartFile mf = rstrntVO.getUploadFile();
		
		// 업로드한 파일이 있을 때만 업로드 진행
		if(mf != null) {
			// 파일 이름 중복 방지를 위한 처리
			UUID uuid = UUID.randomUUID();
			
			// 1. 첨부파일 테이블에 담을 데이터 처리
			AtchFileVO atchFileVO = AtchFileVO.builder()
				.atchFileCd(rstrntVO.getAtchFileCd())
				.atchFileNm(mf.getOriginalFilename())
				.atchFileCours(uuid + "_" + mf.getOriginalFilename())
				.atchFileTy(mf.getContentType())
				.build();
			
			log.info("updateRstrnt -> rstrntVO(후): " + rstrntVO);
			
			try {
			    // 업로드할 파일 경로 설정
			    Path uploadPath = Paths.get(uploadFolder, "rstrnt", uuid + "_" + mf.getOriginalFilename());
			    
			    // 파일 복사
			    Files.copy(mf.getInputStream(), uploadPath);
			    
			} catch (IOException e) {
			    e.printStackTrace();
			}
			
			log.info("updateRstrnt -> atchFileVO: " + atchFileVO);

			// 1. 첨부파일 테이블 update
			result1 = boardMapper.updateAtchFile(atchFileVO);
		}
		
		// 2. 음식점 테이블 update
		int result2 = boardMapper.updateRstrnt(rstrntVO);
		
		return result1 + result2;
	}
	
	// 음식점 삭제
	@Override
	public int deleteRstrnt(String rstrntCd) {
		return this.boardMapper.deleteRstrnt(rstrntCd);
	}
	
	// 첨부파일 등록
	@Override
	public int insertAtchFile(List<AtchFileVO> atchFileVOList) {
		return this.boardMapper.insertAtchFile(atchFileVOList);
	}

	// 첨부파일코드 생성
	@Override
	public String getAtchFileCd() {
		return this.boardMapper.getAtchFileCd();
	}

	// 리뷰 등록
	@Override
	public int insertReview(ReviewVO reviewVO) {
		log.info("insertReview -> reviewVO(전): " + reviewVO);
		
		// 결과 값을 담을 변수 선언
		int result1 = 0;
		int result2 = 0;
		
		String atchFileCd = "";
		
		// 업로드한 파일 가져오기
		MultipartFile[] multipartFile = reviewVO.getUploadFiles();
		
		// 업로드한 파일이 있을 때만 업로드 진행
		if(multipartFile.length > 0) {
			// 첨부파일코드(기본키) 생성
			atchFileCd = this.boardMapper.getAtchFileCd();
			log.info("insertReview -> atchFileCd: " + atchFileCd);

			// 파일 이름 중복 방지를 위한 처리
			UUID uuid = UUID.randomUUID();
			
			int sn = 1; // 순번
			List<AtchFileVO> atchFileVOList = new ArrayList<AtchFileVO>(); // 첨부파일들을 담을 리스트
			
			for(MultipartFile mf : multipartFile) {
				// 1. 첨부파일 테이블에 담을 데이터 처리
				AtchFileVO atchFileVO = AtchFileVO.builder()
					.atchFileCd(atchFileCd)
					.atchFileNm(mf.getOriginalFilename())
					.atchFileCours(uuid + "_" + mf.getOriginalFilename())
					.atchFileSn(sn++)
					.atchFileTy(mf.getContentType())
					.mberId(reviewVO.getMberId())
					.build();
				
				atchFileVOList.add(atchFileVO);
				
				try {
					// 업로드할 파일 경로 설정
					Path uploadPath = Paths.get(uploadFolder, "review", uuid + "_" + mf.getOriginalFilename());
					
					// 경로가 존재하지 않으면 생성
			        if (!Files.exists(uploadPath)) {
			            Files.createDirectories(uploadPath);
			        }
					
					// 파일 복사
					Files.copy(mf.getInputStream(), uploadPath, StandardCopyOption.REPLACE_EXISTING);
				} catch (IOException e) {
					e.printStackTrace();
				}
			} // end for
			
			log.info("insertReview -> atchFileVOList: " + atchFileVOList);
			
			// 1. 첨부파일 테이블 insert
			result1 = boardMapper.insertAtchFile(atchFileVOList);
			
		}
		
		// 2. 음식점 테이블에 담을 데이터 처리
		reviewVO = ReviewVO.builder()
			.reviewCn(reviewVO.getReviewCn())
			.rating(reviewVO.getRating())
			.visitDate(reviewVO.getVisitDate())
			.rstrntCd(reviewVO.getRstrntCd())
			.mberId(reviewVO.getMberId())
			.atchFileCd(atchFileCd)
			.build();
		
		log.info("insertReview -> reviewVO(후): " + reviewVO);
		
		// 2. 음식점 테이블 insert
		result2 = boardMapper.insertReview(reviewVO);
		
		return result1 + result2;
		
	}

	// 첨부파일 목록 가져오기
	@Override
	public List<AtchFileVO> getAtchFileList(AtchFileVO atchFileVO) {
		return this.boardMapper.getAtchFileList(atchFileVO);
	}

	// 첨부파일 삭제
	@Override
	public int deleteAtchFile(List<AtchFileVO> atchFileVOList) {
		return this.boardMapper.deleteAtchFile(atchFileVOList);
	}

	// 리뷰 수정
	@Override
	public int updateReview(ReviewVO reviewVO,
			String[] atchFileCds, String[] atchFileSns) {
		log.info("updateReview -> reviewVO(전): " + reviewVO);
		
		String atchFileCd = reviewVO.getAtchFileCd();
		
		// 삭제할 첨부파일이 있는 경우 삭제 처리
		if(atchFileCds.length > 0) {
			List<String> atchFileCdList = Arrays.asList(atchFileCds);
			List<String> atchFileSnList = Arrays.asList(atchFileSns);
			log.info("atchFileSnList -> " + atchFileSnList);
			
			List<AtchFileVO> atchFileVOList = new ArrayList<AtchFileVO>();
			
			for (int i = 0; i < atchFileCdList.size(); i++) {
				AtchFileVO atchFileVO = AtchFileVO.builder()
					.atchFileCd(atchFileCdList.get(i))
					.atchFileSn(Integer.parseInt(atchFileSnList.get(i)))
					.build();
				
				atchFileVOList.add(atchFileVO);
			}
			
			log.info("updateReview -> atchFileVOList: " + atchFileVOList);
			
			boardMapper.deleteAtchFile(atchFileVOList);
		} // end if

		// 업로드한 파일 가져오기
		MultipartFile[] multipartFile = reviewVO.getUploadFiles();
		
		// 업로드한 파일이 있을 때만 업로드 진행
		if(multipartFile != null && multipartFile.length > 0) {
			
			// 첨부파일코드가 없는 경우(새로 업로드한 경우) 생성
			if(reviewVO.getAtchFileCd() == null) {
				atchFileCd = this.boardMapper.getAtchFileCd();
				log.info("updateReview -> atchFileCd: " + atchFileCd);
			}

			int sn = boardMapper.getAtchFileSn(atchFileCd); // 순번
			log.info("updateReview -> sn: " + sn++);
			
			List<AtchFileVO> atchFileVOList = new ArrayList<AtchFileVO>(); // 첨부파일들을 담을 리스트
			
			for(MultipartFile mf : multipartFile) {
				// 파일 이름 중복 방지를 위한 처리
				UUID uuid = UUID.randomUUID();

				// 1. 첨부파일 테이블에 담을 데이터 처리
				AtchFileVO atchFileVO = AtchFileVO.builder()
					.atchFileCd(atchFileCd)
					.atchFileNm(mf.getOriginalFilename())
					.atchFileCours(uuid + "_" + mf.getOriginalFilename())
					.atchFileSn(sn++)
					.atchFileTy(mf.getContentType())
					.mberId(reviewVO.getMberId())
					.build();
				
				atchFileVOList.add(atchFileVO);
				
				try {
					// 업로드할 파일 경로 설정
					Path uploadPath = Paths.get(uploadFolder, "review", uuid + "_" + mf.getOriginalFilename());
					
					// 경로가 존재하지 않으면 생성
			        if (!Files.exists(uploadPath)) {
			            Files.createDirectories(uploadPath);
			        }
					
					// 파일 복사
					Files.copy(mf.getInputStream(), uploadPath, StandardCopyOption.REPLACE_EXISTING);
					
				} catch (IOException e) {
					e.printStackTrace();
				}
			} // end for
			
			log.info("updateReview -> atchFileVOList: " + atchFileVOList);

			boardMapper.insertAtchFile(atchFileVOList);
		}
		
		// 기존에 있던 첨부파일을 모두 삭제했을 경우 처리
		int atchFileCount = boardMapper.atchFileCount(atchFileCd); // 첨부파일 개수 구하기
		
		if(atchFileCount == 0) {
			atchFileCd = null; // 첨부파일코드를 null 처리
		}
		
		reviewVO = ReviewVO.builder()
			.reviewCd(reviewVO.getReviewCd())
			.reviewCn(reviewVO.getReviewCn())
			.rating(reviewVO.getRating())
			.visitDate(reviewVO.getVisitDate())
			.mberId(reviewVO.getMberId())
			.uploadFiles(reviewVO.getUploadFiles())
			.atchFileCd(atchFileCd)
			.build();
		
		log.info("insertReview -> reviewVO(후): " + reviewVO);
		
		return boardMapper.updateReview(reviewVO);
	}

	// 순번 구하기
	@Override
	public int getAtchFileSn(String atchFileCd) {
		return this.boardMapper.getAtchFileSn(atchFileCd);
	}

	// 리뷰 삭제
	@Override
	public int deleteReview(String reviewCd, String atchFileCd) {
		// 리뷰에 있던 첨부파일도 삭제
		boardMapper.deleteAllAtchFile(atchFileCd);
		
		return this.boardMapper.deleteReview(reviewCd);
	}

	// 리뷰 삭제 -> 첨부파일 삭제
	@Override
	public int deleteAllAtchFile(String atchFileCd) {
		return this.boardMapper.deleteAllAtchFile(atchFileCd);
	}

	// 첨부파일 업데이트
	@Override
	public int updateAtchFile(AtchFileVO atchFileVO) {
		return this.boardMapper.updateAtchFile(atchFileVO);
	}

	// 첨부파일 개수 구하기
	@Override
	public int atchFileCount(String atchFileCd) {
		return this.boardMapper.atchFileCount(atchFileCd);
	}

	// 연관된 맛집 리스트
	@Override
	public List<RestaurantVO> getRelatedRstrnt(String rstrntSort) {
		return this.boardMapper.getRelatedRstrnt(rstrntSort);
	}

}
