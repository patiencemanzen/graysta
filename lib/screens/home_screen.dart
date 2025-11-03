import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../services/camera_service.dart';
import '../widgets/ad_banner_widget.dart';
import 'photo_editor_screen.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await CameraService.initialize();
  }

  Future<void> _capturePhoto() async {
    setState(() => _isLoading = true);

    try {
      final File? image = await CameraService.capturePhoto();
      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoEditorScreen(imageFile: image),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to capture photo: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);

    try {
      final File? image = await CameraService.pickFromGallery();
      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoEditorScreen(imageFile: image),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text('Graysta'),
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome section
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                          Icons.photo_filter,
                          size: 120,
                          color: AppColors.silverLight.withOpacity(0.8),
                        )
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scale(begin: const Offset(0.8, 0.8)),

                    const SizedBox(height: 24),

                    Text(
                          'Transform Ordinary into Cinematic',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.silverLight,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 12),

                    Text(
                          'Create stunning photos with more filters\nand AI enhancement',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.silverMedium,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 800.ms)
                        .slideY(begin: 0.3, end: 0),
                  ],
                ),
              ),

              // Action buttons
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 140),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Camera button
                      _buildActionButton(
                            icon: Icons.camera_alt,
                            label: 'Take Photo',
                            onPressed: _isLoading ? null : _capturePhoto,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.silverLight,
                                AppColors.silverMedium,
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 600.ms)
                          .slideX(begin: -0.3, end: 0),

                      const SizedBox(height: 12),

                      // Gallery button
                      _buildActionButton(
                            icon: Icons.photo_library,
                            label: 'Choose from Gallery',
                            onPressed: _isLoading ? null : _pickFromGallery,
                            isOutlined: true,
                          )
                          .animate()
                          .fadeIn(delay: 1200.ms, duration: 600.ms)
                          .slideX(begin: 0.3, end: 0),

                      if (_isLoading) ...[
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(
                          color: AppColors.silverLight,
                        ).animate().fadeIn(),
                      ],
                    ],
                  ),
                ),
              ),

              // Ad Banner
              const AdBannerWidget().animate().fadeIn(delay: 1400.ms),

              // Footer
              const SizedBox(height: 16),

              Text(
                'Powered by AI • Made with ❤️',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.silverDark,
                  fontSize: 11,
                ),
              ).animate().fadeIn(delay: 1500.ms, duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isOutlined = false,
    Gradient? gradient,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.silverMedium),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon, color: AppColors.black),
                label: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
    );
  }
}
