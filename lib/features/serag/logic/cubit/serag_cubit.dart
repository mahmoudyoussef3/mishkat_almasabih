import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/serag/logic/cubit/serag_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mishkat_almasabih/features/serag/data/models/serag_request_model.dart';
import 'package:mishkat_almasabih/features/serag/data/repos/serag_repo.dart';

class SeragCubit extends Cubit<SeragState> {
  final SeragRepo _seragRepo;
  final List<Message> messages = [];

  SeragCubit(this._seragRepo) : super(SeragInitial()) {
    loadMessages();
  }

  Future<void> sendMessage({
    required String hadeeth,
    required String grade_ar,
    required String source,
    required String takhrij_ar,
    required String content,
  }) async {
    emit(SeragLoading());
    messages.add(Message(role: 'user', content: content));
    await saveMessages();

    final result = await _seragRepo.serag(
      SeragRequestModel(
        hadith: Hadith(
          hadeeth: hadeeth,
          grade_ar: grade_ar,
          source: source,
          takhrij_ar: takhrij_ar,
        ),
        messages: [Message(role: 'user', content: content)],
      ),
    );

    result.fold(
      (l) =>
          emit(SeragFailure(l.apiErrorModel.msg ?? "حدث خطأ. حاول مرة أخرى")),
      (r) async {
        messages.add(Message(role: 'assistant', content: r.response));
        emit(SeragSuccess(r));

        await saveMessages();
      },
    );
  }

  Future<void> clearMessages() async {
    messages.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("serag_messages");
  }

  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = messages.map((m) => m.toJson()).toList();
    await prefs.setString("serag_messages", jsonEncode(jsonList));
  }

  Future<List<Message>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("serag_messages");
    if (data != null) {
      final decoded = jsonDecode(data) as List<dynamic>;
      messages.clear();
      messages.addAll(decoded.map((e) => Message.fromJson(e)));
    }
    return messages;
  }
}
