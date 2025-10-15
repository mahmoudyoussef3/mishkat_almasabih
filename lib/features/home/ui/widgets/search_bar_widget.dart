import 'package:flutter/material.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../../../core/helpers/spacing.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final String? hintText;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSearch,
    this.onTap,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            prefixIcon: Icon(
              Icons.search,
              color: ColorsManager.primaryPurple,
              size: 24,
            ),
            suffixIcon:
                controller.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: ColorsManager.gray,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.clear();
                      },
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
