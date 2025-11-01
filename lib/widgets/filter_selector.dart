import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../models/photo_filter.dart';

class FilterSelector extends StatelessWidget {
  final List<PhotoFilter> filters;
  final FilterType selectedFilter;
  final ValueChanged<FilterType> onFilterSelected;
  final bool isProcessing;

  const FilterSelector({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter.type == selectedFilter;

          return _FilterItem(
                filter: filter,
                isSelected: isSelected,
                isProcessing: isProcessing,
                onTap: () => onFilterSelected(filter.type),
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: index * 100),
                duration: 600.ms,
              )
              .slideY(begin: 0.3, end: 0);
        },
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final PhotoFilter filter;
  final bool isSelected;
  final bool isProcessing;
  final VoidCallback onTap;

  const _FilterItem({
    required this.filter,
    required this.isSelected,
    required this.isProcessing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: isProcessing ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.silverLight.withOpacity(0.1)
                : AppColors.secondaryDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.silverLight : AppColors.accentGray,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.silverLight.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Filter emoji/icon
              AnimatedScale(
                scale: isSelected ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(filter.emoji, style: const TextStyle(fontSize: 24)),
              ),

              const SizedBox(height: 8),

              // Filter name
              Text(
                filter.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? AppColors.silverLight
                      : AppColors.silverMedium,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Processing indicator
              if (isProcessing && isSelected) ...[
                const SizedBox(height: 4),
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.silverLight,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FilterPreviewGrid extends StatelessWidget {
  final List<PhotoFilter> filters;
  final FilterType selectedFilter;
  final ValueChanged<FilterType> onFilterSelected;
  final Widget Function(FilterType) previewBuilder;
  final bool isProcessing;

  const FilterPreviewGrid({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.previewBuilder,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filters.length,
      itemBuilder: (context, index) {
        final filter = filters[index];
        final isSelected = filter.type == selectedFilter;

        return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: isProcessing ? null : () => onFilterSelected(filter.type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 140, // Fixed width for horizontal scroll
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.silverLight
                          : AppColors.accentGray,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.silverLight.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Filter preview image - larger area for image
                        Expanded(
                          flex: 3,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Preview image
                              previewBuilder(filter.type),

                              // Subtle overlay for text readability
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppColors.black.withOpacity(0.4),
                                    ],
                                    stops: const [0.7, 1.0],
                                  ),
                                ),
                              ),

                              // Processing overlay
                              if (isProcessing && isSelected)
                                Container(
                                  color: AppColors.black.withOpacity(0.7),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              AppColors.silverLight,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Processing...',
                                          style: TextStyle(
                                            color: AppColors.silverLight,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // Selected indicator
                              if (isSelected && !isProcessing)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: AppColors.silverLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Filter info section - compact bottom area
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryDark,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    filter.emoji,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      filter.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: isSelected
                                                ? AppColors.silverLight
                                                : AppColors.silverMedium,
                                            fontSize: 11,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: index * 100),
              duration: 600.ms,
            )
            .scale(begin: const Offset(0.8, 0.8));
      },
    );
  }
}
