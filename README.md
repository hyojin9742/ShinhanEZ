# ShinhanEZ
---
# 개요

- Github : https://github.com/hyojin9742/ShinhanEZ

## 목적

- 모바일 앱 연결을 위한 QR코드를 보여주기만 하는 페이지에서 벗어나 사용자를 위한 기본적인 기능을 추가
- 모바일 앱과 동일한 사용자 경험을 위해 PC 페이지에 기능 추가

## 개발 환경

- JAVA
- Spring Boot
- Oracle DB
- AWS
- JSP

- Spring Security
- MyBatis
- Lombok
- iText
- chart.js

## 팀 구성 및 역할

|  | 사용자 페이지 | 관리자 페이지 |
| --- | --- | --- |
| 김현수 |   • 메인, 미디어룸
  • Toss Payments 결제 기능 |   • 관리자 페이지 템플릿
  • 납입내역 |
| 신태양 |   • 보험금 청구
  • 청구 서류 업로드 기능 |   • 청구내역 |
| 안종범 |   • 보험 상품 설명 |   • 대시보드
  • 보험 상품 목록 |
| 유일송 |   • 사회공헌 |   • 고객 목록
  • 공지사항 |
| 정효진 |   • 로그인, 회원가입
  • 챗봇, 보험 추천 기능
  • 보험 계약 기능
  • 계약서 PDF 다운로드 |   • Spring Security
  • 계약 내역
  • 관리자 목록 |

# ERD

![ShinhanEZ_ERD.png](attachment:017e198f-3b4c-44cb-a5c3-ed02c73257a9:ShinhanEZ_ERD.png)

# 주요 기능

## 로그인, 회원가입

![image.png](attachment:529d6d69-eadd-4d06-bdd2-95c506306399:image.png)

![image.png](attachment:c123630e-68ec-44ce-bb36-0d3469e9e356:image.png)

#### 기능소개

- 정보 미 입력 시 회원가입 불가
- 간편 인증 로그인과 DB 로그인 가능
- 간편 인증 로그인은 게시판 글 작성, 보험 계약 등을 사용하기 위해서는 추가 정보 필요

#### 작업내용

- 로그인 : Spring Security를 이용하여 API 호출 & 처리
    
    
    |  | API | Method |
    | --- | --- | --- |
    | 로그인 페이지 이동 | /member/login | GET |
    | 로그인 | /member/loginProc | POST |
    | 로그아웃 | /member/logout | GET |
- 회원가입 처리
    - ID 중복 체크
    - 비밀번호 암호화 : BCrypt 이용
    
    ```java
        // 회원가입 처리
        @PostMapping("/join")
        public String join(ShezUser user, Model model) {
            // 현재 인증 정보 가져오기
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            boolean isOAuthUser = false;
            
            // OAuth 사용자인지 확인
            if (auth != null && auth.isAuthenticated()) {
                isOAuthUser = auth.getAuthorities().stream()
                        .map(GrantedAuthority::getAuthority)
                        .anyMatch(role -> role.equals("ROLE_OAUTH"));
            }
            // ID 중복 체크
            if (!isOAuthUser && userService.isDuplicateId(user.getId())) {
                model.addAttribute("error", "이미 사용중인 아이디입니다.");
                return "member/join";
            }
            // 비밀번호 암호화
            if (user.getPw() != null && !user.getPw().isEmpty()) {
                String encodedPw = passwordEncoder.encode(user.getPw());
                user.setPw(encodedPw);
            }
    
            int result = userService.join(user);
            
            if (result > 0) {
                // OAuth 사용자의 경우
                if (isOAuthUser) {
                    // ROLE_USER 권한으로 업데이트
                    OAuth2User oauth2User = (OAuth2User) auth.getPrincipal();
                    
                    DefaultOAuth2User newOAuth2User = new DefaultOAuth2User(
                        Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")),
                        oauth2User.getAttributes(),
                        "sub"
                    );
                    
                    Authentication newAuth = new UsernamePasswordAuthenticationToken(
                        newOAuth2User,
                        auth.getCredentials(),
                        Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"))
                    );
                    
                    SecurityContextHolder.getContext().setAuthentication(newAuth);
                    
                    return "redirect:/";
                } else {
                    // 일반 회원가입은 로그인 페이지로
                    return "redirect:/member/login?join=success";
                }
            } else {
                model.addAttribute("error", "회원가입에 실패했습니다.");
                return "member/join";
            }
        }
    ```
    

## 게시판 + 공지사항

![image.png](attachment:87dad473-ad79-43dd-a193-6ca4bc9f82ec:image.png)

![image.png](attachment:e53929d9-da3d-4f84-a721-69f6de91fd5c:image.png)

#### 기능소개

- DB로그인한 사용자가 게시판 글쓰기, 수정, 삭제 가능
    - 글 삭제는 비활성화 처리
    - 간편 인증 로그인한 사용자는 추가 정보 입력 후 글쓰기, 수정, 삭제 가능
    - 관리자가 작성한 공지사항 확인 가능
    - 관리자는 공지사항과 사용자가 작성한 글 삭제 가능

#### 작업내용

- 글 목록 : Model 이용하여 페이지에 전달
    
    ```java
    // 목록 (로그인 없이 조회 가능)
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int pageNum,
                       @RequestParam(required = false) String keyword,
                       Model model) {
        Map<String, Object> result = boardService.getBoardList(pageNum, keyword);
        model.addAttribute("boardList", result.get("list"));
        model.addAttribute("paging", result.get("paging"));
        model.addAttribute("keyword", keyword);
        return "pages/media_room";
    }
    ```
    
- 글 삭제 - 비활성화 처리
    
    ```sql
    <!-- 삭제 -->
    <delete id="deleteBoard">
        UPDATE shez_board SET status = 'N' WHERE idx = #{idx}
    </delete>
    ```
    
- 글 수정, 삭제 시 권한 확인 - 글 작성한 본인이거나 관리자만 가능

```java
// 본인 글이 아니고 관리자도 아니면 수정 거부
Board existingBoard = boardService.getBoard(idx);
if (!user.getId().equals(existingBoard.getId()) && !"ROLE_ADMIN".equals(user.getRole())) {
    return "redirect:/board/list?error=permission";
}
```

## 보험 계약

#### 기능소개

- 사용자가 원하는 보험을 선택하여 계약 진행 가능
- 모달 오픈 시 사용자의 정보 및 선택한 보험 정보 자동 입력
    
    ![image.png](attachment:5d5379d3-8210-464c-b369-6e9c73875ce0:image.png)
    
- 계약시 계약자, 피보험자가 DB에 등록되어 있는 고객인지 확인 후 신규 고객이라면 등록 진행
- 피보험자가 기존 고객인 경우 이름 입력으로 조회, 선택 가능
    
    ![image.png](attachment:e3999671-9d2c-47a5-9938-1a2f51c25d62:image.png)
    
- 상품에 따른 특약사항 체크박스로 선택가능
- 사인과 이름 서명까지 완료해야 계약 가능
- 사인과 서명 완료 후 계약 내용 변경 불가
    
    
    ![image.png](attachment:db53045b-279f-4018-af88-2f2d095f6b81:image.png)
    
    ![image.png](attachment:0d7538a8-a911-4ce6-928b-01730eb08769:image.png)
    
- 계약서 PDF로 확인 및 다운로드 가능 + 관리자 페이지에서 계약서 확인 가능
    
    ![image.png](attachment:1b7cb1b3-805d-4961-9fd7-e530bf827569:image.png)
    

#### 작업내용

- 사용자 정보, 보험 특약 체크박스 표시 : REST 이용하여 렌더링
- 피보험자 검색
    - setTimeout 이용, 입력 후 300ms 지나서 표시
        
        ```jsx
        // 검색이벤트
        $(document).on('input', '#insuredName',function() {
            const searchTerm = $(this).val().trim();
            // 기존 선택 초기화
            if (selectedInsured && selectedInsured.name !== searchTerm) {
                selectedInsured = null;
                $('#insuredId').val('');
                clearInsuredFields();
            }
            clearTimeout(insuredTimeout);    
            insuredTimeout = setTimeout(function() {
                searchInsured(searchTerm);
            }, 300);
        });
        ```
        
- 사인
    - HTML5 캔버스 서명 구현
        
        ```jsx
        $(canvas).on("mousemove", function (e) {
            if (!drawing) return;
        	drawCount++;
        	ctx.lineWidth = 2;
        	ctx.lineCap = "round";
        	ctx.strokeStyle = "#000";
            const pos = getMousePos(e);
            ctx.lineTo(pos.x, pos.y);
            ctx.stroke();
        });
        ```
        
    - 사인 완료 전 일정 길이 이상 입력과 키보드로 이름을 입력하도록 검증
- PDF 생성 : iText 사용하여 템플릿(contractPdf.jsp)에 맞추어 PDF 생성
    
    ```java
      /* =================== PDF 다운로드 ========================= */
      // 계약서 다운로드
      @GetMapping("/downloadPdf/{contractId}")
      public ResponseEntity<byte[]> downloadPdfRest(
              @PathVariable int contractId,
              @RequestParam(required = false, defaultValue = "false") boolean download,
              HttpServletRequest request,
              HttpServletResponse response) throws Exception {
      	                
          Contracts contract = contractService.readOneContract(contractId);
          Customer customer = customerService.findById(contract.getCustomerId());
          Customer insured = customerService.findById(contract.getInsuredId());
          String signImage = contract.getSignImage();
          
          // 날짜 포맷팅 생략
          // JSP -> HTML
          String html = jspToHtml(
                  request, response,
                  "/WEB-INF/views/product/contractPdf.jsp",
                  Map.of("contract", contract, 
                  		"customer",customer,
                  		"insured", insured,
                  		"formattedRegDate",formattedRegDate,
                  		"formattedExpiredDate",formattedExpiredDate,
                  		"formattedCustomerBirth",formattedCustomerBirth,
                  		"formattedInsuredBirth",formattedInsuredBirth,
                  		"formattedSignedDate",formattedSignedDate)
          );
          ByteArrayOutputStream baos = new ByteArrayOutputStream();
    
          ConverterProperties props = new ConverterProperties();
          props.setCharset("UTF-8");
          props.setFontProvider(fontProvider());     	
          HtmlConverter.convertToPdf(html, baos, props);
          // 사인 추가 생략
          if (signImage != null && signImage.startsWith("data:image")) {...}
      /* JSP -> HTML 변환 */
      public String jspToHtml(HttpServletRequest request, 
      		HttpServletResponse response,
      		String jspPath, 
      		Map<String, Object> model) throws Exception {
    
    	for (String key : model.keySet()) {
    		request.setAttribute(key, model.get(key));
    	}
    		
    	RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
    	
    	StringWriter sw = new StringWriter();
    	HttpServletResponseWrapper responseWrapper =
    	        new HttpServletResponseWrapper(response) {
    	            @Override
    	            public PrintWriter getWriter() {
    	                return new PrintWriter(sw);
    	            }
    	        };
    	
    	dispatcher.include(request, responseWrapper);
    	return sw.toString();
    }
      // 한글깨짐 방지, 폰트 설정 생략
      private FontProvider fontProvider() {...}
    }
    ```
    

## 보험금 청구

#### 기능소개

- 사용자가 보험금 청구 신청 시 사용자가 보유한 보험 중 선택하여 신청
    
    ![image.png](attachment:5323101e-8d2e-4fb3-80f0-cfa8c114a67d:image.png)
    
- 보험금 신청 후 마이페이지에서 필요서류 업로드 가능
    
    
    ![image.png](attachment:3bcd00e9-0f74-44fe-b641-e81f109b79a6:image.png)
    
    ![image.png](attachment:b580bc4d-453a-4b77-a843-f6a7295c951d:image.png)
    
- 관리자는 관리자 페이지 청구목록에서 업로드한 서류 확인 및 청구 지급 처리 가능
    
    
    ![image.png](attachment:7d8a88bf-5b6a-4785-8e93-55dd18c5a765:image.png)
    
    ![image.png](attachment:111a4fac-4726-4ac0-ba3e-ac0b3cf58b8d:image.png)
    

#### 작업내용

- REST 이용 사용자의 계약 조회 후 계약 선택 시 폼 채우도록 구현
    
    ```jsx
      // === (3) REST 호출 + 렌더 ===
      async function loadContracts() {
        clearRows();
        showMsg("계약 정보를 불러오는 중입니다...");
        try {
          const res = await fetch("/user/claims/contracts", {
            method: "GET",
            headers: { "Accept": "application/json" },
            credentials: "same-origin",
          });
          if (res.status === 401) {
            showMsg("로그인이 필요합니다.");
            return;
          }
          if (!res.ok) {
            showMsg(`계약 조회에 실패했습니다. (HTTP ${res.status})`);
            return;
          }
          const list = await res.json();
    
          if (!Array.isArray(list) || list.length === 0) {
            showMsg("조회된 계약이 없습니다.");
            return;
          }
          showMsg("");
          list.forEach((c) => {
            // Contracts DTO 필드 그대로 사용
            const tr = document.createElement("tr");
            tr.dataset.contractId = c.contractId;
            tr.innerHTML = `
              <td>${escapeHtml(c.contractId)}</td>
              <td>${escapeHtml(c.customerName)}</td>
              <td>${escapeHtml(c.insuredName)}</td>
              <td>${escapeHtml(c.productName)}</td>
              <td>${escapeHtml(c.contractCoverage)}</td>
              <td>${escapeHtml(formatDate(c.regDate))}</td>
              <td>${escapeHtml(statusLabel(c.contractStatus))}</td>
            `;
            tr.addEventListener("click", () => {
              // 선택 표시
              tbody.querySelectorAll("tr").forEach((row) => row.classList.remove("is-selected"));
              tr.classList.add("is-selected");
    
              selectedContract = c;
              if (confirmBtn) confirmBtn.disabled = false;
            });
            tbody.appendChild(tr);
          });
          // 첫 번째 자동 선택(원치 않으면 제거)
          const firstRow = tbody.querySelector("tr");
          if (firstRow) firstRow.click();
        } catch (e) {
          showMsg("네트워크 오류로 계약 정보를 불러오지 못했습니다.");
        }
      }
    ```
    
- REST로 파일 업로드 처리
    
    ```jsx
    /** ====== Upload from Modal ====== */
    document.getElementById("btnUploadFiles")?.addEventListener("click", async () => {
      if (!currentClaimId) return;
    
      const input = document.getElementById("filesModalInput");
      const statusEl = document.getElementById("filesUploadStatus");
      const files = input.files;
    
      if (!files || files.length === 0) {
        statusEl.innerHTML = `<span style="color:#666;">업로드할 파일을 선택해 주세요.</span>`;
        return;
      }
    
      // 프론트 확장자 1차 체크
      const allowExt = ["pdf", "jpg", "jpeg", "png"];
      for (const f of files) {
        const ext = (f.name.split(".").pop() || "").toLowerCase();
        if (!allowExt.includes(ext)) {
          statusEl.innerHTML = `<span style="color:#b02a37;">허용되지 않는 파일 형식: ${escapeHtml(f.name)}</span>`;
          return;
        }
      }
    
      const btn = document.getElementById("btnUploadFiles");
      btn.disabled = true;
      statusEl.innerHTML = `<span style="color:#666;">업로드 중...</span>`;
    
      try {
        const form = new FormData();
        for (const f of files) form.append("files", f);
    
        const res = await fetch(`/user/claims/${encodeURIComponent(currentClaimId)}/files`, {
          method: "POST",
          body: form
        });
    
        if (res.status === 401) {
          statusEl.innerHTML = `<span style="color:#b02a37;">로그인이 필요합니다.</span>`;
          return;
        }
    
        if (!res.ok) {
          const msg = await safeReadText(res);
          throw new Error(msg || `HTTP ${res.status}`);
        }
    
        statusEl.innerHTML = `<span style="color:#0f5132; font-weight:600;">업로드 완료!</span>`;
        input.value = "";
    
        await loadFilesList(currentClaimId);
    
        // 메인 목록도 최신화(첨부 개수 표시 등을 하게 되면 필요)
        // await loadClaims();
    
      } catch (err) {
        console.error(err);
        statusEl.innerHTML = `<span style="color:#b02a37;">업로드 실패: 파일 형식/용량을 확인해 주세요.</span>`;
      } finally {
        btn.disabled = currentUploadDisabled; // 승인 상태면 다시 잠금 유지
      }
    }
    ```
    

## 보험료 납입

#### 기능소개

- 사용자는 마이페이지에서 납입하려는 보험료 항목을 선택하여 결제 가능
    
    ![image.png](attachment:aa353ea5-f756-4788-a14c-12c361c71f26:image.png)
    
- 카드, 계좌이체, 가상계좌를 통한 결제 가능
    
    ![image.png](attachment:23229cbc-24e9-4ea0-b749-f833de8eb99f:image.png)
    
- 결제가 성공적으로 완료되면 납입 상태가 변경

#### 작업내용

- Toss Payments API 이용 결제 기능 구현
    
    ```jsx
    /* Config */
    // 토스페이먼츠 API URL
    public static final String TOSS_API_URL = "https://api.tosspayments.com/v1/payments";
    
    /* Service */
    public TossPaymentService() {
        this.webClient = WebClient.builder()
                .baseUrl(TossPaymentsConfig.TOSS_API_URL)
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                .build();
        this.gson = new Gson();
    }
    ```
    

## 관리자 페이지

#### 기능소개

- 대시보드를 통해 계약 개수, 계약 비중 등을 그래프로 확인 가능
    
    ![image.png](attachment:d6213933-c33c-48e6-9899-71229862d424:image.png)
    
- 관리자는 고객, 보험 상품, 보험 계약 내역, 보험금 청구 내역, 보험료 납입 내역, 관리자 목록을 확인, 추가, 수정, 삭제 가능
    
    ![image.png](attachment:4e6d576d-8bee-4d20-95af-c9e456984496:image.png)
    

#### 작업내용

- chart.js 이용하여 대시보드 구현
    - `<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>`
    
    ```jsx
    // 월별 계약 수 차트
    let monthLabels=[];
    let monthData=[];
    chart=new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: monthLabels,
            datasets: [{
                label: '계약 수',
                data: monthData,
                backgroundColor: [ '#ffc107','#0d6efd','#198754','#fd7e14', '#6f42c1','#0dcaf0','#d63384','#adb5bd', '#6610f2','#fd198c','#198754','#0d6efd' ]
            }]
        },
        options: { 
            responsive: true,
            plugins: { legend: { display: false } },
    	scales: {
    	            y: {
    	                beginAtZero: true,
    	                ticks: {
    	                    stepSize: 1,
    	                    precision: 0 
    	                }
    	            }
    	        }	
        }
    });
    ```
    

# 트러블 슈팅

### 1. 간편인증(구글 로그인) Authorization 객체 권한 문제

- Spring Security에서 간편인증 로그인을 DB로그인과 동일한 권한(ROLE_USER)를 부여하여 구분이 안되는 문제 발생
- 의도한 동작
    
    → 간편인증 로그인의 경우  게시판 확인까지만 가능하고 글쓰기, 수정 등의 동작의 경우 추가 정보 기입을 통해 DB에 저장 후 글쓰기, 수정 등 가능
    
- 실제 동작
    
    → 간편 인증 로그인도 ROLE_USER가 부여되어 추가 정보 없이도 글쓰기와 수정 등이 가능
    
- 해결
    
    → 간편인증 로그인을 처리하기 위한 별도의 handler를 추가해 로그인 성공시 ROLE_OAUTH 부여 후 추가 정보 기입 시 ROLE_USER로 변경되도록 구현
    
    ```java
    public PrincipalOAuth2UserDetails(Map<String, Object> attributes, String nameAttributeKey) {
        this.attributes = attributes;
        this.nameAttributeKey = nameAttributeKey;
        this.role = "ROLE_OAUTH";
    }
    ```
    

### 2. 원래 경로로 돌아가기 처리 문제

- Spring Security를 프로젝트 작업 뒷부분에서 추가하면서 기존에 구현했던 로그인 후 원래 경로로 돌아가는 로직이 작동하지 않는 문제 발생
- 의도한 동작
    
    → 사용자가 미로그인 혹은 권한 없는 아이디로 로그인 후 권한이 필요한 페이지에 접근 시 우선 로그인 페이지로 이동하여 로그인 완료 후 이동하려던 페이지로 이동
    
- 실제 동작
    
    → 기존 Redirect로 작성했던 경로 이동 메서드들이 동작하지 않음
    
- 해결
    
    → Success Handler에서 SavedRequestAwareAuthenticationSuccessHandler를 상속하여 로그인 성공시 원래 경로로 이동
  ```java
public class LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler{
	
	private final AdminService adminService;

	public LoginSuccessHandler(AdminService adminService) {...}
	
	@Override
	public void onAuthenticationSuccess(
			HttpServletRequest request, 
			HttpServletResponse response,
			Authentication authentication
			) throws IOException, ServletException { ... }
            
            super.onAuthenticationSuccess(request, response, authentication);
	}

}
```
