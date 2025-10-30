import 'package:equatable/equatable.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';

/// Represents the authentication state of the app
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial state - checking if user is authenticated
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// User is authenticated
class Authenticated extends AuthState {
  const Authenticated({
    required this.user,
    this.wallet,
    this.isLoadingWallet = false,
    this.isUpdatingAvatar = false,
    this.isUpdatingUsername = false,
    this.isDeletingAccount = false,
    this.isLoggingOut = false,
  });

  final User user;
  final Wallet? wallet;
  final bool isLoadingWallet;
  final bool isUpdatingAvatar;
  final bool isUpdatingUsername;
  final bool isDeletingAccount;
  final bool isLoggingOut;

  Authenticated copyWith({
    User? user,
    Wallet? wallet,
    bool? isLoadingWallet,
    bool? isUpdatingAvatar,
    bool? isUpdatingUsername,
    bool? isDeletingAccount,
    bool? isLoggingOut,
  }) {
    return Authenticated(
      user: user ?? this.user,
      wallet: wallet ?? this.wallet,
      isLoadingWallet: isLoadingWallet ?? this.isLoadingWallet,
      isUpdatingAvatar: isUpdatingAvatar ?? this.isUpdatingAvatar,
      isUpdatingUsername: isUpdatingUsername ?? this.isUpdatingUsername,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        user,
        wallet,
        isLoadingWallet,
        isUpdatingAvatar,
        isUpdatingUsername,
        isDeletingAccount,
        isLoggingOut,
      ];
}

/// User is not authenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Authentication error occurred
class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
