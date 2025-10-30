import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/snackbar/app_snackbar.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';

class ProfileWalletSection extends StatelessWidget {
  const ProfileWalletSection({
    required this.wallet,
    required this.isLoading,
    super.key,
  });

  final Wallet? wallet;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    if (isLoading && wallet == null) {
      return Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: AppColors.skeletonProfileBase,
          highlightColor: AppColors.skeletonProfileHighlight,
          duration: const Duration(milliseconds: 1000),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Bone.text(words: 3, fontSize: 10),
            const SizedBox(height: AppSpacing.sm),
            Bone.text(words: 1, fontSize: 32),
          ],
        ),
      );
    }

    if (wallet == null) {
      return Text(
        'Wallet details will appear here soon.',
        textAlign: TextAlign.center,
        style: textTheme.labelMedium?.copyWith(
          fontSize: 10,
          color: AppColors.divider,
        ),
      );
    }

    final String address = wallet!.address;
    final String balance = wallet!.balance.toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                address,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  fontSize: 10,
                  color: AppColors.divider,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            _CopyWalletButton(address: address),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          balance,
          style: textTheme.headlineLarge?.copyWith(
            fontSize: 32,
            color: AppColors.accentAmber,
          ),
        ),
      ],
    );
  }
}

class _CopyWalletButton extends StatelessWidget {
  const _CopyWalletButton({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: address));
        if (context.mounted) {
          AppSnackbar.showSuccess(
            context,
            'Wallet address copied',
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: const SizedBox(
        width: 16,
        height: 16,
        child: Icon(Icons.content_copy, size: 10, color: AppColors.divider),
      ),
    );
  }
}
