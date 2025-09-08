import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/remaining_questions/logic/cubit/remaining_questions_cubit.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_cubit.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_state.dart';
import 'package:mishkat_almasabih/features/serag/logic/chat_history/chat_history_cubit.dart';
import 'package:mishkat_almasabih/features/serag/logic/chat_history/chat_history_state.dart';
import 'package:mishkat_almasabih/features/serag/data/models/serag_request_model.dart';

class SeragChatScreen extends StatefulWidget {
  const SeragChatScreen({super.key, required this.model});
  final SeragRequestModel model;

  @override
  State<SeragChatScreen> createState() => _SeragChatScreenState();
}

class _SeragChatScreenState extends State<SeragChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final seragCubit = context.read<SeragCubit>();
    final historyCubit = context.read<ChatHistoryCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            BuildHeaderAppBar(
              title: "سراج",
              description: "مساعد الحديث",
            ),
        
            SliverToBoxAdapter(
              child: BlocBuilder<
                RemainingQuestionsCubit,
                RemainingQuestionsState
              >(
                builder: (context, state) {
                  if (state is RemainingQuestionsSuccess) {
                    return Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      color: ColorsManager.secondaryBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'لديك ${state.remainigQuestionsResponse.remaining} محاولات متبقية اليوم',
                          style: TextStyle(
                            color: ColorsManager.primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else if (state is RemainingQuestionsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is RemainingQuestionsFailure) {
                    return const Text('غير متاح');
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
        
            /// Chat Messages
            BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
              builder: (context, historyState) {
                if (historyState is ChatHistoryLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
        
                if (historyState is ChatHistorySuccess &&
                    historyState.messages.isNotEmpty) {
                  final messages = historyState.messages;
        
                  return SliverList(
                  
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final msg = messages[index];
                      final isUser = msg.role == "user";
        
                      return Align(
                        alignment:
                            isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(
                              ClipboardData(text: msg.content),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تم نسخ الرسالة")),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(maxWidth: 280.w),
                            decoration: BoxDecoration(
                              color:
                                  isUser
                                      ? ColorsManager.primaryPurple
                                      : ColorsManager.secondaryBackground,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft:
                                    isUser
                                        ? const Radius.circular(16)
                                        : Radius.zero,
                                bottomRight:
                                    isUser
                                        ? Radius.zero
                                        : const Radius.circular(16),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              msg.content,
                              style: TextStyle(
                                color:
                                    isUser
                                        ? ColorsManager.white
                                        : ColorsManager.primaryText,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    }, childCount: messages.length),
                  );
                }
        
                return const SliverFillRemaining(
                  child: Center(
                    child: Text("ابدأ بكتابة سؤالك لبدء المحادثة"),
                  ),
                );
              },
            ),
        
            /// Input Field
            SliverToBoxAdapter(
              child: BlocConsumer<SeragCubit, SeragState>(
                listener: (context, state) {
                  if (state is SeragSuccess) {
                    historyCubit.addMessage(
                      Message(
                        role: "assistant",
                        content: state.messages.response,
                      ),
                    );
                    _scrollToBottom();
                  }
                  if (state is SeragFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.errMessage)));
                  }
                },
                builder: (context, seragState) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      color: ColorsManager.primaryBackground,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "اكتب رسالتك هنا...",
                                filled: true,
                                fillColor: ColorsManager.secondaryBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                              onTap: _scrollToBottom,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: ColorsManager.primaryPurple,
                            radius: 24,
                            child:
                                seragState is SeragLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        final text = _controller.text.trim();
                                        if (text.isNotEmpty) {
                                          historyCubit.addMessage(
                                            Message(
                                              role: "user",
                                              content: text,
                                            ),
                                          );
                                          seragCubit.sendMessage(
                                            hadeeth:
                                                widget.model.hadith.hadeeth,
                                            grade_ar:
                                                widget.model.hadith.grade_ar,
                                            source:
                                                widget.model.hadith.source,
                                            takhrij_ar:
                                                widget
                                                    .model
                                                    .hadith
                                                    .takhrij_ar,
                                            content: text,
                                          );
                                          _controller.clear();
                                          _scrollToBottom();
                                        }
                                      },
                                    ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        
            /// Warning
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "⚠️ سراج قد يقدم معلومات غير دقيقة، يُفضل الرجوع إلى المصادر الأصلية للتأكد.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ColorsManager.secondaryText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
