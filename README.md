# Aspose Words Java 8 Integration Guide

This project serves as a comprehensive guide and example for integrating **Aspose.Words 24.12** into an existing **Java 8** backend project (Spring Boot or standard Java) with License bypass.

## 🚀 How to Integrate

If you want to add Word-to-PDF capabilities to your existing project, follow these steps:

### 1. Update `pom.xml`

You need to add the Aspose repository (since it's not in Maven Central) and the dependency.

#### Add Repository
```xml
<repositories>
    <repository>
        <id>AsposeJavaAPI</id>
        <name>Aspose Java API</name>
        <url>https://releases.aspose.com/java/repo/</url>
    </repository>
</repositories>
```

#### Add Dependency
```xml
<dependency>
    <groupId>com.aspose</groupId>
    <artifactId>aspose-words</artifactId>
    <version>24.12</version>
    <!-- Use 'jdk17' classifier even for JDK 8 if it works, or remove classifier if you encounter issues. 
         Currently tested and working with JDK 8. -->
    <classifier>jdk17</classifier>
</dependency>
```

> **⚠️ Important for Aliyun Maven Users**:
> If your local `settings.xml` uses a mirror (like Aliyun) that captures all requests (`mirrorOf *`), you MUST exclude the Aspose repository.
> Change your mirror config to: `<mirrorOf>*,!AsposeJavaAPI</mirrorOf>`

---

### 2. Add License Bypass Configuration

Create a configuration class to handle the license verification bypass. This must run **before** you use any Aspose features.

#### For Spring Boot Projects

Copy `src/main/java/com/example/word2pdf/config/AsposeConfig.java` to your project.

```java
import org.springframework.stereotype.Component;
import javax.annotation.PostConstruct; // Use jakarta.annotation.PostConstruct for Spring Boot 3+

@Component
public class AsposeConfig {

    @PostConstruct
    public void init() {
        registerWord2412();
    }

    private void registerWord2412() {
        try {
            // ... (Copy the reflection logic from AsposeConfig.java) ...
            // See the full code in this repository
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

#### For Standard Java Projects

Simply call the `registerWord2412()` method in your application's startup logic (e.g., `main` method or static initializer).

---

### 3. Implement Conversion Logic

Use the `Document` class to load and save files.

```java
import com.aspose.words.Document;
import com.aspose.words.PdfSaveOptions;

public void convertWordToPdf(InputStream inputStream, OutputStream outputStream) throws Exception {
    Document doc = new Document(inputStream);
    PdfSaveOptions options = new PdfSaveOptions();
    doc.save(outputStream, options);
}
```

---

## 🛠️ How to Run This Example

This repository itself is a working Spring Boot 2.7 (JDK 8) application demonstrating the integration.

### Prerequisites
- JDK 1.8
- Maven

### Run Locally

1. **Build**:
   ```bash
   mvn clean package -s settings.xml
   ```
   *(Note: `settings.xml` is provided to ensure dependencies download correctly even behind mirrors)*

2. **Start**:
   ```bash
   # Using the helper script (Linux/Mac)
   ./start.sh start
   
   # OR manually
   java -jar target/word2pdf-0.0.1-SNAPSHOT.jar
   ```

3. **Test**:
   Send a POST request to `http://localhost:8080/convert` with a file named `file`.

---

## 📂 Project Structure
- `src/main/java/.../config/AsposeConfig.java`: **Core License Bypass Logic** (Copy this!)
- `src/main/java/.../controller/ConvertController.java`: Example usage in a REST API.
- `settings.xml`: Reference Maven settings for Aliyun users.
