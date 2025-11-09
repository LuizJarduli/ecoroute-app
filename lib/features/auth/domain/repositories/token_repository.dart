import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class TokenRepository {
  Future<Either<Failure, String?>> getToken();
  Future<Either<Failure, void>> saveToken(String token, int expirationTime);
  Future<Either<Failure, void>> deleteToken();
}
