/**
 * @file: web_download_service_stub.dart
 * @responsibility: stub implementation for non-web platforms
 * @exports: downloadFileOnWeb (no-op implementation)
 * @imports: none
 * @layer: services
 */

class WebDownloadService {
  static void downloadFileOnWeb(
    String content,
    String fileName,
    String mimeType,
  ) {
    // No-op implementation for non-web platforms
    // Web downloads are not supported on mobile/desktop platforms
  }
}
