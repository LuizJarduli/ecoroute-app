import 'package:dartz/dartz.dart';
import 'package:eco_route_mobile_app/core/api/api_service.dart';
import 'package:eco_route_mobile_app/core/error/exceptions.dart';

import 'package:eco_route_mobile_app/core/error/failures.dart';
import 'package:eco_route_mobile_app/features/auth/domain/entities/user.dart';
import 'package:eco_route_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:eco_route_mobile_app/features/auth/domain/repositories/token_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  final TokenRepository tokenRepository;

  AuthRepositoryImpl({
    required this.apiService,
    required this.tokenRepository,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final authResponse = await apiService.login(email, password);
      await tokenRepository.saveToken(
          authResponse.accessToken, authResponse.expirationTime);
      final userModel = await apiService.getAuthenticatedUser(authResponse.accessToken);
      final user = User(
        id: userModel.id,
        username: userModel.username,
        name: userModel.name,
        profilePic: userModel.profilePic,
        createdAt: userModel.createdAt,
        updatedAt: userModel.updatedAt,
        deletedAt: userModel.deletedAt,
      );
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = await tokenRepository.getToken();
      if (token.isRight() && token.getOrElse(() => null) != null) {
        final userModel = await apiService.getAuthenticatedUser(token.getOrElse(() => '')!);
        final user = User(
          id: userModel.id,
          username: userModel.username,
          name: userModel.name,
          profilePic: userModel.profilePic,
          createdAt: userModel.createdAt,
          updatedAt: userModel.updatedAt,
          deletedAt: userModel.deletedAt,
        );
        return Right(user);
      }
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await tokenRepository.deleteToken();
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
