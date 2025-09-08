import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_cubit.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_state.dart';

class SeragChatScreen extends StatefulWidget {
  const SeragChatScreen({super.key});

  @override
  State<SeragChatScreen> createState() => _SeragChatScreenState();
}

class _SeragChatScreenState extends State<SeragChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    context.read<SeragCubit>().loadMessages().then((msgs) {
      for (int i = 0; i < msgs.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    });
  }

  void _insertMessage(int index) {
    _listKey.currentState?.insertItem(index,
        duration: const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SeragCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: ColorsManager.secondaryBackground,
          backgroundColor: ColorsManager.primaryPurple,
          title: const Text("الأحاديث"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                cubit.clearMessages();
                setState(() {}); // تصفير الليست
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<SeragCubit, SeragState>(
                listener: (context, state) {
                  if (state is SeragSuccess) {
                    final index = cubit.messages.length - 1;
                    if (index >= 0) {
                      _insertMessage(index);
                    }
                  }
                },
                builder: (context, state) {
                  final messages = cubit.messages;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text("ابدأ بكتابة سؤالك لبدء المحادثة"),
                    );
                  }

                  return AnimatedList(
                    key: _listKey,
                    padding: const EdgeInsets.all(12),
                    initialItemCount: messages.length,
                    itemBuilder: (context, index, animation) {
                      final msg = messages[index];
                      final isUser = msg.role == "user";

                      return SizeTransition(
                        sizeFactor: animation,
                        child: Align(
                          alignment: isUser
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
                              margin:
                                  const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? ColorsManager.primaryPurple
                                    : ColorsManager.secondaryBackground,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    isUser
                                        ? Icons.person
                                        : Icons.smart_toy,
                                    color: isUser
                                        ? ColorsManager.white
                                        : ColorsManager.primaryPurple,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      msg.content,
                                      style: TextStyle(
                                        color: isUser
                                            ? ColorsManager.white
                                            : ColorsManager.primaryText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "اكتب رسالتك هنا...",
                        filled: true,
                        fillColor: ColorsManager.secondaryBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: ColorsManager.primaryPurple,
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        cubit.sendMessage(
                          hadeeth: "",
                          grade_ar: "",
                          source: "",
                          takhrij_ar: "",
                          content: text,
                        );
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "⚠️ هذا مجرد AI يساعدك والمصادر قد لا تكون مؤكدة، الرجوع للمصدر الأصلي أفضل.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorsManager.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
