/**
 * @file: web_download_service_web.dart
 * @responsibility: web-specific file download functionality using dart:html
 * @exports: downloadFileOnWeb
 * @imports: dart:html, dart:convert
 * @layer: services
 */

import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class WebDownloadService {
  static void downloadFileOnWeb(
    String content,
    String fileName,
    String mimeType,
  ) {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    (html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click());
    html.Url.revokeObjectUrl(url);
  }
}
