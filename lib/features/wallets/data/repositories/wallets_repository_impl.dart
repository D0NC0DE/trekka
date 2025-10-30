import 'package:trekka/core/error/exceptions.dart';
import 'package:trekka/core/error/failures.dart';
import 'package:trekka/core/utils/result.dart';
import 'package:trekka/features/wallets/data/datasources/wallets_remote_datasource.dart';
import 'package:trekka/features/wallets/data/models/wallet_dto.dart';
import 'package:trekka/features/wallets/domain/entities/wallet.dart';
import 'package:trekka/features/wallets/domain/repositories/wallets_repository.dart';

/// Implementation of [WalletsRepository]
class WalletsRepositoryImpl implements WalletsRepository {
  const WalletsRepositoryImpl({
    required WalletsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final WalletsRemoteDataSource _remoteDataSource;

  @override
  Future<Result<Wallet>> getMyWallet() async {
    try {
      final WalletDto dto = await _remoteDataSource.getMyWallet();
      return Success<Wallet>(dto.toEntity());
    } on ServerException catch (e) {
      return Error<Wallet>(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Error<Wallet>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<Wallet>(TimeoutFailure(message: e.message));
    } catch (e) {
      return Error<Wallet>(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<double>> getBalance() async {
    try {
      final double balance = await _remoteDataSource.getBalance();
      return Success<double>(balance);
    } on ServerException catch (e) {
      return Error<double>(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Error<double>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<double>(TimeoutFailure(message: e.message));
    } catch (e) {
      return Error<double>(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> getAddress() async {
    try {
      final String address = await _remoteDataSource.getAddress();
      return Success<String>(address);
    } on ServerException catch (e) {
      return Error<String>(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Error<String>(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Error<String>(TimeoutFailure(message: e.message));
    } catch (e) {
      return Error<String>(UnexpectedFailure(message: e.toString()));
    }
  }
}
