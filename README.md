# 📸 Graysta - AI-Powered Photo Editor

> **Transform Ordinary into Cinematic**

Graysta is a modern, mobile-first Flutter app that specializes in turning normal photos into stylish, cinematic grayscale looks with instant filters and optional AI enhancement.

## ✨ Features

### 🎨 Core Functionality
- **Photo Input**: Capture photos directly or choose from gallery
- **Instant Filters** (6 preset styles):
  - 🩶 **Moody Gray** - Grayscale with enhanced contrast
  - 🌆 **Urban Fade** - Desaturated soft tone  
  - 🕯 **Soft Matte** - Low contrast with soft brightness
  - 🪶 **Vintage Silver** - Grayscale with subtle sepia tones
  - ⚡ **Cool Chrome** - Bluish gray with enhanced highlights
  - 📷 **Original** - No filter applied

### 🤖 AI Enhancement
- **AI-Powered Enhancement**: Optional AI processing for deeper, more cinematic edits
- **Progress Indicators**: Real-time feedback during AI processing
- **Offline Capability**: All filters work without internet connection

### 🎛 Interactive Tools
- **Before/After Slider**: Compare original vs. filtered images with draggable slider
- **Real-time Preview**: Instant filter application and preview
- **Filter Selection**: Easy-to-use filter selector with visual previews

### 💾 Export & Share
- **Save to Gallery**: Save edited photos to device gallery
- **Share Photos**: Share directly to social media and messaging apps
- **Multiple Formats**: Support for PNG and JPEG formats

## 🎨 Design

### Dark Theme Aesthetic
- **Colors**: Clean dark theme with gray, black, and silver accents
- **Modern UI**: Rounded buttons, smooth animations, minimalist design
- **Mobile-First**: Optimized for portrait orientation and touch interaction

### Smooth Animations
- **Flutter Animate**: Powered by flutter_animate for smooth transitions
- **Interactive Feedback**: Visual feedback for user interactions
- **Splash Screen**: Elegant app introduction with GrayStyle branding

## 📱 Technical Stack

### Core Technologies
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Image Processing**: Advanced image manipulation and filtering

### Key Packages
```yaml
dependencies:
  # Image Processing & Camera
  image_picker: ^1.0.7        # Photo selection and capture
  camera: ^0.10.5+9           # Camera functionality
  image: ^4.1.7               # Image manipulation
  
  # File Management
  path_provider: ^2.1.2       # File system access
  gallery_saver: ^2.3.2       # Save to gallery
  share_plus: ^7.2.2          # Social sharing
  
  # UI & Animations  
  flutter_animate: ^4.5.0     # Smooth animations
  
  # Networking & State
  http: ^0.13.6               # API communication
  provider: ^6.1.1            # State management
  permission_handler: ^11.3.0 # Device permissions
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd graysta
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Permissions automatically handled for camera and storage

#### iOS  
- iOS 11.0 or higher
- Camera and Photo Library permissions configured

## 🎯 Usage

1. **Launch Graysta** - See the elegant splash screen
2. **Choose Photo Source**:
   - Take a new photo with camera
   - Select from gallery
3. **Apply Filters**:
   - Browse through 6 stylish preset filters
   - See real-time preview
4. **AI Enhancement** (optional):
   - Tap "✨ Enhance with AI" for deeper processing
   - Wait for AI magic to complete
5. **Compare Results**:
   - Use before/after slider to compare
   - Toggle between original and filtered versions
6. **Save & Share**:
   - Save to gallery
   - Share to social media

## 🔮 AI Integration

The app includes a placeholder AI service ready for integration with:
- **Replicate API**
- **Hugging Face**  
- **OpenAI DALL-E**
- **Custom AI Models**

Current implementation simulates AI processing for demo purposes. Replace the placeholder in `lib/services/ai_service.dart` with your preferred AI provider.

## 🎨 Filter Details

### Moody Gray 🩶
- Converts to grayscale
- Increases contrast for dramatic effect
- Slightly reduces brightness for mood

### Urban Fade 🌆  
- Desaturates colors for faded look
- Soft brightness adjustment
- Reduced contrast for smooth tones

### Soft Matte 🕯
- Low contrast for matte finish
- Increased brightness
- Subtle gaussian blur
- Reduced saturation

### Vintage Silver 🪶
- Classic grayscale conversion
- Subtle sepia toning (20%)
- Enhanced contrast
- Slight brightness boost

### Cool Chrome ⚡
- Bluish gray color grading
- Enhanced highlights
- Reduced saturation with blue tint
- Increased contrast for definition

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── photo_filter.dart     # Filter definitions
├── screens/
│   ├── splash_screen.dart    # App splash screen
│   ├── home_screen.dart      # Main navigation
│   └── photo_editor_screen.dart # Editor interface
├── services/
│   ├── camera_service.dart   # Camera & gallery access
│   ├── image_filter_service.dart # Filter processing
│   ├── ai_service.dart       # AI enhancement
│   └── file_service.dart     # File operations
├── theme/
│   ├── app_colors.dart       # Color definitions
│   └── app_theme.dart        # Theme configuration
└── widgets/
    ├── before_after_slider.dart # Comparison slider
    └── filter_selector.dart     # Filter selection UI
```

## 🛠 Development

### Code Quality
- **Flutter Lints**: Enforced coding standards
- **Error Handling**: Comprehensive error management
- **Performance**: Optimized image processing
- **Responsive**: Adaptive UI for different screen sizes

### Testing
```bash
flutter test                  # Run unit tests
flutter analyze              # Code analysis
flutter run --release        # Performance testing
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support, email support@graysta.app or create an issue in the repository.

---

**Made with ❤️ using Flutter • AI-Powered • Mobile-First**
