import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/helpers/spacing.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final String? hintText;
  final VoidCallback? onTap;

  const SearchBarWidget({
    required this.controller, required this.onSearch, super.key,
    this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
    
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: ColorsManager.secondaryBackground,
        elevation: 2,
        child: TextField(
          onTap:onTap,
          controller: controller,
          onSubmitted: onSearch,
          decoration: InputDecoration(
            hintText: hintText ?? 'ابحث في الأحاديث...',
            hintStyle: TextStyles.bodyMedium.copyWith(
              color: ColorsManager.secondaryText,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: ColorsManager.primaryPurple,
              size: 24,
            ),
            suffixIcon:
                controller.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: ColorsManager.gray,
                        size: 20,
                      ),
                      onPressed: controller.clear,
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.md,
            ),
          ),
          style: TextStyles.bodyMedium,
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }
}
