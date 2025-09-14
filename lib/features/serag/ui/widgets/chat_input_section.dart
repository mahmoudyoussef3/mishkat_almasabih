import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/remaining_questions/logic/cubit/remaining_questions_cubit.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_cubit.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_state.dart';
import 'package:mishkat_almasabih/features/serag/logic/chat_history/chat_history_cubit.dart';
import 'package:mishkat_almasabih/features/serag/data/models/serag_request_model.dart';

class ChatInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback scrollToBottom;
  final SeragRequestModel model;

  const ChatInputSection({
    super.key,
    required this.controller,
    required this.scrollToBottom,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.primaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input field
          BlocConsumer<SeragCubit, SeragState>(
            listener: (context, state) {
              if (state is SeragSuccess) {
                context.read<ChatHistoryCubit>().addMessage(
                  Message(role: "assistant", content: state.messages.response),
                );
                scrollToBottom();
              }
              if (state is SeragFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errMessage),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(16.w),
                  ),
                );
              }
            },
            builder: (context, seragState) {
              return Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 8.h,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsManager.secondaryBackground,
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller,
                          minLines: 1,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: ColorsManager.primaryText,
                          ),
                          decoration: InputDecoration(
                            hintText: "اكتب رسالتك هنا...",
                            hintStyle: TextStyle(
                              color: ColorsManager.secondaryText,
                              fontSize: 15.sp,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                            ),
                          ),
                          onTap: scrollToBottom,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorsManager.primaryPurple,
                            ColorsManager.primaryPurple.withOpacity(0.8),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.primaryPurple.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25.r),
                          onTap:
                              seragState is SeragLoading
                                  ? null
                                  : () {
                                    context.read<RemainingQuestionsCubit>().remaining==0?
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:  Colors.red.shade300,

                                      
                                      content: Text(
              "عذراً، لقد استنفذت الحد اليومي.\nيرجى المحاولة مرة أخرى غداً.",
              style:  TextStyle(
                color: ColorsManager.secondaryBackground,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),)):
                                    _handleSendMessage(context);
                                  },
                          child: SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: Center(
                              child:
                                  seragState is SeragLoading
                                      ? SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                      : Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Divider(
            endIndent: 50.w,
            indent: 50.w,
            color: ColorsManager.mediumGray,
          ),

          // Warning
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              " سراج قد يقدم معلومات غير دقيقة، يُفضل الرجوع إلى المصادر الأصلية للتأكد.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: ColorsManager.secondaryText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSendMessage(BuildContext context) {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      HapticFeedback.lightImpact();
      context.read<ChatHistoryCubit>().addMessage(
        Message(role: "user", content: text),
      );
      context.read<SeragCubit>().sendMessage(        hadeeth: model.hadith.hadeeth,
        grade_ar: model.hadith.grade_ar,
        source: model.hadith.source,
        takhrij_ar: model.hadith.takhrij_ar,
        content: text,
      );
      controller.clear();
      scrollToBottom();
    }
  }
}
