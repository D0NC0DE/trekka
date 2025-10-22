import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:trekka/app/di/auth_providers.dart';
import 'package:trekka/core/utils/otp_helpers.dart';
import 'package:trekka/core/utils/result.dart';
import 'package:trekka/features/auth/domain/repositories/auth_repository.dart';

const Duration otpResendDuration = Duration(seconds: 120);

final authOtpViewModelProvider = StateNotifierProvider.autoDispose
    .family<AuthOtpViewModel, AuthOtpViewState, String>(
  (ref, email) => AuthOtpViewModel(
    email: email,
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

class AuthOtpViewModel extends StateNotifier<AuthOtpViewState> {
  AuthOtpViewModel({
    required String email,
    required AuthRepository authRepository,
  })  : _email = email,
        _authRepository = authRepository,
        super(const AuthOtpViewState.initial()) {
    _startResendTimer();
  }

  final String _email;
  final AuthRepository _authRepository;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    state = state.copyWith(resendCountdown: otpResendDuration.inSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown > 0) {
        state = state.copyWith(resendCountdown: state.resendCountdown - 1);
      } else {
        timer.cancel();
      }
    });
  }

  void updateOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  Future<void> pasteFromClipboard({
    required Function(String formattedOtp) onPaste,
  }) async {
    try {
      final ClipboardData? data = await Clipboard.getData('text/plain');
      if (data != null && data.text != null) {
        final String formattedOtp = OtpHelpers.formatOtpWithDashes(data.text!);

        if (formattedOtp.isNotEmpty) {
          state = state.copyWith(otp: formattedOtp);
          onPaste(formattedOtp);
        }
      }
    } catch (e) {
      // Silent fail for clipboard errors
      state = state.copyWith(errorMessage: 'Failed to paste from clipboard');
    }
  }

  Future<void> verifyOtp({
    required VoidCallback onSuccess,
  }) async {
    if (!OtpHelpers.isValidOtp(state.otp) || state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    // Clean OTP (remove dashes)
    final String cleanedOtp = OtpHelpers.cleanOtp(state.otp);

    final Result<Map<String, dynamic>> result =
        await _authRepository.verifyEmailOtp(
      email: _email,
      otp: cleanedOtp,
    );

    if (!mounted) return;

    result.when(
      success: (response) {
        // TODO: Save tokens from response
        // final String accessToken = response['accessToken'];
        // final String refreshToken = response['refreshToken'];

        state = state.copyWith(isLoading: false);
        onSuccess();
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  Future<void> resendOtp({
    required VoidCallback onSuccess,
  }) async {
    if (state.resendCountdown > 0 || state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    final Result<String> result = await _authRepository.resendEmailOtp(_email);

    if (!mounted) return;

    result.when(
      success: (message) {
        state = state.copyWith(isLoading: false);
        onSuccess();
        _startResendTimer();
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

class AuthOtpViewState {
  const AuthOtpViewState({
    required this.otp,
    required this.isLoading,
    required this.resendCountdown,
    this.errorMessage,
  });

  const AuthOtpViewState.initial()
      : otp = '',
        isLoading = false,
        resendCountdown = 120,
        errorMessage = null;

  final String otp;
  final bool isLoading;
  final int resendCountdown;
  final String? errorMessage;

  bool get canResend => resendCountdown == 0;
  bool get isValidOtp => OtpHelpers.isValidOtp(otp);

  String get formattedResendTime => OtpHelpers.formatTime(resendCountdown);

  AuthOtpViewState copyWith({
    String? otp,
    bool? isLoading,
    int? resendCountdown,
    String? errorMessage,
  }) {
    return AuthOtpViewState(
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      errorMessage: errorMessage,
    );
  }
}

