import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/utils/input_formatters.dart';
import 'package:trekka/core/widgets/app_button.dart';
import 'package:trekka/core/widgets/app_text_field.dart';
import 'package:trekka/features/auth/presentation/viewmodels/auth_otp_view_model.dart';

class AuthOtpPage extends ConsumerStatefulWidget {
  const AuthOtpPage({
    super.key,
    required this.email,
    this.onVerify,
    this.onResend,
  });

  final String email;
  final VoidCallback? onVerify;
  final VoidCallback? onResend;

  @override
  ConsumerState<AuthOtpPage> createState() => _AuthOtpPageState();
}

class _AuthOtpPageState extends ConsumerState<AuthOtpPage> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _otpController.addListener(_onOtpChanged);
  }

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged() {
    ref.read(authOtpViewModelProvider.notifier).updateOtp(
          _otpController.text,
        );
  }

  Future<void> _handlePaste() async {
    await ref.read(authOtpViewModelProvider.notifier).pasteFromClipboard(
          onPaste: (formattedOtp) {
            _otpController.text = formattedOtp;
            _otpController.selection = TextSelection.fromPosition(
              TextPosition(offset: formattedOtp.length),
            );
          },
        );
  }

  Future<void> _handleVerify() async {
    await ref.read(authOtpViewModelProvider.notifier).verifyOtp(
          onSuccess: () {
            if (widget.onVerify != null) {
              widget.onVerify!();
            }
          },
        );
  }

  Future<void> _handleResend() async {
    await ref.read(authOtpViewModelProvider.notifier).resendOtp(
          onSuccess: () {
            if (widget.onResend != null) {
              widget.onResend!();
            }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authOtpViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 160),
          Text(
            'Email Verification',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.smLg),
          Text(
            'Enter the 8-digit verification code sent to',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.0,
              color: AppColors.white,
            ),
          ),
          Text(
            widget.email,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.white,
              fontWeight: AppFontWeights.semiBold,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppTextField(
            controller: _otpController,
            hintText: '8-digit verification code',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            enabled: !state.isLoading,
            inputFormatters: [OtpDashFormatter()],
            onSubmitted: (_) => _handleVerify(),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 11.0,
                horizontal: 8.0,
              ),
              child: SizedBox(
                height: 34,
                width: 55,
                child: AppButton(
                  onPressed: _handlePaste,
                  label: 'Paste',
                  height: 34,
                  width: 55,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: state.isLoading || !state.canResend
                ? null
                : _handleResend,
            child: Text(
              !state.canResend
                  ? 'Resend in ${state.formattedResendTime}'
                  : 'Resend Code',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: AppSpacing.md,
                    color: !state.canResend
                        ? AppColors.white50
                        : AppColors.white,
                    decoration: !state.canResend
                        ? TextDecoration.none
                        : TextDecoration.underline,
                    decorationColor: AppColors.white,
                  ),
            ),
          ),
          AppButton(
            onPressed: !state.isLoading && state.isValidOtp
                ? _handleVerify
                : null,
            label: 'Verify',
            isLoading: state.isLoading,
            loadingSize: 40,
          ),
          const SizedBox(height: AppSpacing.xxxxxl),
        ],
      ),
    );
  }
}
