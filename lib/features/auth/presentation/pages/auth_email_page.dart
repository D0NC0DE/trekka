import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/app_button.dart';
import 'package:trekka/core/widgets/app_text_field.dart';
import 'package:trekka/features/auth/presentation/viewmodels/auth_email_view_model.dart';
import 'package:trekka/features/auth/presentation/widgets/auth_divider.dart';
import 'package:trekka/features/auth/presentation/widgets/social_login_buttons.dart';

class AuthEmailPage extends ConsumerStatefulWidget {
  const AuthEmailPage({
    super.key,
    required this.onContinue,
  });

  final ValueChanged<String> onContinue;

  @override
  ConsumerState<AuthEmailPage> createState() => _AuthEmailPageState();
}

class _AuthEmailPageState extends ConsumerState<AuthEmailPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    ref.read(authEmailViewModelProvider.notifier).updateEmail(
          _emailController.text,
        );
  }

  Future<void> _handleContinue() async {
    await ref.read(authEmailViewModelProvider.notifier).continueWithEmail(
          onSuccess: widget.onContinue,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authEmailViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 55),
          Image.asset(
            AppAssetIcons.trekkaAnimated,
            width: 170,
            height: 139,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 50),
          const SocialLoginButtons(),
          const SizedBox(height: AppSpacing.xxl),
          const AuthDivider(),
          const SizedBox(height: AppSpacing.xxl),
          AppTextField(
            controller: _emailController,
            hintText: '@gmail.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !state.isLoading,
            onSubmitted: (_) => _handleContinue(),
          ),
          const SizedBox(height: AppSpacing.mdLg),
          AppButton(
            onPressed: state.isValidEmail && !state.isLoading
                ? _handleContinue
                : null,
            label: 'Continue',
            isLoading: state.isLoading,
            loadingSize: 40,
          ),
          const SizedBox(height: AppSpacing.xxxxxl),
        ],
      ),
    );
  }
}

