import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/logic/cubit/get_chapter_ahadiths_cubit.dart';

class ChapterAhadithScreen extends StatefulWidget {
  const ChapterAhadithScreen({super.key, required this.bookSlug, required this.bookId});
  final String bookSlug;
  final int bookId;

  @override
  State<ChapterAhadithScreen> createState() => _ChapterAhadithScreenState();
}

class _ChapterAhadithScreenState extends State<ChapterAhadithScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetChapterAhadithsCubit>().emitChapterAhadiths(

      bookSlug: widget.bookSlug,
      hadithLocal: ,
      chapterId: widget.bookId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GetChapterAhadithsCubit, GetChapterAhadithsState>(
        builder: (context, state) {
          if (state is GetChapterAhadithsSuccess) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.hadithResponse.hadiths.data.length,
              itemBuilder: (context, index) {
                final hadith = state.hadithResponse.hadiths.data[index];
                return ListTile(
                  title: Text(hadith.arabic),
                  subtitle: Text(hadith.english.text),
                );
              },
            );
          } else if (state is GetChapterAhadithsFailure) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
