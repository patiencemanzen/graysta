import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  static Future<bool> requestStoragePermission() async {
    try {
      // Gal package handles most permissions automatically
      // We just need to check if we have basic access
      if (Platform.isAndroid) {
        // Check if we have photos permission (for newer Android versions)
        if (await Permission.photos.isGranted ||
            await Permission.storage.isGranted) {
          return true;
        }
        // Try to request photos permission first (for Android 13+)
        var photosStatus = await Permission.photos.request();
        if (photosStatus.isGranted) {
          return true;
        }
        // Fallback to storage permission (for older Android versions)
        var storageStatus = await Permission.storage.request();
        return storageStatus.isGranted;
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> saveImageToGallery(
    Uint8List imageBytes, {
    String? fileName,
  }) async {
    try {
      if (!await requestStoragePermission()) {
        throw Exception('Storage permission not granted');
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = fileName ?? 'graysta_$timestamp.png';
      final tempFile = File('${tempDir.path}/$finalFileName');

      // Write image to temporary file
      await tempFile.writeAsBytes(imageBytes);

      // Save to gallery using Gal
      await Gal.putImage(tempFile.path, album: 'Graysta');

      // Clean up temporary file
      await tempFile.delete();

      return finalFileName;
    } catch (e) {
      return null;
    }
  }

  static Future<File?> saveImageToAppDirectory(
    Uint8List imageBytes, {
    String? fileName,
  }) async {
    try {
      // Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final graystaDir = Directory('${appDir.path}/graysta_exports');

      // Create directory if it doesn't exist
      if (!await graystaDir.exists()) {
        await graystaDir.create(recursive: true);
      }

      // Create file
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalFileName = fileName ?? 'graysta_$timestamp.png';
      final file = File('${graystaDir.path}/$finalFileName');

      // Write image data
      await file.writeAsBytes(imageBytes);

      return file;
    } catch (e) {
      return null;
    }
  }

  static Future<void> shareImage(Uint8List imageBytes, {String? text}) async {
    try {
      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/graysta_share_$timestamp.png');

      await tempFile.writeAsBytes(imageBytes);

      // Share the file
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text:
            text ??
            'Created with Graysta - Transform Ordinary into Cinematic 📷✨',
      );

      // Clean up after a delay to ensure sharing completes
      Future.delayed(const Duration(seconds: 30), () async {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<File>> getExportedImages() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final graystaDir = Directory('${appDir.path}/graysta_exports');

      if (!await graystaDir.exists()) {
        return [];
      }

      final files = await graystaDir.list().toList();
      return files
          .whereType<File>()
          .where(
            (file) =>
                file.path.toLowerCase().endsWith('.png') ||
                file.path.toLowerCase().endsWith('.jpg'),
          )
          .toList()
        ..sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
        );
    } catch (e) {
      return [];
    }
  }

  static Future<bool> deleteExportedImage(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<double> getStorageUsage() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final graystaDir = Directory('${appDir.path}/graysta_exports');

      if (!await graystaDir.exists()) {
        return 0.0;
      }

      double totalSize = 0.0;
      final files = await graystaDir.list().toList();

      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          totalSize += stat.size;
        }
      }

      return totalSize / (1024 * 1024); // Convert to MB
    } catch (e) {
      return 0.0;
    }
  }
}
