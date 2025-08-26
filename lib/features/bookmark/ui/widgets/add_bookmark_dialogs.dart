import 'package:flutter/material.dart';

class AddToFavoritesDialog extends StatefulWidget {
  const AddToFavoritesDialog({super.key});

  @override
  State<AddToFavoritesDialog> createState() => _AddToFavoritesDialogState();
}

class _AddToFavoritesDialogState extends State<AddToFavoritesDialog> {
  bool showCreateNew = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        width: 350,
        child: showCreateNew ? buildCreateNew() : buildCollections(),
      ),
    );
  }

  Widget buildCollections() {
    final collections = ["test", "", "افتراضي"]; // example list

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "إضافة للمفضلة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 4),
        const Text("مجموعة الإشارات المرجعية"),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              collections.map((c) {
                return OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border, size: 18),
                  label: Text(c.isEmpty ? "-" : c),
                );
              }).toList(),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () {
            setState(() {
              showCreateNew = true;
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("إنشاء مجموعة جديدة"),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء"),
        ),
      ],
    );
  }

  Widget buildCreateNew() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "إضافة للمفضلة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text("اسم المجموعة الجديدة"),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: "أدخل اسم المجموعة",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "ملاحظات الإشارة المرجعية (اختياري)",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // هنا تضيف الكود لإرسال البيانات
              },
              icon: const Icon(Icons.add),
              label: const Text("إنشاء"),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  showCreateNew = false;
                });
              },
              child: const Text("إلغاء"),
            ),
          ],
        ),
      ],
    );
  }
}
