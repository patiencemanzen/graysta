import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import '../models/photo_filter.dart';

class ImageFilterService {
  static Future<Uint8List> applyFilter(
    Uint8List imageBytes,
    FilterType filter,
  ) async {
    // Decode the image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    // Apply the filter based on type
    switch (filter) {
      // Essential Base Filters
      case FilterType.none:
        return imageBytes;

      case FilterType.moodyGray:
        image = _applyMoodyGray(image);
        break;

      case FilterType.filmNoir:
        image = _applyFilmNoir(image);
        break;

      case FilterType.vintageFilm:
        image = _applyVintageFilm(image);
        break;

      // Popular Social Media Filters
      case FilterType.goldenHour:
        image = _applyGoldenHour(image);
        break;

      case FilterType.aestheticVibe:
        image = _applyAestheticVibe(image);
        break;

      case FilterType.neonNights:
        image = _applyNeonNights(image);
        break;

      case FilterType.sunsetGlow:
        image = _applySunsetGlow(image);
        break;

      case FilterType.oceanBreeze:
        image = _applyOceanBreeze(image);
        break;

      // 🎬 Cinematic Filters 🎬
      case FilterType.cinematicTeal:
        image = _applyCinematicTeal(image);
        break;

      case FilterType.hollywoodGold:
        image = _applyHollywoodGold(image);
        break;

      case FilterType.bladeRunner:
        image = _applyBladeRunner(image);
        break;

      case FilterType.warmCinema:
        image = _applyWarmCinema(image);
        break;

      case FilterType.coolCinema:
        image = _applyCoolCinema(image);
        break;

      case FilterType.dramaticShadows:
        image = _applyDramaticShadows(image);
        break;

      // Modern Creative Filters
      case FilterType.luxuryGold:
        image = _applyLuxuryGold(image);
        break;

      case FilterType.minimalistClean:
        image = _applyMinimalistClean(image);
        break;

      case FilterType.cottageCoreWarm:
        image = _applyCottageCoreWarm(image);
        break;

      case FilterType.darkAcademia:
        image = _applyDarkAcademia(image);
        break;
    }

    // Encode the image back to bytes
    return Uint8List.fromList(img.encodePng(image));
  }

  static img.Image _applyMoodyGray(img.Image image) {
    // Convert to grayscale and increase contrast
    image = img.grayscale(image);
    image = img.contrast(image, contrast: 120);
    image = img.adjustColor(image, brightness: 0.9);
    return image;
  }

  // Essential filter implementations (only methods actually used)

  static img.Image _applyFilmNoir(img.Image image) {
    // Classic cinema style shadows
    image = img.grayscale(image);
    image = img.contrast(image, contrast: 130);

    // Create shadow enhancement
    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final brightness = pixels[i]; // Grayscale, so R=G=B

      if (brightness < 100) {
        // Enhance shadows (darken them more)
        final newBrightness = (brightness * 0.7).clamp(0, 255).round();
        pixels[i] = newBrightness;
        pixels[i + 1] = newBrightness;
        pixels[i + 2] = newBrightness;
      } else if (brightness > 180) {
        // Soften highlights slightly
        final newBrightness = (brightness * 0.9).clamp(0, 255).round();
        pixels[i] = newBrightness;
        pixels[i + 1] = newBrightness;
        pixels[i + 2] = newBrightness;
      }
    }

    return image;
  }

  static Future<ui.Image> uint8ListToImage(Uint8List imageBytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<Uint8List> imageToUint8List(ui.Image image) async {
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  // 🔥 CREATIVE SOCIAL MEDIA FILTERS 🔥

  static img.Image _applyAestheticVibe(img.Image image) {
    // Trendy soft pastels with dreamy glow - perfect for aesthetic posts
    image = img.adjustColor(
      image,
      saturation: 0.7,
      brightness: 1.15,
      gamma: 1.2,
    );

    // Add soft pink/purple tint
    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      pixels[i] = (pixels[i] * 1.05).clamp(0, 255).round(); // Slight pink
      pixels[i + 1] = (pixels[i + 1] * 0.98).clamp(0, 255).round();
      pixels[i + 2] = (pixels[i + 2] * 1.08)
          .clamp(0, 255)
          .round(); // Purple tint
    }

    // Soft glow effect
    image = img.gaussianBlur(image, radius: 1);
    return image;
  }

  static img.Image _applyNeonNights(img.Image image) {
    // Electric purple & cyan cyberpunk mood - viral TikTok style
    image = img.adjustColor(
      image,
      saturation: 1.4,
      brightness: 0.85,
      contrast: 130,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final luminance = (0.299 * r + 0.587 * g + 0.114 * b);

      if (luminance > 120) {
        // Bright areas = electric cyan
        pixels[i] = (r * 0.6).clamp(0, 255).round();
        pixels[i + 1] = (g * 1.3).clamp(0, 255).round();
        pixels[i + 2] = (b * 1.4).clamp(0, 255).round();
      } else {
        // Dark areas = deep purple
        pixels[i] = (r * 1.2).clamp(0, 255).round();
        pixels[i + 1] = (g * 0.7).clamp(0, 255).round();
        pixels[i + 2] = (b * 1.3).clamp(0, 255).round();
      }
    }
    return image;
  }

  static img.Image _applyCottageCoreWarm(img.Image image) {
    // Warm earthy tones with cozy vibes - trending aesthetic
    image = img.adjustColor(
      image,
      saturation: 0.8,
      brightness: 1.1,
      gamma: 0.9,
    );

    // Warm earth tones
    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      pixels[i] = (pixels[i] * 1.15).clamp(0, 255).round(); // Warm reds
      pixels[i + 1] = (pixels[i + 1] * 1.05)
          .clamp(0, 255)
          .round(); // Golden greens
      pixels[i + 2] = (pixels[i + 2] * 0.85)
          .clamp(0, 255)
          .round(); // Reduce blues
    }

    // Soft focus for cozy feel
    image = img.gaussianBlur(image, radius: 1);
    return image;
  }

  static img.Image _applyDarkAcademia(img.Image image) {
    // Rich browns & deep shadows for mystery - Instagram favorite
    image = img.adjustColor(
      image,
      saturation: 0.6,
      brightness: 0.8,
      contrast: 140,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];

      // Create rich brown/sepia tones
      final sepia_r = (r * 0.393 + g * 0.769 + b * 0.189).clamp(0, 255);
      final sepia_g = (r * 0.349 + g * 0.686 + b * 0.168).clamp(0, 255);
      final sepia_b = (r * 0.272 + g * 0.534 + b * 0.131).clamp(0, 255);

      pixels[i] = (sepia_r * 0.8).clamp(0, 255).round();
      pixels[i + 1] = (sepia_g * 0.7).clamp(0, 255).round();
      pixels[i + 2] = (sepia_b * 0.6).clamp(0, 255).round();
    }
    return image;
  }

  static img.Image _applySunsetGlow(img.Image image) {
    // Golden orange warmth like magic hour - perfect for portraits
    image = img.adjustColor(
      image,
      saturation: 1.2,
      brightness: 1.1,
      gamma: 0.85,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final luminance =
          (0.299 * pixels[i] + 0.587 * pixels[i + 1] + 0.114 * pixels[i + 2]);

      // Add golden sunset glow
      if (luminance > 100) {
        pixels[i] = (pixels[i] * 1.25).clamp(0, 255).round(); // Golden red
        pixels[i + 1] = (pixels[i + 1] * 1.15)
            .clamp(0, 255)
            .round(); // Warm yellow
        pixels[i + 2] = (pixels[i + 2] * 0.7)
            .clamp(0, 255)
            .round(); // Reduce blue
      }
    }
    return image;
  }

  static img.Image _applyOceanBreeze(img.Image image) {
    // Cool blues & teals with fresh vibes - summer favorite
    image = img.adjustColor(
      image,
      saturation: 1.1,
      brightness: 1.05,
      contrast: 110,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      pixels[i] = (pixels[i] * 0.8).clamp(0, 255).round(); // Reduce red
      pixels[i + 1] = (pixels[i + 1] * 1.1)
          .clamp(0, 255)
          .round(); // Enhance green (for teal)
      pixels[i + 2] = (pixels[i + 2] * 1.3)
          .clamp(0, 255)
          .round(); // Strong blue
    }

    // Add slight blur for dreamy ocean feel
    image = img.gaussianBlur(image, radius: 1);
    return image;
  }

  static img.Image _applyGoldenHour(img.Image image) {
    // Perfect Instagram warm golden tones - most popular filter style
    image = img.adjustColor(
      image,
      saturation: 0.9,
      brightness: 1.08,
      contrast: 115,
      gamma: 0.9,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final luminance = (0.299 * r + 0.587 * g + 0.114 * b);

      // Golden hour magic
      if (luminance > 80) {
        pixels[i] = (r * 1.18).clamp(0, 255).round(); // Warm gold
        pixels[i + 1] = (g * 1.12).clamp(0, 255).round(); // Soft yellow
        pixels[i + 2] = (b * 0.75).clamp(0, 255).round(); // Reduce cold blues
      } else {
        // Keep shadows warm but not too bright
        pixels[i] = (r * 1.05).clamp(0, 255).round();
        pixels[i + 1] = (g * 1.02).clamp(0, 255).round();
        pixels[i + 2] = (b * 0.95).clamp(0, 255).round();
      }
    }
    return image;
  }

  static img.Image _applyMinimalistClean(img.Image image) {
    // Crisp whites & soft shadows for modern look - perfect for product photos
    image = img.adjustColor(
      image,
      saturation: 0.4,
      brightness: 1.2,
      contrast: 120,
      gamma: 1.3,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final luminance =
          (0.299 * pixels[i] + 0.587 * pixels[i + 1] + 0.114 * pixels[i + 2]);

      if (luminance > 200) {
        // Pure whites
        pixels[i] = 255;
        pixels[i + 1] = 255;
        pixels[i + 2] = 255;
      } else if (luminance > 120) {
        // Soft grays
        final gray = (luminance * 1.3).clamp(0, 255).round();
        pixels[i] = gray;
        pixels[i + 1] = gray;
        pixels[i + 2] = gray;
      }
    }
    return image;
  }

  static img.Image _applyVintageFilm(img.Image image) {
    // Authentic 90s film camera nostalgia - retro vibes
    image = img.adjustColor(
      image,
      saturation: 0.85,
      brightness: 1.0,
      contrast: 105,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      // Film grain and vintage color cast
      final noise = ((i / 4) % 13 - 6) * 3; // Film grain pattern

      pixels[i] = (pixels[i] * 1.1 + noise).clamp(0, 255).round(); // Warm reds
      pixels[i + 1] = (pixels[i + 1] * 1.05 + noise * 0.8)
          .clamp(0, 255)
          .round();
      pixels[i + 2] = (pixels[i + 2] * 0.9 + noise * 0.6)
          .clamp(0, 255)
          .round(); // Faded blues
    }

    // Subtle vignette effect
    final width = image.width;
    final height = image.height;
    final centerX = width / 2;
    final centerY = height / 2;
    final maxDistance = (width + height) / 4;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final distance =
            ((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY)) /
            (maxDistance * maxDistance);
        final vignette = (1 - distance * 0.3).clamp(0.7, 1.0);

        final pixel = image.getPixel(x, y);
        image.setPixel(
          x,
          y,
          img.ColorRgba8(
            (pixel.r * vignette).round(),
            (pixel.g * vignette).round(),
            (pixel.b * vignette).round(),
            pixel.a.toInt(),
          ),
        );
      }
    }

    return image;
  }

  static img.Image _applyLuxuryGold(img.Image image) {
    // Rich golden tones for premium feel - luxury brand aesthetic
    image = img.adjustColor(
      image,
      saturation: 1.0,
      brightness: 1.05,
      contrast: 125,
      gamma: 0.85,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final luminance = (0.299 * r + 0.587 * g + 0.114 * b);

      if (luminance > 140) {
        // Rich gold highlights
        pixels[i] = (255 * 0.9).round(); // Bright gold
        pixels[i + 1] = (215 * 0.9).round(); // Golden yellow
        pixels[i + 2] = (0 * 0.9).round(); // No blue
      } else if (luminance > 80) {
        // Warm mid tones
        pixels[i] = (r * 1.3).clamp(0, 255).round();
        pixels[i + 1] = (g * 1.2).clamp(0, 255).round();
        pixels[i + 2] = (b * 0.6).clamp(0, 255).round();
      } else {
        // Rich dark browns
        pixels[i] = (r * 0.8 + 40).clamp(0, 255).round();
        pixels[i + 1] = (g * 0.6 + 20).clamp(0, 255).round();
        pixels[i + 2] = (b * 0.4 + 10).clamp(0, 255).round();
      }
    }
    return image;
  }

  // 🎬 CINEMATIC FILTERS - Hollywood Quality 🎬

  static img.Image _applyCinematicTeal(img.Image image) {
    // Hollywood blockbuster teal & orange look
    image = img.adjustColor(
      image,
      saturation: 1.3,
      brightness: 1.02,
      contrast: 125,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final luminance = (0.299 * r + 0.587 * g + 0.114 * b);

      if (luminance > 140) {
        // Highlights = warm orange
        pixels[i] = (r * 1.25).clamp(0, 255).round();
        pixels[i + 1] = (g * 1.15).clamp(0, 255).round();
        pixels[i + 2] = (b * 0.7).clamp(0, 255).round();
      } else if (luminance < 80) {
        // Shadows = cool teal
        pixels[i] = (r * 0.7).clamp(0, 255).round();
        pixels[i + 1] = (g * 1.1).clamp(0, 255).round();
        pixels[i + 2] = (b * 1.3).clamp(0, 255).round();
      }
    }
    return image;
  }

  static img.Image _applyHollywoodGold(img.Image image) {
    // Luxurious golden cinema look - Oscar worthy
    image = img.adjustColor(
      image,
      saturation: 1.1,
      brightness: 1.08,
      contrast: 130,
      gamma: 0.9,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];

      // Golden hour cinema magic
      pixels[i] = (r * 1.2 + 20).clamp(0, 255).round();
      pixels[i + 1] = (g * 1.15 + 15).clamp(0, 255).round();
      pixels[i + 2] = (b * 0.75).clamp(0, 255).round();
    }
    return image;
  }

  static img.Image _applyBladeRunner(img.Image image) {
    // Neo-noir cyberpunk atmosphere - Ridley Scott style
    image = img.adjustColor(
      image,
      saturation: 1.5,
      brightness: 0.85,
      contrast: 155,
      gamma: 0.75,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final intensity = (r + g + b) / 3;

      if (intensity > 160) {
        // Bright neon highlights
        pixels[i] = (255 * 0.9).round();
        pixels[i + 1] = (100 * 0.9).round();
        pixels[i + 2] = (255 * 0.9).round(); // Magenta-blue
      } else if (intensity < 60) {
        // Deep noir shadows
        pixels[i] = (r * 0.3).clamp(0, 255).round();
        pixels[i + 1] = (g * 0.5).clamp(0, 255).round();
        pixels[i + 2] = (b * 0.8).clamp(0, 255).round();
      } else {
        // Mid tones with cyan bias
        pixels[i] = (r * 0.8).clamp(0, 255).round();
        pixels[i + 1] = (g * 1.1).clamp(0, 255).round();
        pixels[i + 2] = (b * 1.2).clamp(0, 255).round();
      }
    }
    return image;
  }

  static img.Image _applyWarmCinema(img.Image image) {
    // Cozy cinematic warmth - perfect for intimate scenes
    image = img.adjustColor(
      image,
      saturation: 0.9,
      brightness: 1.05,
      contrast: 115,
      gamma: 1.1,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      pixels[i] = (pixels[i] * 1.15 + 25).clamp(0, 255).round(); // Warm reds
      pixels[i + 1] = (pixels[i + 1] * 1.08 + 15)
          .clamp(0, 255)
          .round(); // Golden
      pixels[i + 2] = (pixels[i + 2] * 0.85)
          .clamp(0, 255)
          .round(); // Reduce cool blues
    }
    return image;
  }

  static img.Image _applyCoolCinema(img.Image image) {
    // Modern thriller blue tones - Christopher Nolan style
    image = img.adjustColor(
      image,
      saturation: 1.2,
      brightness: 0.95,
      contrast: 135,
      gamma: 0.85,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      pixels[i] = (pixels[i] * 0.85).clamp(0, 255).round(); // Reduce warm tones
      pixels[i + 1] = (pixels[i + 1] * 1.05).clamp(0, 255).round();
      pixels[i + 2] = (pixels[i + 2] * 1.25)
          .clamp(0, 255)
          .round(); // Strong blues
    }
    return image;
  }

  static img.Image _applyDramaticShadows(img.Image image) {
    // High contrast cinema drama - intense emotional impact
    image = img.adjustColor(
      image,
      saturation: 0.8,
      brightness: 1.0,
      contrast: 175,
      gamma: 0.7,
    );

    final pixels = image.getBytes();
    for (int i = 0; i < pixels.length; i += 4) {
      final luminance =
          (0.299 * pixels[i] + 0.587 * pixels[i + 1] + 0.114 * pixels[i + 2]);

      if (luminance > 180) {
        // Dramatic highlights
        pixels[i] = 255;
        pixels[i + 1] = 255;
        pixels[i + 2] = 255;
      } else if (luminance < 70) {
        // Deep cinematic shadows
        pixels[i] = (pixels[i] * 0.3).clamp(0, 255).round();
        pixels[i + 1] = (pixels[i + 1] * 0.3).clamp(0, 255).round();
        pixels[i + 2] = (pixels[i + 2] * 0.3).clamp(0, 255).round();
      }
    }
    return image;
  }
}
