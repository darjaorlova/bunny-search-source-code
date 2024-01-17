import 'package:domain/result/result.dart';
import 'package:equatable/equatable.dart';

class DelayedResult<T> extends Equatable {
  final Result<T>? result;
  final bool isInProgress;

  DelayedResult.error(Exception e)
      : result = Result.error(e),
        isInProgress = false;

  DelayedResult.success([T? result])
      : result = Result.success(result),
        isInProgress = false;

  const DelayedResult.inProgress()
      : result = null,
        isInProgress = true;

  bool get isSuccessful => result != null && result?.isSuccessful == true;

  bool get isError => result != null && result?.isError == true;

  T? get value => result?.value;

  DelayedResult<R> map<R>(R Function(T val) f) {
    if (isSuccessful) {
      return DelayedResult<R>.success(f(result!.value as T));
    } else if (isError) {
      return DelayedResult<R>.error(result!.exception!);
    }

    return DelayedResult<R>.inProgress();
  }

  @override
  List<Object?> get props => [result, isInProgress];
}
