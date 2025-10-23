import 'package:flutter/material.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/gradients.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/app_bottom_sheet.dart';
import 'package:trekka/core/widgets/sheet_container.dart';
import 'package:trekka/core/widgets/sheet_drag_handle.dart';
import 'package:trekka/features/auth/presentation/pages/auth_email_page.dart';
import 'package:trekka/features/auth/presentation/pages/auth_otp_page.dart';

class AuthSheet extends StatefulWidget {
  const AuthSheet({super.key});

  //TODO: Improve the animation of the sheet
  /// Show auth modal from anywhere in the app.
  static Future<void> show(BuildContext context, {bool isDismissible = true}) {
    return AppBottomSheet.show(
      context: context,
      child: const AuthSheet(),
      heightFactor: 0.8,
      isDismissible: isDismissible,
    );
  }

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet> {
  bool _showOtp = false;
  String _email = '';

  void _handleEmailContinue(String email) {
    setState(() {
      _email = email;
      _showOtp = true;
    });
    debugPrint('Email submitted: $email');
  }

  void _handleVerify() {
    debugPrint('OTP verified for: $_email');
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  void _handleResend() {
    debugPrint('Resending OTP to: $_email');
    // Handle resend OTP
  }

  Widget _buildEmailScreen() {
    return SheetContainer(
      key: const ValueKey<String>('email'),
      backgroundImage: AppAssetImages.authSheetBackground,
      gradient: AppGradients.homeAuthSheet,
      child: Column(
        children: <Widget>[
          const SizedBox(height: AppSpacing.md),
          const SheetDragHandle(),
          Expanded(
            child: AuthEmailPage(
              onContinue: _handleEmailContinue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpScreen() {
    return SheetContainer(
      key: const ValueKey<String>('otp'),
      backgroundImage: AppAssetImages.authSheetBackground,
      gradient: AppGradients.homeAuthSheet,
      child: Column(
        children: <Widget>[
           const SizedBox(height: AppSpacing.md),
          const SheetDragHandle(),
          Expanded(
            child: AuthOtpPage(
              email: _email,
              onVerify: _handleVerify,
              onResend: _handleResend,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final Offset beginOffset = child.key == const ValueKey<String>('otp')
            ? const Offset(1.0, 0.0)
            : const Offset(-1.0, 0.0);

        return SlideTransition(
          position: Tween<Offset>(
            begin: beginOffset,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
      child: _showOtp ? _buildOtpScreen() : _buildEmailScreen(),
    );
  }
}
