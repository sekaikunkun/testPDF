# Aspose Words 集成指南

如果您希望将 Word 转 PDF 的功能直接集成到现有的 Java 后端项目中（而不是作为一个单独的服务运行），请按照以下步骤操作。

## 1. 修改 `pom.xml`

在您的项目 `pom.xml` 中添加 Aspose 的仓库和依赖。

### 添加仓库 (Repositories)
由于 Aspose 不在 Maven 中央仓库，必须添加其官方仓库。

```xml
<repositories>
    <repository>
        <id>AsposeJavaAPI</id>
        <name>Aspose Java API</name>
        <url>https://releases.aspose.com/java/repo/</url>
    </repository>
</repositories>
```

### 添加依赖 (Dependencies)

```xml
<dependency>
    <groupId>com.aspose</groupId>
    <artifactId>aspose-words</artifactId>
    <version>24.12</version>
    <!-- 如果您的项目是 JDK 17+，可以加上这个 classifier，如果是 JDK 8 则去掉 -->
    <classifier>jdk17</classifier>
</dependency>
```

> **⚠️ 注意 Maven 镜像问题**：
> 如果您的开发环境或服务器配置了阿里云 Maven 镜像（`settings.xml` 中配置了 `mirrorOf *`），会导致无法下载 Aspose 依赖。
> **解决方法**：在 `settings.xml` 的 `<mirrorOf>` 中排除 Aspose，例如：`<mirrorOf>*,!AsposeJavaAPI</mirrorOf>`。

---

## 2. 添加 License 破解配置类

在您的项目中创建一个配置类，用于在项目启动时自动“注册”破解信息。

### 如果是 Spring Boot 项目

创建一个 Bean，例如 `AsposeConfig.java`：

```java
import org.springframework.stereotype.Component;
import javax.annotation.PostConstruct; // Spring Boot 3.x 请使用 jakarta.annotation.PostConstruct
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.util.ArrayList;

@Component
public class AsposeConfig {

    @PostConstruct
    public void init() {
        registerWord2412();
    }

    /**
     * 破解 Aspose-words 24.12
     */
    private void registerWord2412() {
        try {
            System.out.println("正在尝试绕过 Aspose License 验证...");
            Class<?> zzodClass = Class.forName("com.aspose.words.zzod");
            Constructor<?> constructors = zzodClass.getDeclaredConstructors()[0];
            constructors.setAccessible(true);
            Object instance = constructors.newInstance(null, null);
            Field zzWws = zzodClass.getDeclaredField("zzWws");
            zzWws.setAccessible(true);
            zzWws.set(instance, 1);
            Field zzVZC = zzodClass.getDeclaredField("zzVZC");
            zzVZC.setAccessible(true);
            zzVZC.set(instance, 1);

            Class<?> zz83Class = Class.forName("com.aspose.words.zz83");
            constructors.setAccessible(true);
            constructors.newInstance(null, null);

            Field zzZY4 = zz83Class.getDeclaredField("zzZY4");
            zzZY4.setAccessible(true);
            ArrayList<Object> zzwPValue = new ArrayList<>();
            zzwPValue.add(instance);
            zzZY4.set(null, zzwPValue);

            Class<?> zzXuRClass = Class.forName("com.aspose.words.zzXuR");
            Field zzWE8 = zzXuRClass.getDeclaredField("zzWE8");
            zzWE8.setAccessible(true);
            zzWE8.set(null, 128);
            Field zzZKj = zzXuRClass.getDeclaredField("zzZKj");
            zzZKj.setAccessible(true);
            zzZKj.set(null, false);
            
            System.out.println("Aspose License 验证绕过成功！");

        } catch (Exception e) {
            System.err.println("Aspose License 绕过失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

### 如果是普通 Java 项目

请确保在调用任何 Aspose 功能之前，先调用一次 `registerWord2412()` 方法（代码同上，只需去掉 Spring 注解）。

---

## 3. 编写转换工具类

创建一个工具类来处理转换逻辑。

```java
import com.aspose.words.Document;
import com.aspose.words.PdfCompliance;
import com.aspose.words.PdfSaveOptions;
import java.io.InputStream;
import java.io.OutputStream;

public class WordToPdfUtils {

    public static void convert(InputStream inputStream, OutputStream outputStream) throws Exception {
        // 加载文档
        Document doc = new Document(inputStream);

        // 创建 PDF 保存选项
        PdfSaveOptions options = new PdfSaveOptions();
        options.setCompliance(PdfCompliance.PDF_17); // 设置 PDF 标准

        // 保存为 PDF
        doc.save(outputStream, options);
    }
}
```

## 4. 在业务代码中使用

```java
// 示例：在 Controller 中使用
@PostMapping("/convert")
public void convert(@RequestParam("file") MultipartFile file, HttpServletResponse response) {
    try {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"output.pdf\"");
        
        WordToPdfUtils.convert(file.getInputStream(), response.getOutputStream());
        
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```
