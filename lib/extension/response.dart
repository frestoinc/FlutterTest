class Response<T> {
  Response._();

  factory Response.success(T value) = SuccessState<T>;

  factory Response.error(T exception) = ErrorState<T>;
}

class ErrorState<T> extends Response<T> {
  ErrorState(this.exception) : super._();
  final T exception;
}

class SuccessState<T> extends Response<T> {
  SuccessState(this.value) : super._();
  final T value;
}
