import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/admob_service.dart';
import '../theme/app_colors.dart';

class RewardedAdButton extends StatefulWidget {
  final String buttonText;
  final IconData icon;
  final VoidCallback onRewardEarned;
  final VoidCallback? onAdFailed;
  final bool enabled;

  const RewardedAdButton({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.onRewardEarned,
    this.onAdFailed,
    this.enabled = true,
  });

  @override
  State<RewardedAdButton> createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  bool _isLoading = false;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  Future<void> _loadRewardedAd() async {
    _rewardedAd = await AdMobService.loadRewardedAd();
  }

  Future<void> _showRewardedAd() async {
    if (!widget.enabled || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_rewardedAd != null) {
        await AdMobService.showRewardedAd(
          _rewardedAd,
          onUserEarnedReward: (ad, reward) {
            // User earned reward
            widget.onRewardEarned();
          },
          onAdClosed: () {
            setState(() => _isLoading = false);
            // Load new ad for next time
            _loadRewardedAd();
          },
        );
      } else {
        // Ad not ready, show error
        widget.onAdFailed?.call();
        setState(() => _isLoading = false);

        // Show fallback dialog
        if (mounted) {
          _showAdNotReadyDialog();
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      widget.onAdFailed?.call();
      print('Error showing rewarded ad: $e');
    }
  }

  void _showAdNotReadyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDark,
        title: const Text(
          'Ad Not Ready',
          style: TextStyle(color: AppColors.silverLight),
        ),
        content: const Text(
          'Please try again in a moment. Ads help keep Graysta free!',
          style: TextStyle(color: AppColors.silverMedium),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadRewardedAd(); // Retry loading
            },
            child: const Text(
              'Retry',
              style: TextStyle(color: AppColors.silverLight),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.silverLight),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.enabled && !_isLoading ? _showRewardedAd : null,
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.black,
                ),
              )
            : Icon(widget.icon, color: AppColors.black),
        label: Text(
          _isLoading ? 'Loading Ad...' : widget.buttonText,
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.enabled
              ? AppColors.silverLight
              : AppColors.silverDark.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// Premium features unlock dialog
class PremiumFeaturesDialog extends StatelessWidget {
  const PremiumFeaturesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryDark,
      title: const Row(
        children: [
          Icon(Icons.star, color: Colors.amber),
          SizedBox(width: 8),
          Text(
            'Premium Features',
            style: TextStyle(color: AppColors.silverLight),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Unlock premium features by watching a short ad:',
            style: TextStyle(color: AppColors.silverMedium),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.silverDark.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.silverLight,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Extra AI Enhancement',
                      style: TextStyle(color: AppColors.silverLight),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.hd, color: AppColors.silverLight, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'High Quality Export',
                      style: TextStyle(color: AppColors.silverLight),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.not_interested,
                      color: AppColors.silverLight,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ad-Free Experience (30 min)',
                      style: TextStyle(color: AppColors.silverLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RewardedAdButton(
            buttonText: 'Watch Ad & Unlock',
            icon: Icons.play_arrow,
            onRewardEarned: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Maybe Later',
            style: TextStyle(color: AppColors.silverMedium),
          ),
        ),
      ],
    );
  }
}
