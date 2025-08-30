import 'package:flutter/material.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/search/search_screen/data/models/history_search_model.dart';

class HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const HistoryListItem({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorsManager.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManager.primaryGreen)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap:onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "${item.time} - ${item.date}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: ColorsManager.darkPurple),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
