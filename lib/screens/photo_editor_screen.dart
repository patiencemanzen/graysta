import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../models/photo_filter.dart';
import '../services/image_filter_service.dart';
import '../services/ai_service.dart';
import '../services/file_service.dart';
import '../services/filter_preview_service.dart';
import '../widgets/before_after_slider.dart';
import '../widgets/filter_selector.dart';

class PhotoEditorScreen extends StatefulWidget {
  final File imageFile;

  const PhotoEditorScreen({super.key, required this.imageFile});

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  late Uint8List _originalImage;
  Uint8List? _filteredImage;
  Uint8List? _aiEnhancedImage;
  FilterType _selectedFilter = FilterType.none;
  bool _isProcessingFilter = false;
  bool _isProcessingAI = false;
  bool _showBeforeAfter = false;
  bool _useAIVersion = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final bytes = await widget.imageFile.readAsBytes();
      setState(() {
        _originalImage = bytes;
        _filteredImage = bytes;
      });

      // Pre-generate filter previews for better UI performance
      print('📱 Starting filter preview generation...');
      await FilterPreviewService.preGenerateAllPreviews(bytes);
      print('✅ Filter previews ready for UI');
    } catch (e) {
      print('❌ Error loading image: $e');
      _showErrorSnackBar('Failed to load image: $e');
    }
  }

  Future<void> _applyFilter(FilterType filter) async {
    if (_isProcessingFilter) return;

    // Haptic feedback for better user experience
    HapticFeedback.selectionClick();

    setState(() {
      _selectedFilter = filter;
      _isProcessingFilter = true;
      _useAIVersion = false;
    });

    try {
      print('🎨 Applying ${filter.name} filter...');
      final filteredBytes = await ImageFilterService.applyFilter(
        _originalImage,
        filter,
      );

      setState(() {
        _filteredImage = filteredBytes;
        _isProcessingFilter = false;
      });

      // Success haptic feedback
      HapticFeedback.lightImpact();
      print('✅ ${filter.name} filter applied successfully');
    } catch (e) {
      setState(() => _isProcessingFilter = false);
      
      // Error haptic feedback
      HapticFeedback.heavyImpact();
      print('❌ Filter application failed: $e');
      _showErrorSnackBar('Failed to apply filter: $e');
    }
  }

  Future<void> _enhanceWithAI() async {
    if (_isProcessingAI || _filteredImage == null) return;

    setState(() => _isProcessingAI = true);

    try {
      // Show AI enhancement dialog
      _showAIEnhancementDialog();

      print('🤖 Starting AI enhancement with Gemini...');

      // Test API connection first
      final isConnected = await AIService.checkConnection();
      if (!isConnected) {
        print('⚠️ Gemini API not accessible, using fallback enhancement');
      }

      final enhancedBytes = await AIService.enhanceImage(_filteredImage!);

      if (enhancedBytes != null && enhancedBytes.isNotEmpty) {
        setState(() {
          _aiEnhancedImage = enhancedBytes;
          _useAIVersion = true;
          _isProcessingAI = false;
        });
        Navigator.pop(context); // Close dialog
        _showSuccessSnackBar(
          isConnected
              ? 'AI enhancement completed with Gemini! 🤖✨'
              : 'Advanced enhancement applied! ⚡✨',
        );
      } else {
        throw Exception('AI enhancement returned empty result');
      }
    } catch (e) {
      print('❌ AI Enhancement Error: $e');
      setState(() => _isProcessingAI = false);
      Navigator.pop(context); // Close dialog
      _showErrorSnackBar(
        'AI enhancement failed: ${e.toString().split(':').last.trim()}',
      );
    }
  }

  void _showAIEnhancementDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppColors.secondaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: AppColors.aiEnhanceBlue,
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2.seconds),

              const SizedBox(height: 16),

              Text(
                'AI Enhancement',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.silverLight,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Enhancing your photo with AI magic...',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.silverMedium),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              LinearProgressIndicator(
                    backgroundColor: AppColors.accentGray,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.aiEnhanceBlue,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1.5.seconds),

              const SizedBox(height: 16),

              Text(
                'This may take a few moments...',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.silverDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage() async {
    try {
      final imageToSave = _getCurrentImage();
      final fileName = await FileService.saveImageToGallery(
        imageToSave,
        fileName: 'graysta_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      if (fileName != null) {
        _showSuccessSnackBar('Image saved to gallery! 📸');
      } else {
        _showErrorSnackBar('Failed to save image');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to save: $e');
    }
  }

  Future<void> _shareImage() async {
    try {
      final imageToShare = _getCurrentImage();
      await FileService.shareImage(imageToShare);
    } catch (e) {
      _showErrorSnackBar('Failed to share: $e');
    }
  }

  Uint8List _getCurrentImage() {
    if (_useAIVersion && _aiEnhancedImage != null) {
      return _aiEnhancedImage!;
    }
    return _filteredImage ?? _originalImage;
  }

  void _toggleBeforeAfter() {
    setState(() => _showBeforeAfter = !_showBeforeAfter);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.errorRed),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.successGreen),
    );
  }

  @override
  void dispose() {
    FilterPreviewService.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Photo Editor'),
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: _toggleBeforeAfter,
            tooltip: 'Compare Before/After',
          ),
        ],
      ),
      body: _filteredImage == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.silverLight),
            )
          : Column(
              children: [
                // Image display area
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Main image content
                          _showBeforeAfter
                              ? BeforeAfterSlider(
                                  beforeImage: Image.memory(
                                    _originalImage,
                                    fit: BoxFit.cover,
                                  ),
                                  afterImage: Image.memory(
                                    _getCurrentImage(),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.memory(
                                  _getCurrentImage(),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),

                          // Filter processing overlay
                          if (_isProcessingFilter)
                            Container(
                              color: AppColors.black.withOpacity(0.6),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 4,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.silverLight,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Applying Filter...',
                                      style: TextStyle(
                                        color: AppColors.silverLight,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 200.ms),
                        ],
                      ),
                    ),
                  ),
                ),

                // AI Enhancement button
                if (_selectedFilter != FilterType.none && !_useAIVersion)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child:
                        SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isProcessingAI
                                    ? null
                                    : _enhanceWithAI,
                                icon: Icon(
                                  Icons.auto_awesome,
                                  color: _isProcessingAI
                                      ? AppColors.silverDark
                                      : AppColors.black,
                                ),
                                label: Text(
                                  _isProcessingAI
                                      ? 'Enhancing...'
                                      : 'Enhance with AI',
                                  style: TextStyle(
                                    color: _isProcessingAI
                                        ? AppColors.silverDark
                                        : AppColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.aiEnhanceBlue,
                                  disabledBackgroundColor: AppColors.accentGray,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                  ),

                if (_useAIVersion)
                  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.aiEnhanceBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.aiEnhanceBlue.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: AppColors.aiEnhanceBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI Enhanced',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.aiEnhanceBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.3, end: 0),

                const SizedBox(height: 16),

                // Bottom controls area
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Action buttons row
                      Row(
                        children: [
                          // Save button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _saveImage,
                              icon: const Icon(
                                Icons.save_alt,
                                color: AppColors.white,
                              ),
                              label: const Text(
                                'Save',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.successGreen,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Share button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _shareImage,
                              icon: const Icon(
                                Icons.share,
                                color: AppColors.black,
                              ),
                              label: const Text(
                                'Share',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.silverLight,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Filter preview carousel
                      SizedBox(
                        height: 180, // Optimized height for horizontal scroll
                        child: FilterPreviewGrid(
                          filters: PhotoFilter.availableFilters,
                          selectedFilter: _selectedFilter,
                          onFilterSelected: _applyFilter,
                          isProcessing: _isProcessingFilter,
                          previewBuilder: (filterType) =>
                              FilterPreviewService.buildPreviewWidget(
                                filterType,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
