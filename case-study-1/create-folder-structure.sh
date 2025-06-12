#!/bin/bash

# Create base folder
BASE_DIR="currency-exchange-sample-service"

# Clean if already exists
rm -rf $BASE_DIR

# Create folders
mkdir -p $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice
mkdir -p $BASE_DIR/src/main/resources
mkdir -p $BASE_DIR/src/test/java/com/gfg/microservices/currencyexchangesampleservice
mkdir -p $BASE_DIR/k8s/dev
mkdir -p $BASE_DIR/k8s/qa
mkdir -p $BASE_DIR/k8s/prod

# CurrencyExchangeServiceSampleApplication.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/CurrencyExchangeServiceSampleApplication.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CurrencyExchangeServiceSampleApplication {
        public static void main(String[] args) {
                SpringApplication.run(CurrencyExchangeServiceSampleApplication.class, args);
        }
}
EOL

# ExchangeValue.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/ExchangeValue.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class ExchangeValue {

        @Id
        private Long id;

        @Column(name = "currency_from")
        private String from;

        @Column(name = "currency_to")
        private String to;

        private Double conversionMultiple;

        public ExchangeValue() {}

        public ExchangeValue(Long id, String from, String to, Double conversionMultiple) {
                this.id = id;
                this.from = from;
                this.to = to;
                this.conversionMultiple = conversionMultiple;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getFrom() { return from; }
        public void setFrom(String from) { this.from = from; }
        public String getTo() { return to; }
        public void setTo(String to) { this.to = to; }
        public Double getConversionMultiple() { return conversionMultiple; }
        public void setConversionMultiple(Double conversionMultiple) { this.conversionMultiple = conversionMultiple; }
}
EOL

# ExchangeValueRepository.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/ExchangeValueRepository.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ExchangeValueRepository extends JpaRepository<ExchangeValue, Long> {
        ExchangeValue findByFromAndTo(String from, String to);
}
EOL

# CurrencyExchangeSampleController.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/CurrencyExchangeSampleController.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CurrencyExchangeSampleController {

        @Autowired
        private ExchangeValueRepository repository;

        @GetMapping("/currency-exchange/from/{from}/to/{to}")
        public ExchangeValue retrieveExchangeValue(@PathVariable String from, @PathVariable String to) {
                return repository.findByFromAndTo(from, to);
        }
}
EOL

# application.properties
cat > $BASE_DIR/src/main/resources/application.properties <<'EOL'
spring.application.name=currency-exchange-service
server.port=8000

spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

spring.h2.console.enabled=true
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
EOL

# data.sql
cat > $BASE_DIR/src/main/resources/data.sql <<'EOL'
INSERT INTO EXCHANGE_VALUE(ID, CURRENCY_FROM, CURRENCY_TO, CONVERSION_MULTIPLE)
VALUES (10001, 'USD', 'INR', 74.85);
INSERT INTO EXCHANGE_VALUE(ID, CURRENCY_FROM, CURRENCY_TO, CONVERSION_MULTIPLE)
VALUES (10002, 'EUR', 'INR', 88.00);
INSERT INTO EXCHANGE_VALUE(ID, CURRENCY_FROM, CURRENCY_TO, CONVERSION_MULTIPLE)
VALUES (10003, 'AUD', 'INR', 54.12);
EOL

# CurrencyExchangeServiceApplicationTests.java
cat > $BASE_DIR/src/test/java/com/gfg/microservices/currencyexchangesampleservice/CurrencyExchangeServiceApplicationTests.java <<'EOL'
#!/bin/bash

# Create base folder
BASE_DIR="currency-exchange-sample-service"

# Clean if already exists
rm -rf $BASE_DIR

# Create folders
mkdir -p $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice
mkdir -p $BASE_DIR/src/main/resources
mkdir -p $BASE_DIR/src/test/java/com/gfg/microservices/currencyexchangesampleservice
mkdir -p $BASE_DIR/k8s/dev
mkdir -p $BASE_DIR/k8s/qa
mkdir -p $BASE_DIR/k8s/prod

# CurrencyExchangeServiceSampleApplication.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/CurrencyExchangeServiceSampleApplication.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CurrencyExchangeServiceSampleApplication {
        public static void main(String[] args) {
                SpringApplication.run(CurrencyExchangeServiceSampleApplication.class, args);
        }
}
EOL

# ExchangeValue.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/ExchangeValue.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class ExchangeValue {

        @Id
        private Long id;

        @Column(name = "currency_from")
        private String from;

        @Column(name = "currency_to")
        private String to;

        private Double conversionMultiple;

        public ExchangeValue() {}

        public ExchangeValue(Long id, String from, String to, Double conversionMultiple) {
                this.id = id;
                this.from = from;
                this.to = to;
                this.conversionMultiple = conversionMultiple;
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getFrom() { return from; }
        public void setFrom(String from) { this.from = from; }
        public String getTo() { return to; }
        public void setTo(String to) { this.to = to; }
        public Double getConversionMultiple() { return conversionMultiple; }
        public void setConversionMultiple(Double conversionMultiple) { this.conversionMultiple = conversionMultiple; }
}
EOL

# ExchangeValueRepository.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/ExchangeValueRepository.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ExchangeValueRepository extends JpaRepository<ExchangeValue, Long> {
        ExchangeValue findByFromAndTo(String from, String to);
}
EOL

# CurrencyExchangeSampleController.java
cat > $BASE_DIR/src/main/java/com/gfg/microservices/currencyexchangesampleservice/CurrencyExchangeSampleController.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CurrencyExchangeSampleController {

        @Autowired
        private ExchangeValueRepository repository;

        @GetMapping("/currency-exchange/from/{from}/to/{to}")
        public ExchangeValue retrieveExchangeValue(@PathVariable String from, @PathVariable String to) {
                return repository.findByFromAndTo(from, to);
        }
}
EOL

# application.properties
cat > $BASE_DIR/src/main/resources/application.properties <<'EOL'
spring.application.name=currency-exchange-service
server.port=8000

spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

spring.h2.console.enabled=true
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
EOL

# data.sql
cat > $BASE_DIR/src/main/resources/data.sql <<'EOL'
INSERT INTO EXCHANGE_VALUE(ID, CURRENCY_FROM, CURRENCY_TO, CONVERSION_MULTIPLE)
VALUES (10001, 'USD', 'INR', 74.85);
INSERT INTO EXCHANGE_VALUE(ID, CURRENCY_FROM, CURRENCY_TO, CONVERSION_MULTIPLE)
VALUES (10002, 'EUR', 'INR', 88.00);
INSERT INTO EXCHANGE_VALUE(ID, CURRENCY_FROM, CURRENCY_TO, CONVERSION_MULTIPLE)
VALUES (10003, 'AUD', 'INR', 54.12);
EOL

# CurrencyExchangeServiceApplicationTests.java
cat > $BASE_DIR/src/test/java/com/gfg/microservices/currencyexchangesampleservice/CurrencyExchangeServiceApplicationTests.java <<'EOL'
package com.gfg.microservices.currencyexchangesampleservice;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class CurrencyExchangeServiceApplicationTests {

        @Test
        void contextLoads() {
        }
}
EOL

# pom.xml
cat > $BASE_DIR/pom.xml <<'EOL'
<project xmlns="http://maven.apache.org/POM/4.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>com.gfg.microservices</groupId>
        <artifactId>currency-exchange-sample-service</artifactId>
        <version>0.0.1-SNAPSHOT</version>

        <parent>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-parent</artifactId>
                <version>3.2.5</version>
                <relativePath/>
        </parent>

        <properties>
                <java.version>17</java.version>
        </properties>

        <dependencies>
                <dependency>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-web</artifactId>
                </dependency>
                <dependency>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-data-jpa</artifactId>
                </dependency>
                <dependency>
                        <groupId>com.h2database</groupId>
                        <artifactId>h2</artifactId>
                        <scope>runtime</scope>
                </dependency>
                <dependency>
                        <groupId>jakarta.persistence</groupId>
                        <artifactId>jakarta.persistence-api</artifactId>
                </dependency>
        </dependencies>

        <build>
                <plugins>
                        <plugin>
                                <groupId>org.springframework.boot</groupId>
                                <artifactId>spring-boot-maven-plugin</artifactId>
                        </plugin>
                </plugins>
        </build>
</project>
EOL

# Create DevOps empty files
touch $BASE_DIR/Dockerfile
touch $BASE_DIR/Jenkinsfile
touch $BASE_DIR/sonar-project.properties
touch $BASE_DIR/trivy-scan.sh
touch $BASE_DIR/README.md

echo "FULL EC2 AUTOMATION COMPLETED SUCCESSFULLY"
