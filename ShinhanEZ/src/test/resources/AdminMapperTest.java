import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.shinhanez.admin.mapper.AdminMapper;

@Transactional
@SpringBootTest
public class AdminMapperTest {
	private AdminMapper mapper;
	@Autowired
	public AdminMapperTest() {
		this.mapper = mapper;
	}
}
