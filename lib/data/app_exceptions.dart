class AppExceptions implements Exception {

  final _message;
  final _preix;

  AppExceptions([this._message, this._preix]);

  @override
  String toString(){
    return '$_preix$_message';
  }

}

class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message, 'No Internet Connection');
}

class RequestTimeout extends AppExceptions {
  RequestTimeout([String? message]) : super(message, 'Request Timeout');
}

class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, 'Internal Server Error');
}

class InvalidUrl extends AppExceptions {
  InvalidUrl([String? message]) : super(message, 'Invalid Please check your API url');
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message]) : super(message, 'Error while communication');
}