import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  static final ImagePicker _picker = ImagePicker();
  static List<CameraDescription>? _cameras;

  static Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  static Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();
    final photosStatus = await Permission.photos.request();

    return cameraStatus.isGranted &&
        (storageStatus.isGranted || photosStatus.isGranted);
  }

  static Future<File?> capturePhoto() async {
    try {
      if (!await requestPermissions()) {
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Camera and storage permissions are required',
        );
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      return photo != null ? File(photo.path) : null;
    } catch (e) {
      print('Error capturing photo: $e');
      return null;
    }
  }

  static Future<File?> pickFromGallery() async {
    try {
      if (!await requestPermissions()) {
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Storage permissions are required',
        );
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  static Future<List<File>?> pickMultipleFromGallery({int? limit}) async {
    try {
      if (!await requestPermissions()) {
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Storage permissions are required',
        );
      }

      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 85,
        limit: limit,
      );

      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
      return null;
    }
  }

  static List<CameraDescription>? get cameras => _cameras;

  static bool get hasCameras => _cameras != null && _cameras!.isNotEmpty;
}
