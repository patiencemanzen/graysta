import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../models/photo_filter.dart';
import 'image_filter_service.dart';

class FilterPreviewService {
  static final Map<FilterType, Uint8List?> _previewCache = {};
  static Uint8List? _basePreviewImage;

  /// Generate a small preview image for filter thumbnails
  static Future<Uint8List> generatePreviewThumbnail(
    Uint8List originalImage,
  ) async {
    final image = img.decodeImage(originalImage);
    if (image == null) throw Exception('Failed to decode image');

    // Create a rectangular thumbnail optimized for card previews (140x120)
    // This aspect ratio works better with the new card layout
    final thumbnail = img.copyResize(
      image,
      width: 140,
      height: 120,
      interpolation: img.Interpolation.cubic,
    );

    return Uint8List.fromList(img.encodeJpg(thumbnail, quality: 85));
  }

  /// Generate preview for a specific filter
  static Future<Uint8List> generateFilterPreview(
    Uint8List baseImage,
    FilterType filterType,
  ) async {
    // Check cache first
    final cacheKey = filterType;
    if (_previewCache.containsKey(cacheKey) &&
        _previewCache[cacheKey] != null) {
      return _previewCache[cacheKey]!;
    }

    try {
      // Generate new preview
      Uint8List preview;
      if (filterType == FilterType.none) {
        preview = baseImage;
        print('📸 Using original image for ${filterType.name}');
      } else {
        print('🎨 Applying ${filterType.name} filter to preview...');
        preview = await ImageFilterService.applyFilter(baseImage, filterType);
        print(
          '✅ ${filterType.name} preview generated: ${preview.length} bytes',
        );
      }

      // Validate preview is not empty
      if (preview.isEmpty) {
        print('⚠️ Empty preview for ${filterType.name}, using base image');
        preview = baseImage;
      }

      // Cache the result
      _previewCache[cacheKey] = preview;
      return preview;
    } catch (e) {
      print('❌ Error generating preview for ${filterType.name}: $e');
      // Fallback to base image
      _previewCache[cacheKey] = baseImage;
      return baseImage;
    }
  }

  /// Pre-generate all filter previews for faster UI
  static Future<void> preGenerateAllPreviews(Uint8List originalImage) async {
    try {
      print(
        '🖼️ Starting preview generation from ${originalImage.length} byte image...',
      );

      _basePreviewImage = await generatePreviewThumbnail(originalImage);
      print(
        '✅ Base preview thumbnail created: ${_basePreviewImage!.length} bytes',
      );

      // Generate previews for all filters in batches to avoid blocking UI
      final filters = FilterType.values;
      const batchSize = 4;

      print('🎨 Generating previews for ${filters.length} filters...');

      for (int i = 0; i < filters.length; i += batchSize) {
        final batch = filters.skip(i).take(batchSize);

        try {
          await Future.wait(
            batch.map(
              (filter) => generateFilterPreview(_basePreviewImage!, filter),
            ),
          );
          print('✅ Batch ${(i / batchSize).ceil()} completed');
        } catch (e) {
          print('❌ Error in batch ${(i / batchSize).ceil()}: $e');
        }

        // Small delay between batches to keep UI responsive
        await Future.delayed(const Duration(milliseconds: 10));
      }

      print('🎉 Filter preview generation completed!');
    } catch (e) {
      print('❌ Preview generation failed: $e');
      _basePreviewImage = originalImage; // Fallback to original
    }
  }

  /// Get cached preview or generate on demand
  static Future<Uint8List> getFilterPreview(FilterType filterType) async {
    if (_basePreviewImage == null) {
      throw Exception(
        'Base preview image not set. Call preGenerateAllPreviews first.',
      );
    }

    return generateFilterPreview(_basePreviewImage!, filterType);
  }

  /// Clear all cached previews (call when switching images)
  static void clearCache() {
    _previewCache.clear();
    _basePreviewImage = null;
  }

  /// Create a Flutter Image widget from cached preview
  static Widget buildPreviewWidget(FilterType filterType) {
    // If no base preview image, show error immediately
    if (_basePreviewImage == null) {
      return Container(
        color: Colors.grey[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white54,
              size: 32,
            ),
            SizedBox(height: 4),
            Text(
              'Preview\nUnavailable',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<Uint8List>(
      future: getFilterPreview(filterType),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            decoration: BoxDecoration(color: Colors.grey[900]),
            child: Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) {
                print('❌ Image.memory error for ${filterType.name}: $error');
                return Container(
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white54,
                    size: 32,
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          print('❌ Preview error for ${filterType.name}: ${snapshot.error}');
          return Container(
            color: Colors.grey[800],
            child: const Icon(
              Icons.error_outline,
              color: Colors.white54,
              size: 32,
            ),
          );
        } else {
          return Container(
            color: Colors.grey[900],
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
