import 'package:equatable/equatable.dart';

class Result<T> extends Equatable {
  final T? value;
  final Exception? exception;

  const Result.error(Exception e)
      : value = null,
        exception = e;

  const Result.success([T? result])
      : value = result,
        exception = null;

  bool get isSuccessful => value != null && exception == null;

  bool get isError => exception != null;

  @override
  List<Object?> get props => [value, exception];
}
