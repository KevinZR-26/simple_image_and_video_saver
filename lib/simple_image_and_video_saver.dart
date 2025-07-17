
import 'package:flutter/services.dart';

class SimpleImageAndVideoSaver {
  
  static const MethodChannel _channel = MethodChannel('simple_image_and_video_saver');

  /// Guarda imagen o video en la galería (Pictures/Movies).
  static Future<String?> saveMediaToGallery({
    required String filePath,
    required String fileName,
    required MediaType mediaType,
  }) async {
    final String? result = await _channel.invokeMethod(
      'saveMediaToGallery',
      {
        'filePath': filePath,
        'fileName': fileName,
        'mediaType': _mediaTypeToString(mediaType),
      },
    );
    return result;
  }

  /// Guarda imagen en Downloads.
  static Future<String?> saveImageToDownloads({
    required String filePath,
    required String fileName,
  }) async {
    final String? result = await _channel.invokeMethod(
      'saveImageToDownloads',
      {
        'filePath': filePath,
        'fileName': fileName,
      },
    );
    return result;
  }

  /// Guarda video en Downloads.
  static Future<String?> saveVideoToDownloads({
    required String filePath,
    required String fileName,
  }) async {
    final String? result = await _channel.invokeMethod(
      'saveVideoToDownloads',
      {
        'filePath': filePath,
        'fileName': fileName,
      },
    );
    return result;
  }

  /// Guarda archivo en carpeta privada del app.
  static Future<String?> savePrivateMedia({
    required String filePath,
    required MediaType mediaType,
    String? fileName,
  }) async {
    final ext = _mediaTypeToString(mediaType) == 'image' ? 'png' : 'mp4';
    final fileNameCreated = 'private_${fileName ?? DateTime.now().millisecondsSinceEpoch}.$ext';
    final String? result = await _channel.invokeMethod(
      'savePrivateMedia',
      {
        'filePath': filePath,
        'fileName': fileNameCreated,
      },
    );
    return result;
  }

  static String _mediaTypeToString(MediaType type) {
    switch (type) {
      case MediaType.image:
        return 'image';
      case MediaType.video:
        return 'video';
    }
  }
  
}

enum MediaType {
  image,
  video,
}
