import 'package:dartz/dartz.dart';
import 'package:eco_route_mobile_app/core/error/failures.dart';
import 'package:eco_route_mobile_app/core/usecases/usecase.dart';
import 'package:eco_route_mobile_app/features/auth/domain/entities/user.dart';
import 'package:eco_route_mobile_app/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return repository.getCurrentUser();
  }
}
