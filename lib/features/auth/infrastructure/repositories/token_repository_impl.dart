import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final FlutterSecureStorage secureStorage;

  TokenRepositoryImpl({required this.secureStorage});

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      return Right(token);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveToken(String token, int expirationTime) async {
    try {
      await secureStorage.write(key: 'auth_token', value: token);
      await secureStorage.write(
          key: 'token_expiration', value: expirationTime.toString());
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteToken() async {
    try {
      await secureStorage.delete(key: 'auth_token');
      await secureStorage.delete(key: 'token_expiration');
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
