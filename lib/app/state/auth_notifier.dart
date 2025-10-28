import 'package:flutter_riverpod/legacy.dart';
import 'package:trekka/app/state/auth_state.dart';
import 'package:trekka/core/error/failures.dart';
import 'package:trekka/core/network/api_client.dart';
import 'package:trekka/core/storage/auth_storage_service.dart';
import 'package:trekka/core/utils/result.dart';
import 'package:trekka/features/profile/data/models/user_dto.dart';
import 'package:trekka/features/profile/domain/entities/user.dart';
import 'package:trekka/features/profile/domain/repositories/users_repository.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';
import 'package:trekka/features/wallets/domain/repositories/wallets_repository.dart';

/// Notifier for managing global authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required AuthStorageService authStorage,
    required UsersRepository usersRepository,
    required WalletsRepository walletsRepository,
    required ApiClient apiClient,
  }) : _authStorage = authStorage,
       _usersRepository = usersRepository,
       _walletsRepository = walletsRepository,
       _apiClient = apiClient,
       super(const AuthInitial()) {
    _apiClient.configureAuthRefresh(
      getRefreshToken: _authStorage.getRefreshToken,
      onTokensUpdated: (String accessToken, String refreshToken) async {
        await Future.wait(<Future<void>>[
          _authStorage.saveAccessToken(accessToken),
          _authStorage.saveRefreshToken(refreshToken),
        ]);
      },
      onUnauthorized: () async {
        if (state is Unauthenticated) return;
        await signOut();
      },
    );
  }

  final AuthStorageService _authStorage;
  final UsersRepository _usersRepository;
  final WalletsRepository _walletsRepository;
  final ApiClient _apiClient;

  Future<void> initialize() async {
    try {
      final bool hasAuth = await _authStorage.hasAuthData();
      if (!hasAuth) {
        state = const Unauthenticated();
        return;
      }

      final String? accessToken = await _authStorage.getAccessToken();
      if (accessToken != null) {
        _apiClient.setAuthToken(accessToken);
      }

      final Map<String, dynamic>? userJson = await _authStorage.getUserJson();
      if (userJson != null) {
        final User cachedUser = UserDto.fromJson(userJson).toEntity();
        state = Authenticated(user: cachedUser);

        _refreshUserData();

        _loadWalletData();
      } else {
        await _fetchAndSetUserData();
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Sign in with tokens and user data from OTP verification
  Future<void> signIn({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> userJson,
  }) async {
    try {
      // Save tokens and user data to secure storage
      await _authStorage.saveAuthData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: userJson,
      );

      // Set access token in API client
      _apiClient.setAuthToken(accessToken);

      // Parse user data
      final User user = UserDto.fromJson(userJson).toEntity();

      // Update state to authenticated
      state = Authenticated(user: user, isLoadingWallet: true);

      // Lazy load wallet in background
      _loadWalletData();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Sign out - clear all auth data
  Future<void> signOut() async {
    try {
      await _authStorage.clearAuthData();
      _apiClient.clearAuthToken();
      state = const Unauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Fetch and set fresh user data from API
  Future<void> _fetchAndSetUserData() async {
    final Result<User> result = await _usersRepository.getMe();

    if (result is Success<User>) {
      final User user = result.data;
      state = Authenticated(user: user);
      _authStorage.saveUserJson(
        UserDto(
          id: user.id,
          email: user.email,
          username: user.username,
          avatar: user.avatar,
          isEmailVerified: user.isEmailVerified,
          lastLoginAt: user.lastLoginAt,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        ).toJson(),
      );
      _loadWalletData();
      return;
    }

    final Failure failure = (result as Error<User>).error;
    if (await _handleAuthRelatedFailure(failure)) {
      return;
    }

    state = const Unauthenticated();
  }

  /// Refresh user data in background (don't show loading state)
  Future<void> _refreshUserData() async {
    final Result<User> result = await _usersRepository.getMe();

    if (result is Success<User>) {
      final User user = result.data;
      if (state is Authenticated) {
        state = (state as Authenticated).copyWith(user: user);
        _authStorage.saveUserJson(
          UserDto(
            id: user.id,
            email: user.email,
            username: user.username,
            avatar: user.avatar,
            isEmailVerified: user.isEmailVerified,
            lastLoginAt: user.lastLoginAt,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
          ).toJson(),
        );
      }
      return;
    }

    final Failure failure = (result as Error<User>).error;
    await _handleAuthRelatedFailure(failure);
  }

  /// Load wallet data in background
  Future<void> _loadWalletData() async {
    if (state is! Authenticated) return;

    state = (state as Authenticated).copyWith(isLoadingWallet: true);

    final Result<Wallet> result = await _walletsRepository.getMyWallet();

    if (result is Success<Wallet>) {
      final Wallet wallet = result.data;
      if (state is Authenticated) {
        state = (state as Authenticated).copyWith(
          wallet: wallet,
          isLoadingWallet: false,
        );
      }
      return;
    }

    final Failure failure = (result as Error<Wallet>).error;
    final bool handled = await _handleAuthRelatedFailure(failure);
    if (handled || state is! Authenticated) {
      return;
    }

    state = (state as Authenticated).copyWith(isLoadingWallet: false);
  }

  /// Refresh wallet data
  Future<void> refreshWallet() async {
    await _loadWalletData();
  }

  /// Update user profile in state
  void updateUser(User user) {
    if (state is Authenticated) {
      state = (state as Authenticated).copyWith(user: user);
      // Save to cache
      _authStorage.saveUserJson(
        UserDto(
          id: user.id,
          email: user.email,
          username: user.username,
          avatar: user.avatar,
          isEmailVerified: user.isEmailVerified,
          lastLoginAt: user.lastLoginAt,
          createdAt: user.createdAt,
          updatedAt: user.updatedAt,
        ).toJson(),
      );
    }
  }

  Future<bool> _handleAuthRelatedFailure(Failure failure) async {
    if (failure is AuthFailure) {
      await signOut();
      return true;
    }

    if (failure is ServerFailure) {
      final int? statusCode = failure.statusCode;
      if (statusCode != null && _isAuthStatusCode(statusCode)) {
        await signOut();
        return true;
      }
    }

    return false;
  }

  bool _isAuthStatusCode(int statusCode) {
    return statusCode == 400 || statusCode == 401 || statusCode == 403;
  }
}
