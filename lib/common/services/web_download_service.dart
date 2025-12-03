/**
 * @file: web_download_service.dart
 * @responsibility: conditional import interface for web download functionality
 * @exports: WebDownloadService
 * @imports: platform-specific implementations via conditional imports
 * @layer: services
 */

export 'web_download_service_stub.dart'
    if (dart.library.html) 'web_download_service_web.dart';
