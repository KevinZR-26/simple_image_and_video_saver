import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_image_and_video_saver/simple_image_and_video_saver.dart';

void main() {
  const MethodChannel channel = MethodChannel('simple_image_and_video_saver');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('SimpleImageAndVideoSaver', () {
    test('saveMediaToGallery calls correctly with image', () async {
      late MethodCall receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        receivedCall = methodCall;
        return 'mocked_image_path';
      });

      final result = await SimpleImageAndVideoSaver.saveMediaToGallery(
        filePath: '/path/to/image.png',
        fileName: 'image.png',
        mediaType: MediaType.image,
      );

      expect(result, 'mocked_image_path');
      expect(receivedCall.method, 'saveMediaToGallery');
      expect(receivedCall.arguments, {
        'filePath': '/path/to/image.png',
        'fileName': 'image.png',
        'mediaType': 'image',
      });
    });

    test('saveMediaToGallery calls correctly with video', () async {
      late MethodCall receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        receivedCall = methodCall;
        return 'mocked_video_path';
      });

      final result = await SimpleImageAndVideoSaver.saveMediaToGallery(
        filePath: '/path/to/video.mp4',
        fileName: 'video.mp4',
        mediaType: MediaType.video,
      );

      expect(result, 'mocked_video_path');
      expect(receivedCall.method, 'saveMediaToGallery');
      expect(receivedCall.arguments, {
        'filePath': '/path/to/video.mp4',
        'fileName': 'video.mp4',
        'mediaType': 'video',
      });
    });

    test('saveImageToDownloads calls correctly', () async {
      late MethodCall receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        receivedCall = methodCall;
        return 'image_download_path';
      });

      final result = await SimpleImageAndVideoSaver.saveImageToDownloads(
        filePath: '/image.png',
        fileName: 'image.png',
      );

      expect(result, 'image_download_path');
      expect(receivedCall.method, 'saveImageToDownloads');
      expect(receivedCall.arguments, {
        'filePath': '/image.png',
        'fileName': 'image.png',
      });
    });

    test('saveVideoToDownloads calls correctly', () async {
      late MethodCall receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        receivedCall = methodCall;
        return 'video_download_path';
      });

      final result = await SimpleImageAndVideoSaver.saveVideoToDownloads(
        filePath: '/video.mp4',
        fileName: 'video.mp4',
      );

      expect(result, 'video_download_path');
      expect(receivedCall.method, 'saveVideoToDownloads');
      expect(receivedCall.arguments, {
        'filePath': '/video.mp4',
        'fileName': 'video.mp4',
      });
    });

    test('savePrivateMedia uses custom filename when provided', () async {
      late MethodCall receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        receivedCall = methodCall;
        return 'custom_file_path';
      });

      final result = await SimpleImageAndVideoSaver.savePrivateMedia(
        filePath: '/some/image.png',
        mediaType: MediaType.image,
        fileName: 'custom_name',
      );

      expect(result, 'custom_file_path');
      expect(receivedCall.method, 'savePrivateMedia');
      expect(receivedCall.arguments['fileName'], 'private_custom_name.png');
    });

    test('savePrivateMedia generates filename when not provided', () async {
      late MethodCall receivedCall;

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        receivedCall = methodCall;
        return 'generated_file_path';
      });

      final result = await SimpleImageAndVideoSaver.savePrivateMedia(
        filePath: '/some/image.png',
        mediaType: MediaType.image,
      );

      expect(result, 'generated_file_path');
      expect(receivedCall.method, 'savePrivateMedia');
      expect(receivedCall.arguments['fileName'], startsWith('private_'));
      expect(receivedCall.arguments['fileName'], endsWith('.png'));
    });
  });
}

