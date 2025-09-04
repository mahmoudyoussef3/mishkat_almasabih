import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/search/data/models/enhanced_search_response_model.dart';
import 'package:mishkat_almasabih/features/search/data/repos/enhanced_search_repo.dart';

part 'enhanced_search_state.dart';

class EnhancedSearchCubit extends Cubit<EnhancedSearchState> {
  final EnhancedSearchRepo enhancedSearchRepo;
  EnhancedSearchCubit(this.enhancedSearchRepo) : super(EnhancedSearchInitial());


  Future<void> fetchEnhancedSearchResults(String searchTerm) async {
    emit(EnhancedSearchLoading());
    final result = await enhancedSearchRepo.fetchEnhancedSearchResults(searchTerm);
    result.fold(
      (error) => emit(EnhancedSearchError(error.apiErrorModel.msg.toString())),
      (enhancedSearch) => emit(EnhancedSearchLoaded(enhancedSearch)),
    );
  }
}
