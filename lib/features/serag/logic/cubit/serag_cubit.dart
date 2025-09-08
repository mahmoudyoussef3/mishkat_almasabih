import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'serag_state.dart';

class SeragCubit extends Cubit<SeragState> {
  SeragCubit() : super(SeragInitial());
}
