import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/cache/cache_manager.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_all_books_with_categories_cubit.dart';

/// Example widget showing how to use the caching system
class CacheExampleWidget extends StatelessWidget {
  const CacheExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cache Example'),
        actions: [
          // Refresh button to force refresh data
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Force refresh the books data
              context
                  .read<GetAllBooksWithCategoriesCubit>()
                  .emitGetAllBooksWithCategories(forceRefresh: true);
            },
          ),
          // Cache management menu
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'clear_all':
                  await CacheManager.clearAllCache();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All cache cleared')),
                  );
                  break;
                case 'clear_books':
                  await CacheManager.clearBooksCache();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Books cache cleared')),
                  );
                  break;
                case 'cache_stats':
                  final stats = await CacheManager.getCacheStats();
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Cache Statistics'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Items: ${stats['totalItems']}'),
                              Text('Valid Items: ${stats['validItems']}'),
                              Text('Expired Items: ${stats['expiredItems']}'),
                              Text('Hit Rate: ${stats['cacheHitRate']}%'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  );
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'clear_all',
                    child: Text('Clear All Cache'),
                  ),
                  const PopupMenuItem(
                    value: 'clear_books',
                    child: Text('Clear Books Cache'),
                  ),
                  const PopupMenuItem(
                    value: 'cache_stats',
                    child: Text('Cache Statistics'),
                  ),
                ],
          ),
        ],
      ),
      body: BlocBuilder<
        GetAllBooksWithCategoriesCubit,
        GetAllBooksWithCategoriesState
      >(
        builder: (context, state) {
          if (state is GetAllBooksWithCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetAllBooksWithCategoriesSuccess) {
            return ListView.builder(
              itemCount: state.booksResponse.allBooks.length,
              itemBuilder: (context, index) {
                final book = state.booksResponse.allBooks[index];
                return ListTile(
                  title: Text(book.bookName),
                  subtitle: Text(book.writerName),
                  trailing: Text('${book.hadithsCount} hadiths'),
                );
              },
            );
          } else if (state is GetAllBooksWithCategoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage}'),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GetAllBooksWithCategoriesCubit>()
                          .emitGetAllBooksWithCategories();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Initial state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Load books data with caching
          context
              .read<GetAllBooksWithCategoriesCubit>()
              .emitGetAllBooksWithCategories();
        },
        child: const Icon(Icons.library_books),
      ),
    );
  }
}

/// Example of how to implement caching in a custom cubit
class ExampleCubit extends Cubit<ExampleState> with CacheMixin {
  ExampleCubit() : super(ExampleInitial());

  Future<void> loadData({bool forceRefresh = false}) async {
    const cacheKey = 'example_data';

    await loadWithCacheAndRefresh<Map<String, dynamic>>(
      cacheKey: cacheKey,
      apiCall: () async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        return {
          'data': 'example',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
      },
      fromJson: (json) => json,
      toJson: (data) => data,
      onSuccess: (data) => emit(ExampleSuccess(data)),
      onError: (error) => emit(ExampleError(error)),
      loadingState: () => ExampleLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 30, // 30 minutes cache
    );
  }
}

// Example states
abstract class ExampleState {}

class ExampleInitial extends ExampleState {}

class ExampleLoading extends ExampleState {}

class ExampleSuccess extends ExampleState {
  final Map<String, dynamic> data;
  ExampleSuccess(this.data);
}

class ExampleError extends ExampleState {
  final String error;
  ExampleError(this.error);
}
