import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_model.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';

// ignore: must_be_immutable
class AddToFavoritesDialog extends StatefulWidget {
  AddToFavoritesDialog({
    super.key,
    required this.bookName,
    required this.bookSlug,
    required this.chapter,
    required this.hadithNumber,
    required this.hadithText,
    required this.id,
  });

  String bookName;
  String chapter;
  String hadithNumber;
  String hadithText;

  String bookSlug;
  String id;
  @override
  State<AddToFavoritesDialog> createState() => _AddToFavoritesDialogState();
}

class _AddToFavoritesDialogState extends State<AddToFavoritesDialog> {
  bool showCreateNew = false;
  String selectedCollection = "الإفتراضي";
  String? notes;
  String? newCollection;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GetCollectionsBookmarkCubit>().getBookMarkCollections();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.9;
    final dialogWidth = maxWidth > 400 ? 400.0 : maxWidth;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: ColorsManager.secondaryBackground,
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          width: dialogWidth,
          child: showCreateNew ? buildCreateNew() : buildCollections(),
        ),
      ),
    );
  }

  Widget buildCollections() {
    return BlocBuilder<
      GetCollectionsBookmarkCubit,
      GetCollectionsBookmarkState
    >(
      builder: (context, state) {
        if (state is GetCollectionsBookmarkLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetCollectionsBookmarkError) {
          return Center(child: Text("خطأ: ${state.errMessage}"));
        } else if (state is GetCollectionsBookmarkSuccess) {
          final collections = state.collectionsResponse.collections;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _dialogHeader("إضافة للمفضلة"),
              const SizedBox(height: 8),

              Text(
                "اختر مجموعة من الإشارات المرجعية",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ColorsManager.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorsManager.lightGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children:
                      collections!.map((c) {
                        final isSelected =
                            selectedCollection == (c.collection ?? "");

                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            c.collection?.isEmpty ?? true
                                ? "الإفتراضي"
                                : c.collection!,
                            style: TextStyle(
                              color:
                                  isSelected
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
                              color:
                                  isSelected
                                      ? ColorsManager.primaryPurple
                                      : ColorsManager.mediumGray,
                            ),
                          ),
                          onSelected: (_) {
                            setState(() {
                              selectedCollection = c.collection ?? "";
                            });
                          },
                        );
                      }).toList(),
                ),
              ),

              const SizedBox(height: 28),

              BlocConsumer<AddCubitCubit, AddCubitState>(
                listener: (context, state) {
                  if (state is AddLoading) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                                    behavior: SnackBarBehavior.floating,

                        backgroundColor: ColorsManager.primaryGreen,
                        content: loadingProgressIndicator(
                          size: 30,
                          color: ColorsManager.offWhite,
                        ),
                      ),
                    );
                  } else if (state is AddSuccess) {
                    ScaffoldMessenger.of(context).clearSnackBars();

                    ScaffoldMessenger.of(context).showSnackBar(
                      
                      SnackBar(
            behavior: SnackBarBehavior.floating,
            showCloseIcon:true ,

                        backgroundColor: ColorsManager.primaryGreen,
                        content: Text(
                          'تم اضافة الحديث إلي المحفوظات',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                    context.pop();
                  } else if (state is AddFailure) {
                    ScaffoldMessenger.of(context).clearSnackBars();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                                    behavior: SnackBarBehavior.floating,

                        backgroundColor: ColorsManager.primaryGreen,
                        content: Text(
                          "حدث خطأ. حاول مرة أخري",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryPurple,
                      foregroundColor: ColorsManager.inverseText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 4,
                      shadowColor: ColorsManager.darkPurple.withOpacity(0.3),
                    ),
                    onPressed: () {
                      context.read<AddCubitCubit>().addBookmark(
                        Bookmark(
                          notes: notes,
                          collection: selectedCollection,
                          bookName: widget.bookName,
                          chapterName: widget.chapter,
                          hadithId: widget.hadithNumber,
                          hadithText: widget.hadithText,
                          type: 'hadith',
                          bookSlug: widget.bookSlug,
                          id: int.parse(widget.hadithNumber),
                        ),
                      );
                    },

                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: const Text(
                      "حفظ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorsManager.primaryPurple,
                  side: const BorderSide(
                    color: ColorsManager.primaryPurple,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => setState(() => showCreateNew = true),
                icon: const Icon(Icons.add),
                label: const Text(
                  "إنشاء مجموعة جديدة",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 Cancel
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "إلغاء",
                  style: TextStyle(
                    color: ColorsManager.secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget buildCreateNew() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dialogHeader("إنشاء مجموعة جديدة"),
        const SizedBox(height: 12),

        _inputLabel("اسم المجموعة"),
        const SizedBox(height: 6),
        _styledTextField(nameController, "أدخل اسم المجموعة"),

        const SizedBox(height: 12),

        _inputLabel("ملاحظات (اختياري)"),
        const SizedBox(height: 6),
        _styledTextField(notesController, "أدخل الملاحظات", maxLines: 3),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlocConsumer<AddCubitCubit, AddCubitState>(
              listener: (context, state) {
                if (state is AddLoading) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                                                          behavior: SnackBarBehavior.floating,

                      backgroundColor: ColorsManager.primaryGreen,
                      content: loadingProgressIndicator(
                        size: 30,
                        color: ColorsManager.offWhite,
                      ),
                    ),
                  );
                } else if (state is AddSuccess) {
                  ScaffoldMessenger.of(context).clearSnackBars();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                                                          behavior: SnackBarBehavior.floating,

                      backgroundColor: ColorsManager.primaryGreen,
                      content: Text(
                        'تم اضافة الحديث إلي المحفوظات',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  context.pop();
                } else if (state is AddFailure) {
                  ScaffoldMessenger.of(context).clearSnackBars();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: ColorsManager.primaryGreen,
                      content: Text(
                        'حدث خطأ. حاول مرة اخري',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  context.pop();
                }
              },
              builder:
                  (context, state) => ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryGreen,
                      foregroundColor: ColorsManager.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      final newCollection = nameController.text.trim();

                      context.read<AddCubitCubit>().addBookmark(
                        Bookmark(
                          notes: notesController.text,
                          collection:
                              newCollection.isEmpty
                                  ? 'الإفتراضي'
                                  : newCollection,
                          bookName: widget.bookName,
                          chapterName: widget.chapter,
                          hadithId: widget.hadithNumber,
                          hadithText: widget.hadithText,
                          type: 'hadith',
                          bookSlug: widget.bookSlug,
                          id: int.parse(widget.hadithNumber),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.bookmark_add,
                      color: ColorsManager.secondaryBackground,
                    ),
                    label: const Text(
                      "حفظ",
                      style: TextStyle(
                        color: ColorsManager.secondaryBackground,
                      ),
                    ),
                  ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => setState(() => showCreateNew = false),
              child: const Text("إلغاء"),
            ),
          ],
        ),
      ],
    );
  }

  /// =============== Helpers ===============
  Widget _dialogHeader(String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                ColorsManager.primaryPurple,
                ColorsManager.secondaryPurple,
              ],
            ),
          ),
          child: const Icon(Icons.bookmark, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: ColorsManager.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _inputLabel(String label) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: const TextStyle(
          color: ColorsManager.secondaryText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _styledTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: ColorsManager.lightGray,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
