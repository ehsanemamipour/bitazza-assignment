import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message});
  final String message;
  @override
  List<Object> get props => [message];
}

/// This is used to show the error to the user for times
///  when the 404 access or so has occurred.
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// This is used to show the error to the user for times
/// network is unreachable to send requests.
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}
