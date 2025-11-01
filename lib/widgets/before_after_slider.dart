import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BeforeAfterSlider extends StatefulWidget {
  final Widget beforeImage;
  final Widget afterImage;
  final double initialPosition;
  final ValueChanged<double>? onPositionChanged;

  const BeforeAfterSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.initialPosition = 0.5,
    this.onPositionChanged,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  late double _position;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _position = (details.localPosition.dx / constraints.maxWidth)
                  .clamp(0.0, 1.0);
              widget.onPositionChanged?.call(_position);
            });
          },
          child: Stack(
            children: [
              // Before image (full width)
              Positioned.fill(child: widget.beforeImage),

              // After image (clipped to slider position)
              Positioned.fill(
                child: ClipRect(
                  clipper: _SliderClipper(_position),
                  child: widget.afterImage,
                ),
              ),

              // Slider line and handle
              Positioned(
                left: constraints.maxWidth * _position - 1,
                top: 0,
                bottom: 0,
                child: Container(width: 2, color: AppColors.silverLight),
              ),

              // Slider handle
              Positioned(
                left: constraints.maxWidth * _position - 20,
                top: constraints.maxHeight / 2 - 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.silverLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.compare,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),

              // Labels
              if (_position > 0.1)
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ORIGINAL',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

              if (_position < 0.9)
                Positioned(
                  right: 16,
                  top: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'FILTERED',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SliderClipper extends CustomClipper<Rect> {
  final double position;

  _SliderClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(size.width * position, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return oldClipper is _SliderClipper && oldClipper.position != position;
  }
}
