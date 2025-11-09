import 'package:dartz/dartz.dart';
import 'package:eco_route_mobile_app/core/error/failures.dart';
import 'package:eco_route_mobile_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
}
