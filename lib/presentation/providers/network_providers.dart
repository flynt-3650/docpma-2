import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/country_info.dart';
import '../../core/models/post.dart';
import '../../dependency_container.dart';
import '../../domain/usecases/network_demo_usecases.dart';

final networkDemoUseCasesProvider = Provider<NetworkDemoUseCases>((ref) {
  return di.networkDemoUseCases;
});

class NetworkDemoUiState {
  final bool isLoading;
  final String? error;

  final List<Post> posts;
  final Post? lastPost;
  final CountryInfo? country;

  final String lastAction;

  const NetworkDemoUiState({
    this.isLoading = false,
    this.error,
    this.posts = const [],
    this.lastPost,
    this.country,
    this.lastAction = '—',
  });

  NetworkDemoUiState copyWith({
    bool? isLoading,
    String? error,
    List<Post>? posts,
    Post? lastPost,
    CountryInfo? country,
    String? lastAction,
    bool clearError = false,
  }) {
    return NetworkDemoUiState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      posts: posts ?? this.posts,
      lastPost: lastPost ?? this.lastPost,
      country: country ?? this.country,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

class NetworkDemoNotifier extends StateNotifier<NetworkDemoUiState> {
  NetworkDemoNotifier(this._useCases) : super(const NetworkDemoUiState());

  final NetworkDemoUseCases _useCases;

  Future<void> getPosts() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      lastAction: 'GET /posts',
    );
    try {
      final posts = await _useCases.getPosts(userId: 1);
      state = state.copyWith(isLoading: false, posts: posts);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: asNetworkException(e).message,
      );
    }
  }

  Future<void> createPost() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      lastAction: 'POST /posts',
    );
    try {
      final post = await _useCases.createPost(userId: 1);
      state = state.copyWith(isLoading: false, lastPost: post);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: asNetworkException(e).message,
      );
    }
  }

  Future<void> updatePostPut() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      lastAction: 'PUT /posts/1',
    );
    try {
      final post = await _useCases.updatePostPut(id: 1, userId: 1);
      state = state.copyWith(isLoading: false, lastPost: post);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: asNetworkException(e).message,
      );
    }
  }

  Future<void> patchPostTitle() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      lastAction: 'PATCH /posts/1',
    );
    try {
      final post = await _useCases.patchPostTitle(id: 1);
      state = state.copyWith(isLoading: false, lastPost: post);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: asNetworkException(e).message,
      );
    }
  }

  Future<void> deletePost() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      lastAction: 'DELETE /posts/1',
    );
    try {
      await _useCases.deletePost(id: 1);
      state = state.copyWith(isLoading: false, lastPost: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: asNetworkException(e).message,
      );
    }
  }

  Future<void> getCountry(String name) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      lastAction: 'GET /name/$name',
    );
    try {
      final country = await _useCases.getCountry(name);
      state = state.copyWith(isLoading: false, country: country);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: asNetworkException(e).message,
      );
    }
  }
}

final networkDemoNotifierProvider =
    StateNotifierProvider<NetworkDemoNotifier, NetworkDemoUiState>((ref) {
      return NetworkDemoNotifier(ref.watch(networkDemoUseCasesProvider));
    });
