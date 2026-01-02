package com.example.word2pdf.controller;

import com.aspose.words.Document;
import com.aspose.words.PdfCompliance;
import com.aspose.words.PdfSaveOptions;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;

@RestController
public class ConvertController {

    @PostMapping("/convert")
    public ResponseEntity<byte[]> convertWordToPdf(@RequestParam("file") MultipartFile file) {
        try {
            // Load the document from the input stream
            Document doc = new Document(file.getInputStream());

            // Create PDF save options
            PdfSaveOptions options = new PdfSaveOptions();
            options.setCompliance(PdfCompliance.PDF_17);

            // Save to ByteArrayOutputStream
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            doc.save(outputStream, options);

            // Prepare response
            byte[] pdfBytes = outputStream.toByteArray();
            String filename = file.getOriginalFilename();
            if (filename != null && filename.lastIndexOf(".") > 0) {
                filename = filename.substring(0, filename.lastIndexOf("."));
            }
            filename += ".pdf";

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(pdfBytes);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(null);
        }
    }
}
