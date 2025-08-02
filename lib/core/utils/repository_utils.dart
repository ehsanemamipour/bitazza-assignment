import 'package:bitazza_assignment/core/errors/errors.dart';
import 'package:bitazza_assignment/core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';

Future<Either<Failure, Type>> requestToServer<Type>(
  bool networkInfo,
  Future<Type> Function() requestFunction, {
  Function(Type result)? extraOperation,
}) async {
  if (networkInfo) {
    try {
      final result = await requestFunction();
      extraOperation != null ? extraOperation(result) : () {}();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  } else {
    return const Left(NetworkFailure(message: 'You have network issues'));
  }
}
