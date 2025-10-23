import 'package:flutter_riverpod/legacy.dart';
import 'package:trekka/core/utils/validators.dart';

final authEmailViewModelProvider =
    StateNotifierProvider.autoDispose<AuthEmailViewModel, AuthEmailViewState>(
  (ref) => AuthEmailViewModel(),
);

class AuthEmailViewModel extends StateNotifier<AuthEmailViewState> {
  AuthEmailViewModel() : super(const AuthEmailViewState.initial());

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

    state = state.copyWith(isLoading: true);

    try {
      // TODO: Implement actual API call to send OTP
      await Future<void>.delayed(const Duration(seconds: 2));

      if (mounted) {
        state = state.copyWith(isLoading: false);
        onSuccess(state.email);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    }
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

