import 'package:flutter_riverpod/legacy.dart';
import 'package:trekka/app/di/auth_providers.dart';
import 'package:trekka/core/utils/result.dart';
import 'package:trekka/core/utils/validators.dart';
import 'package:trekka/features/auth/domain/repositories/auth_repository.dart';

final authEmailViewModelProvider =
    StateNotifierProvider.autoDispose<AuthEmailViewModel, AuthEmailViewState>(
  (ref) => AuthEmailViewModel(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

class AuthEmailViewModel extends StateNotifier<AuthEmailViewState> {
  AuthEmailViewModel({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthEmailViewState.initial());

  final AuthRepository _authRepository;

  void updateEmail(String email) {
    final bool isValid = Validators.isValidEmail(email);
    state = state.copyWith(
      email: email,
      isValidEmail: isValid,
    );
  }

  Future<void> continueWithEmail({
    required Function(String email) onSuccess,
  }) async {
    if (!state.isValidEmail || state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final Result<String> result =
        await _authRepository.requestEmailOtp(state.email);

    if (!mounted) return;

    result.when(
      success: (String message) {
        state = state.copyWith(isLoading: false);
        onSuccess(state.email);
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

class AuthEmailViewState {
  const AuthEmailViewState({
    required this.email,
    required this.isValidEmail,
    required this.isLoading,
    this.errorMessage,
  });

  const AuthEmailViewState.initial()
      : email = '',
        isValidEmail = false,
        isLoading = false,
        errorMessage = null;

  final String email;
  final bool isValidEmail;
  final bool isLoading;
  final String? errorMessage;

  AuthEmailViewState copyWith({
    String? email,
    bool? isValidEmail,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthEmailViewState(
      email: email ?? this.email,
      isValidEmail: isValidEmail ?? this.isValidEmail,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

