import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/serag/data/models/serag_request_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final Message message;

  const ChatMessageBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == "user";

    return Padding(
      padding: EdgeInsets.only(
        bottom: 12.h,
        left: 8.w,
        right: 8.w,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isUser) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 16.r,
              backgroundColor: ColorsManager.primaryPurple,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ],
          SizedBox(width: 8.w),
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("تم نسخ الرسالة"),
                    backgroundColor: ColorsManager.primaryPurple,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(16.w),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? LinearGradient(
                          colors: [
                            ColorsManager.primaryPurple,
                            ColorsManager.primaryPurple.withOpacity(0.8),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        )
                      : null,
                  color: isUser ? null : ColorsManager.secondaryBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft:
                        isUser ? Radius.circular(20.r) : Radius.circular(4.r),
                    bottomRight:
                        isUser ? Radius.circular(4.r) : Radius.circular(20.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isUser
                          ? ColorsManager.primaryPurple.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: isUser ? Colors.white : ColorsManager.primaryText,
                    fontSize: 15.sp,
                    height: 1.4,
                    fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w,),
          if (!isUser) ...[
            CircleAvatar(
              radius: 16.r,
              backgroundImage: const AssetImage('assets/images/serag_logo.jpg'),
            ),
          ],
        ],
      ),
    );
  }
}