enum ResponseEnum { LOADING, SUCCESS, ERROR }

class ResponseState<T> {
  ResponseEnum state;
  T data;
  Exception exception;

  ResponseState(ResponseEnum state, T data, Exception e) {
    this.state = state;
    this.data = data;
    this.exception = e;
  }

  static ResponseState<T> success<T>(T data) {
    return new ResponseState(ResponseEnum.SUCCESS, data, null);
  }

  static ResponseState<T> error<T>(Exception error) {
    return new ResponseState(ResponseEnum.LOADING, null, error);
  }

  static ResponseState<T> loading<T>() {
    return new ResponseState(ResponseEnum.LOADING, null, null);
  }
}
