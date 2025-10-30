import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:trekka/app/di/auth_state_providers.dart';
import 'package:trekka/app/state/auth_state.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/profile/presentation/widgets/states/profile_authenticated_content.dart';
import 'package:trekka/features/profile/presentation/widgets/states/profile_loading_content.dart';
import 'package:trekka/features/profile/presentation/widgets/states/profile_unauthenticated_content.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';

/// Displays profile details inside the center modal.
class ProfileOverviewModal extends ConsumerStatefulWidget {
  const ProfileOverviewModal({super.key});

  @override
  ConsumerState<ProfileOverviewModal> createState() => _ProfileOverviewModalState();
}

class _ProfileOverviewModalState extends ConsumerState<ProfileOverviewModal> {
  @override
  void initState() {
    super.initState();
    // Lazy load fresh profile data in background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authStateProvider.notifier).refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    return switch (authState) {
      Authenticated(
        :final User user,
        :final Wallet? wallet,
        :final bool isLoadingWallet,
        :final bool isUpdatingAvatar,
        :final bool isUpdatingUsername,
        :final bool isDeletingAccount,
        :final bool isLoggingOut,
      ) =>
        ProfileAuthenticatedContent(
          user: user,
          wallet: wallet,
          isWalletLoading: isLoadingWallet,
          isUpdatingAvatar: isUpdatingAvatar,
          isUpdatingUsername: isUpdatingUsername,
          isDeletingAccount: isDeletingAccount,
          isLoggingOut: isLoggingOut,
          onLogout: () => authNotifier.signOut(),
          onAvatarChanged: (int avatarId) => authNotifier.updateAvatar(avatarId),
          onUsernameChanged: (String username) => authNotifier.updateUsername(username),
          onDeleteAccount: () => authNotifier.deleteAccount(),
        ),
      AuthError(:final String message) => ProfileUnauthenticatedContent(
        errorMessage: message,
      ),
      AuthInitial() => const ProfileLoadingContent(),
      _ => const ProfileUnauthenticatedContent(),
    };
  }
}
