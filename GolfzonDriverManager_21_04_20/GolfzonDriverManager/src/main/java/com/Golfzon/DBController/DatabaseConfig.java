package com.Golfzon.DBController;

import javax.servlet.MultipartConfigElement;
import javax.sql.DataSource;

import org.apache.catalina.Context;
import org.apache.catalina.Wrapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.boot.web.embedded.tomcat.TomcatContextCustomizer;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.transaction.annotation.EnableTransactionManagement;


@Configuration
// @MapperScan(basePackages="com.Golfzon.DBController")
@EnableTransactionManagement
public class DatabaseConfig {
 
    @Bean
    public  SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sessionFactory.setMapperLocations(resolver.getResources("classpath:com/Golfzon/DBController/Db.xml"));
        return sessionFactory.getObject();
    }
    
    @Bean
    public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception {
      final SqlSessionTemplate sqlSessionTemplate = new SqlSessionTemplate(sqlSessionFactory);
      return sqlSessionTemplate;
    }
    
    @Bean
    MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        factory.setMaxFileSize("850MB");
        factory.setMaxRequestSize("850MB");
        return factory.createMultipartConfig();
    }
        
    public static class TomcatJspServletConfig implements TomcatContextCustomizer {
        @Override
        public void customize(Context context) {
            // TomcatEmbeddedServletContainerFactory??? ????????? JspServlet??? ????????? "jsp"
            Wrapper jsp = (Wrapper)context.findChild("jsp");
            // JspServlet??? ??????????????? ????????????
            // ???????????? application.properties ????????? ????????? ??? ?????? ???????????? ???????????? ??????
            jsp.addInitParameter("development", "false");
        }
    }
 
}
