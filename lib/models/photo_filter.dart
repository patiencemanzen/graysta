enum FilterType {
  // Essential Base Filters
  none,
  moodyGray,
  filmNoir,
  vintageFilm,

  // Popular Social Media Filters
  goldenHour,
  aestheticVibe,
  neonNights,
  sunsetGlow,
  oceanBreeze,

  // Cinematic Filters
  cinematicTeal,
  hollywoodGold,
  bladeRunner,
  warmCinema,
  coolCinema,
  dramaticShadows,

  // Modern Creative Filters
  luxuryGold,
  minimalistClean,
  cottageCoreWarm,
  darkAcademia,
}

class PhotoFilter {
  final FilterType type;
  final String name;
  final String description;
  final String emoji;

  const PhotoFilter({
    required this.type,
    required this.name,
    required this.description,
    required this.emoji,
  });

  static const List<PhotoFilter> availableFilters = [
    // Essential Base
    PhotoFilter(
      type: FilterType.none,
      name: 'Original',
      description: 'No filter applied',
      emoji: '📷',
    ),
    PhotoFilter(
      type: FilterType.moodyGray,
      name: 'Moody Gray',
      description: 'Grayscale with enhanced contrast',
      emoji: '🩶',
    ),
    PhotoFilter(
      type: FilterType.filmNoir,
      name: 'Film Noir',
      description: 'Classic cinema style shadows',
      emoji: '🎬',
    ),
    PhotoFilter(
      type: FilterType.vintageFilm,
      name: 'Vintage Film',
      description: 'Authentic 90s film camera nostalgia',
      emoji: '📸',
    ),

    // 🔥 POPULAR SOCIAL MEDIA FILTERS 🔥
    PhotoFilter(
      type: FilterType.goldenHour,
      name: 'Golden Hour',
      description: 'Perfect Instagram warm golden tones',
      emoji: '🌅',
    ),
    PhotoFilter(
      type: FilterType.aestheticVibe,
      name: 'Aesthetic Vibe',
      description: 'Trendy soft pastels with dreamy glow',
      emoji: '🌸',
    ),
    PhotoFilter(
      type: FilterType.neonNights,
      name: 'Neon Nights',
      description: 'Electric purple & cyan cyberpunk mood',
      emoji: '�',
    ),
    PhotoFilter(
      type: FilterType.sunsetGlow,
      name: 'Sunset Glow',
      description: 'Golden orange warmth like magic hour',
      emoji: '🧡',
    ),
    PhotoFilter(
      type: FilterType.oceanBreeze,
      name: 'Ocean Breeze',
      description: 'Cool blues & teals with fresh vibes',
      emoji: '🌊',
    ),

    // 🎬 CINEMATIC FILTERS 🎬
    PhotoFilter(
      type: FilterType.cinematicTeal,
      name: 'Cinematic Teal',
      description: 'Hollywood blockbuster teal & orange',
      emoji: '�',
    ),
    PhotoFilter(
      type: FilterType.hollywoodGold,
      name: 'Hollywood Gold',
      description: 'Luxurious golden cinema look',
      emoji: '�',
    ),
    PhotoFilter(
      type: FilterType.bladeRunner,
      name: 'Blade Runner',
      description: 'Neo-noir cyberpunk atmosphere',
      emoji: '�',
    ),
    PhotoFilter(
      type: FilterType.warmCinema,
      name: 'Warm Cinema',
      description: 'Cozy cinematic warmth',
      emoji: '🎪',
    ),
    PhotoFilter(
      type: FilterType.coolCinema,
      name: 'Cool Cinema',
      description: 'Modern thriller blue tones',
      emoji: '❄️',
    ),
    PhotoFilter(
      type: FilterType.dramaticShadows,
      name: 'Dramatic Shadows',
      description: 'High contrast cinema drama',
      emoji: '�',
    ),

    // ✨ MODERN CREATIVE FILTERS ✨
    PhotoFilter(
      type: FilterType.luxuryGold,
      name: 'Luxury Gold',
      description: 'Rich golden tones for premium feel',
      emoji: '👑',
    ),
    PhotoFilter(
      type: FilterType.minimalistClean,
      name: 'Clean Minimal',
      description: 'Crisp whites & soft shadows for modern look',
      emoji: '⚪',
    ),
    PhotoFilter(
      type: FilterType.cottageCoreWarm,
      name: 'Cottagecore',
      description: 'Warm earthy tones with cozy vibes',
      emoji: '🍄',
    ),
    PhotoFilter(
      type: FilterType.darkAcademia,
      name: 'Dark Academia',
      description: 'Rich browns & deep shadows for mystery',
      emoji: '�',
    ),
  ];
}
