package com.shinhanez.controller;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itextpdf.html2pdf.ConverterProperties;
import com.itextpdf.html2pdf.HtmlConverter;
import com.itextpdf.html2pdf.resolver.font.DefaultFontProvider;
import com.itextpdf.kernel.pdf.PdfReader;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Image;
import com.itextpdf.io.image.ImageData;
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.layout.font.FontProvider;
import com.shinhanez.admin.domain.Contracts;
import com.shinhanez.admin.domain.Customer;
import com.shinhanez.admin.service.ContractService;
import com.shinhanez.admin.service.CustomerService;
import com.shinhanez.domain.ShezUser;
import com.shinhanez.domain.UserAdminDetails;
import com.shinhanez.service.ShezUserService;
import com.shinhanez.service.UserContractsService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/userContract/*")
@RequiredArgsConstructor
public class UserContractsController {
	private final ShezUserService shezUserService;
	private final UserContractsService userContractsSevice;
	private final ContractService contractService;
	private final CustomerService customerService;
	
	/* ============================================ 보험 신규 계약 부분 ============================================ */
    /* 인증계정 가져오기 */
    @GetMapping("/authInfo")
    @ResponseBody
    public ShezUser authInfo(Authentication authentication) {
        ShezUser user = null;
        if (authentication != null) {
        	Object principal = authentication.getPrincipal(); 
        	
        	if (principal instanceof UserAdminDetails) { 
        		// 폼 로그인 사용자 
        		user = ((UserAdminDetails) principal).getUser(); 
        		
    		} else if (principal instanceof OAuth2User) { 
    			// OAuth2 로그인 사용자 
    			OAuth2User oauth2User = (OAuth2User) principal;
    			String email = oauth2User.getAttribute("email");
    			user = shezUserService.findById(email);
			} 
    	}
        return user;
    }
    @GetMapping("/rest/{id}")
    @ResponseBody
    public Customer getCustomerByLoginId(@PathVariable String id) {
    	return userContractsSevice.getCustomerByLoginId(id);
    }
    @GetMapping("/rest/{name}/{phone}")
    @ResponseBody
    public Customer getCustomerByNamePhone(@PathVariable String name, @PathVariable String phone) {
    	return userContractsSevice.getCutomerByNamePhone(name, phone);
    }
    @GetMapping("/rest/search/insured")
    @ResponseBody
    public List<Customer> GetCustomersByName(@RequestParam String name) {
    	return userContractsSevice.getCustomersByName(name);
    }
    @GetMapping("/rest/newCustomerId")
    @ResponseBody
    public String newCusomerId() {
    	return userContractsSevice.newCustomerId();
    }
    @PostMapping("/rest/registerCustomer")
    @ResponseBody
    public Map<String, Object> registerNewCustomer(@RequestBody Customer customer) {
    	customer.setRole("Y");
    	int result = userContractsSevice.joinNewCustomer(customer);
    	Map<String, Object> resultMap = new HashMap<>();
    	resultMap.put("customerId", customer.getCustomerId());
    	resultMap.put("result",result);
    	return resultMap;
    }
    @PostMapping("/rest/registerInsured")
    @ResponseBody
    public Map<String, Object> registerNewInsured(@RequestBody Customer customer) {
    	customer.setRole("Y");
    	int result = userContractsSevice.joinNewCustomer(customer);
    	Map<String, Object> resultMap = new HashMap<>();
    	resultMap.put("insuredId", customer.getCustomerId());
    	resultMap.put("result",result);
    	return resultMap;
    }
    @PostMapping("/rest/userRegisterContract")
    @ResponseBody
    public Map<String, Object> userRegisterContract(@RequestBody Contracts contract) {
    	userContractsSevice.userRegisterContracts(contract);
    	// 계약번호 반환
    	Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("contractId", contract.getContractId());
        resultMap.put("success", true);
        return resultMap;
    }
    
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
        
        // 날짜 포맷팅
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy년 MM월 dd일 E요일", Locale.KOREAN);
        SimpleDateFormat birthformatter = new SimpleDateFormat("yyyy년 MM월 dd일", Locale.KOREAN);
        DateTimeFormatter signDateformatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH:mm:ss", Locale.KOREAN);
        String formattedRegDate = contract.getRegDate() != null ? 
        		formatter.format(contract.getRegDate()) : "";
        String formattedExpiredDate = contract.getExpiredDate() != null ? 
            	formatter.format(contract.getExpiredDate()) : "";
        String formattedCustomerBirth = customer.getBirthDate() != null ? 
        		birthformatter.format(customer.getBirthDate()) : "";
        String formattedInsuredBirth = insured.getBirthDate() != null ? 
        		birthformatter.format(insured.getBirthDate()) : "";
        String formattedSignedDate = contract.getSignedDate() != null ? 
        		contract.getSignedDate().format(signDateformatter) : "";
        // JST -> HTML
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
        // 사인 추가
        if (signImage != null && signImage.startsWith("data:image")) {
        	try {
        		
        	byte[] pdfBytes = baos.toByteArray();
            baos.reset();
            
            String base64 = signImage.split(",")[1];
            byte[] imageBytes = Base64.getDecoder().decode(base64);

            PdfReader reader = new PdfReader(new ByteArrayInputStream(pdfBytes));
            PdfWriter writer = new PdfWriter(baos);
            PdfDocument pdfDoc = new PdfDocument(reader, writer);
            
            Document document = new Document(pdfDoc);
            
            ImageData imageData = ImageDataFactory.create(imageBytes);
            Image imageFormatSign = new Image(imageData)
                    .setWidth(160)
                    .setFixedPosition(
                            pdfDoc.getNumberOfPages(),
                            400,   // X
                            305,   // Y
                            160    // Width
                    );

            document.add(imageFormatSign);
            document.close();
        	} catch (Exception e) {
                e.printStackTrace();
                throw e;
            }
        } 
        
        String filename = contract.getCustomerName() + "_" + contract.getProductName() + " 계약서.pdf";
        String encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
        String disposition = "inline; filename*=UTF-8''" + encodedFilename;

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,disposition)
                .contentType(MediaType.APPLICATION_PDF)
                .body(baos.toByteArray());
    }
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
    // 한글깨짐 방지, 폰트 설정
    private FontProvider fontProvider() {

        FontProvider provider = new DefaultFontProvider(false, false, false);

        ClassLoader cl = Thread.currentThread().getContextClassLoader();
        URL fontUrl = cl.getResource("fonts/NotoSansKR-Regular.ttf");

        provider.addFont(fontUrl.toExternalForm());

        return provider;
    }

}
