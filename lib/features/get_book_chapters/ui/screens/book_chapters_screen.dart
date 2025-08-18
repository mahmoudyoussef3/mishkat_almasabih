import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/get_book_chapters/logic/cubit/get_book_chapters_cubit.dart';

class BookChaptersScreen extends StatefulWidget {
  const BookChaptersScreen({super.key, required this.bookSlug});
  final String bookSlug;

  @override
  State<BookChaptersScreen> createState() => _BookChaptersScreenState();
}

class _BookChaptersScreenState extends State<BookChaptersScreen> {
  static const Color primaryPurple = Color(0xFF7440E9);

  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<GetBookChaptersCubit>().emitGetBookChapters(widget.bookSlug);
    _search.addListener(() {
      setState(() => _query = _search.text.trim());
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0E0E13) : const Color(0xFFF7F7FC);

    return Scaffold(
      backgroundColor: bgColor,
      body: BlocBuilder<GetBookChaptersCubit, GetBookChaptersState>(
        builder: (context, state) {
          if (state is GetBookChaptersLoading) {
            return loadingProgressIndicator();
          }

          if (state is GetBookChaptersFailure) {
            return _ErrorView(
              message: state.errorMessage?.toString() ?? 'Something went wrong',
              onRetry: () => context.read<GetBookChaptersCubit>().emitGetBookChapters(widget.bookSlug),
            );
          }

          if (state is GetBookChaptersSuccess) {
            final chapters = state.bookChaptersModel.chapters ?? [];
            final filtered = _query.isEmpty
                ? chapters
                : chapters.where((c) {
                    final ar = (c.chapterArabic ?? '').toLowerCase();
                    final en = (c.chapterEnglish ?? '').toLowerCase();
                    final ur = (c.chapterUrdu ?? '').toLowerCase();
                    final q = _query.toLowerCase();
                    return ar.contains(q) || en.contains(q) || ur.contains(q) ||
                        (c.chapterNumber?.toString().contains(q) ?? false);
                  }).toList();

            return RefreshIndicator(
              color: primaryPurple,
              onRefresh: () async {
                context.read<GetBookChaptersCubit>().emitGetBookChapters(widget.bookSlug);
              },
              child: CustomScrollView(
                slivers: [
                  _FancySliverAppBar(
                    primaryPurple: primaryPurple,
                    title: 'Chapters',
                    subtitle: widget.bookSlug,
                    search: _search,
                  ),
                  SliverToBoxAdapter(child: const SizedBox(height: 12)),
           
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    sliver: _ResponsiveChapterList(
                      items: filtered,
                      primaryPurple: primaryPurple,
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// ---------------- UI Components ----------------

class _FancySliverAppBar extends StatelessWidget {
  const _FancySliverAppBar({
    required this.primaryPurple,
    required this.title,
    required this.subtitle,
    required this.search,
  });

  final Color primaryPurple;
  final String title;
  final String subtitle;
  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 190,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryPurple,
                primaryPurple.withOpacity(0.75),
                primaryPurple.withOpacity(0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(top: -40, right: -30, child: _CircleDecor(color: Colors.white.withOpacity(0.07), size: 160)),
              Positioned(bottom: -30, left: -40, child: _CircleDecor(color: Colors.white.withOpacity(0.06), size: 200)),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          ),
                          const Spacer(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                                    SizedBox(width: 6),
                                    Text('Chapters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(title,
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.1)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(color: Colors.white.withOpacity(0.25)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: search,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'ابحث بالعربي / English / Urdu / رقم الفصل',
                                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.85)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => search.clear(),
                                  icon: Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.9)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: Container(
          height: 18,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0E0E13) : const Color(0xFFF7F7FC),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
        ),
      ),
    );
  }
}

class _CircleDecor extends StatelessWidget {
  const _CircleDecor({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.primaryPurple, required this.total, required this.visible, required this.hadithsSum});
  final Color primaryPurple;
  final int total;
  final int visible;
  final int hadithsSum;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1B1B23);

    Widget statCard(IconData icon, String label, String value) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(isDark ? 0.06 : 0.9), Colors.white.withOpacity(isDark ? 0.03 : 0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.08)),
            boxShadow: [BoxShadow(color: primaryPurple.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: primaryPurple.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: primaryPurple, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          statCard(Icons.list_rounded, 'Total', '$total'),
          statCard(Icons.visibility_rounded, 'Visible', '$visible'),
          statCard(Icons.menu_book_outlined, 'Hadiths', '$hadithsSum'),
        ],
      ),
    );
  }
}

/// ------------------ Chapters List ------------------

class _ResponsiveChapterList extends StatelessWidget {
  const _ResponsiveChapterList({required this.items, required this.primaryPurple});
  final List<dynamic> items;
  final Color primaryPurple;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent; // بدل maxWidth
        final isGrid = width >= 720;
        final crossAxisCount = width >= 1100 ? 3 : 2;

        if (!isGrid) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChapterCard(
                  chapterNumber: items[i].chapterNumber,
                  ar: items[i].chapterArabic,
                  en: items[i].chapterEnglish,
                  hadiths: items[i].hadithsCount,
                  primaryPurple: primaryPurple,
                ),
              ),
              childCount: items.length,
            ),
          );
        }

        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _ChapterCard(
              chapterNumber: items[i].chapterNumber,
              ar: items[i].chapterArabic,
              en: items[i].chapterEnglish,
              hadiths: items[i].hadithsCount,
              primaryPurple: primaryPurple,
            ),
            childCount: items.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.6,
          ),
        );
      },
    );
  }
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({required this.chapterNumber, required this.ar, required this.en, required this.hadiths, required this.primaryPurple});
  final int? chapterNumber;
  final String? ar;
  final String? en;
  final int? hadiths;
  final Color primaryPurple;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF11111A);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(isDark ? 0.06 : 0.95), Colors.white.withOpacity(isDark ? 0.03 : 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.07)),
          boxShadow: [BoxShadow(color: primaryPurple.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 8))],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primaryPurple, primaryPurple.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: primaryPurple.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6))],
              ),
              child: Center(
                child: Text((chapterNumber ?? 0).toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ar ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, textDirection: TextDirection.rtl, style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.w800, height: 1.1)),
                  const SizedBox(height: 4),
                  Text(en ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.menu_book_outlined, size: 16, color: primaryPurple),
                      const SizedBox(width: 6),
                      Text('${hadiths ?? 0} hadiths', style: TextStyle(color: primaryPurple, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: textColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 42, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
