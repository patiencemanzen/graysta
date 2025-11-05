class AdConfig {
  // Production Ad Unit IDs (replace with your real AdMob IDs)
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458002511';

  // Banner Ad Units
  static const String androidBannerId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerId = 'ca-app-pub-3940256099942544/2934735716';

  // Interstitial Ad Units
  static const String androidInterstitialId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialId =
      'ca-app-pub-3940256099942544/4411468910';

  // Rewarded Ad Units
  static const String androidRewardedId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String iosRewardedId = 'ca-app-pub-3940256099942544/1712485313';

  // Ad Settings
  static const int interstitialAdFrequency = 3; // Show every 3 filter changes
  static const int rewardedAdCooldown =
      1800; // 30 minutes cooldown for premium features
  static const bool enableTestAds = true; // Set to false for production

  // Premium Features Duration (in seconds)
  static const int premiumFeaturesDuration = 1800; // 30 minutes

  // Ad-related Messages
  static const String adNotReadyMessage =
      'Ad not ready. Please try again in a moment.';
  static const String premiumUnlockedMessage =
      'Premium features unlocked for 30 minutes!';
  static const String supportDeveloperMessage =
      'Ads help keep Graysta free. Thank you for your support!';
}

// Premium features manager
class PremiumFeatures {
  static DateTime? _premiumUnlockedAt;

  static bool get isPremiumActive {
    if (_premiumUnlockedAt == null) return false;

    final now = DateTime.now();
    final difference = now.difference(_premiumUnlockedAt!).inSeconds;

    return difference < AdConfig.premiumFeaturesDuration;
  }

  static void unlockPremium() {
    _premiumUnlockedAt = DateTime.now();
  }

  static int get remainingPremiumTime {
    if (!isPremiumActive) return 0;

    final now = DateTime.now();
    final elapsed = now.difference(_premiumUnlockedAt!).inSeconds;
    return AdConfig.premiumFeaturesDuration - elapsed;
  }

  static String get remainingTimeFormatted {
    final remaining = remainingPremiumTime;
    if (remaining <= 0) return '0:00';

    final minutes = remaining ~/ 60;
    final seconds = remaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
