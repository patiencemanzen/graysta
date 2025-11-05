import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  static bool _isInitialized = false;
  static bool _adsEnabled = true;

  // Production Ad Unit IDs - Replace with your actual AdMob ad unit IDs
  static const String _androidBannerAdUnitId =
      'ca-app-pub-4952214744306447/1234567890'; // Replace with your banner ad unit ID
  static const String _iosBannerAdUnitId =
      'ca-app-pub-4952214744306447/1234567891'; // Replace with your iOS banner ad unit ID

  static const String _androidInterstitialAdUnitId =
      'ca-app-pub-4952214744306447/1234567892'; // Replace with your interstitial ad unit ID
  static const String _iosInterstitialAdUnitId =
      'ca-app-pub-4952214744306447/1234567893'; // Replace with your iOS interstitial ad unit ID

  static const String _androidRewardedAdUnitId =
      'ca-app-pub-4952214744306447/1234567894'; // Replace with your rewarded ad unit ID
  static const String _iosRewardedAdUnitId =
      'ca-app-pub-4952214744306447/1234567895'; // Replace with your iOS rewarded ad unit ID

  // Get platform-specific ad unit IDs
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return _androidBannerAdUnitId;
    } else if (Platform.isIOS) {
      return _iosBannerAdUnitId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return _androidInterstitialAdUnitId;
    } else if (Platform.isIOS) {
      return _iosInterstitialAdUnitId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return _androidRewardedAdUnitId;
    } else if (Platform.isIOS) {
      return _iosRewardedAdUnitId;
    }
    throw UnsupportedError('Unsupported platform');
  }

  // Initialize AdMob
  static Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    _isInitialized = true;

    // Update the consent information
    await _updateConsentInformation();
  }

  // Update consent information for GDPR compliance
  static Future<void> _updateConsentInformation() async {
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        // Consent info updated successfully
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadConsentForm();
        }
      },
      (FormError error) {
        // Handle consent info update error
        if (kDebugMode) print('Consent info update failed: ${error.message}');
      },
    );
  }

  // Load consent form
  static void _loadConsentForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((FormError? formError) {
            // Handle form error
            // Handle form error if needed
            _loadConsentForm();
          });
        }
      },
      (FormError formError) {
        // Handle form load error
        if (kDebugMode) print('Consent form load failed: ${formError.message}');
      },
    );
  }

  // Check if ads are enabled
  static bool get adsEnabled => _adsEnabled && _isInitialized;

  // Disable ads (for premium users or testing)
  static void disableAds() {
    _adsEnabled = false;
  }

  // Enable ads
  static void enableAds() {
    _adsEnabled = true;
  }

  // Create banner ad
  static BannerAd createBannerAd({
    required AdSize adSize,
    required BannerAdListener listener,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: listener,
    );
  }

  // Load interstitial ad
  static Future<InterstitialAd?> loadInterstitialAd() async {
    if (!adsEnabled) return null;

    InterstitialAd? interstitialAd;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Silently handle ad load failure in production
          if (kDebugMode) print('InterstitialAd failed to load: $error');
        },
      ),
    );

    return interstitialAd;
  }

  // Load rewarded ad
  static Future<RewardedAd?> loadRewardedAd() async {
    if (!adsEnabled) return null;

    RewardedAd? rewardedAd;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Silently handle ad load failure in production
          if (kDebugMode) print('RewardedAd failed to load: $error');
        },
      ),
    );

    return rewardedAd;
  }

  // Show interstitial ad with callback
  static Future<void> showInterstitialAd(
    InterstitialAd? ad, {
    VoidCallback? onAdClosed,
  }) async {
    if (ad == null || !adsEnabled) {
      onAdClosed?.call();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        onAdClosed?.call();
        if (kDebugMode) print('InterstitialAd failed to show: $error');
      },
    );

    await ad.show();
  }

  // Show rewarded ad with reward callback
  static Future<void> showRewardedAd(
    RewardedAd? ad, {
    required void Function(AdWithoutView, RewardItem) onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) async {
    if (ad == null || !adsEnabled) {
      onAdClosed?.call();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        onAdClosed?.call();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        onAdClosed?.call();
        if (kDebugMode) print('RewardedAd failed to show: $error');
      },
    );

    await ad.show(onUserEarnedReward: onUserEarnedReward);
  }
}
