import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_bookmark_state.dart';

class CheckBookmarkCubit extends Cubit<CheckBookmarkState> {
  CheckBookmarkCubit() : super(CheckBookmarkInitial());
}
