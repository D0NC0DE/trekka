import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

/// Custom text field with inset shadows and specific styling.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enabled;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  bool get _hasText => widget.controller?.text.isNotEmpty ?? false;

  @override
  Widget build(BuildContext context) {
    final bool isActive = _isFocused || _hasText;

    return InnerShadow(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      shadows: AppShadows.textFieldInner,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: isActive ? 1.25 : 1.0,
            fontWeight: isActive
                ? AppFontWeights.semiBold
                : AppFontWeights.regular,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.25,
              color: AppColors.textPrimary50,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.smLg,
              vertical: AppSpacing.md,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ),
    );
  }
}
