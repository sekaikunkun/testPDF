# Word to PDF Service

A Java Spring Boot application that provides an API to convert Word documents to PDF using Aspose.Words.

## Features
- **JDK 8** Support (Compatible with legacy environments)
- **Docker** Support for easy deployment
- **Aspose.Words 24.12** integration with License bypass
- **Deployment Scripts** for Linux servers

## Project Structure
- `src/main/java/com/example/word2pdf/config/AsposeConfig.java`: Contains the license initialization logic.
- `src/main/java/com/example/word2pdf/controller/ConvertController.java`: REST API endpoint.
- `deploy.sh`: Automated Docker deployment script.
- `start.sh`: Manual JAR deployment script.
- `INTEGRATION_GUIDE.md`: Guide for integrating this code into existing projects.

## How to Build and Run with Docker

1. **Build the Docker image:**
   ```bash
   docker build -t word2pdf .
   ```
   *Note: The build uses a custom `settings.xml` to handle Maven dependencies correctly (specifically for Aspose).*

2. **Run the container:**
   ```bash
   docker run -p 8080:8080 word2pdf
   ```

## Server Deployment

### Prerequisites
- A Linux server (Ubuntu/CentOS/Debian)
- **Docker** installed

### Steps

1. **Upload the project to your server**
   You can use `scp` or `rsync` or any FTP client.
   ```bash
   # Example using scp
   scp -r aspose_words user@your-server-ip:/opt/
   ```

2. **Run the deployment script**
   SSH into your server and run:
   ```bash
   cd /opt/aspose_words
   chmod +x deploy.sh
   ./deploy.sh
   ```

   This script will:
   - Stop any running instance of the service.
   - Rebuild the Docker image.
   - Start a new container on port 8080.
   - Set auto-restart policy.

### Manual Docker Deployment
If you prefer manual commands:
```bash
docker build -t word2pdf .
docker run -d -p 8080:8080 --name word2pdf --restart unless-stopped word2pdf
```

## Direct Deployment (Non-Docker, JDK 8)

If you prefer to run directly on a server with JDK 8 installed:

1. **Prerequisites**:
   - Ensure **JDK 1.8** is installed (`java -version`).
   - Ensure **Maven** is installed (if you want to build on server) OR upload the compiled `jar`.

2. **Build (if not uploading jar)**:
   ```bash
   mvn clean package -s settings.xml
   ```

3. **Run using Script**:
   We provided a `start.sh` script for easy management.
   ```bash
   chmod +x start.sh
   ./start.sh start    # Start the application
   ./start.sh stop     # Stop the application
   ./start.sh restart  # Restart
   ./start.sh status   # Check status
   ```

4. **Run Manually**:
   ```bash
   nohup java -jar target/word2pdf-0.0.1-SNAPSHOT.jar > app.log 2>&1 &
   ```

## Local Development (JDK 8 Required)

If you run this locally and use Aliyun Maven mirror, you might encounter dependency errors. Use the provided `settings.xml`:

```bash
mvn clean package -s settings.xml
```

Then run the jar:
```bash
java -jar target/word2pdf-0.0.1-SNAPSHOT.jar
```

## API Usage

**Endpoint:** `POST /convert`
**Content-Type:** `multipart/form-data`
**Parameter:** `file` (The Word document)

### Example using cURL:
```bash
curl -X POST -F "file=@example.docx" -o output.pdf http://localhost:8080/convert
```

## Note
This project is for educational purposes only. Please ensure you comply with Aspose licensing terms for commercial use.
