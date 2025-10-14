import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class CollectionsChoiceChips extends StatelessWidget {
  final List<String> collections;
  final String selectedCollection;
  final void Function(String) onSelected;

  const CollectionsChoiceChips({
    super.key,
    required this.collections,
    required this.selectedCollection,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsManager.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: collections.map((c) {
          final isSelected = selectedCollection == c;
          return ChoiceChip(
            showCheckmark: false,
            label: Text(
              c.isEmpty ? "بدون اسم" : c,
              style: TextStyle(
                color: isSelected
                    ? ColorsManager.inverseText
                    : ColorsManager.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            selected: isSelected,
            selectedColor: ColorsManager.primaryPurple,
            backgroundColor: ColorsManager.secondaryBackground,
            elevation: isSelected ? 3 : 0,
            pressElevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? ColorsManager.primaryPurple
                    : ColorsManager.mediumGray,
              ),
            ),
            onSelected: (_) => onSelected(c),
          );
        }).toList(),
      ),
    );
  }
}
