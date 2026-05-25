class ResponseCode {
  static String handleResponse(int statusCode) {
    switch (statusCode) {
      case 201:
        return 'Resource created.';
      case 400:
        return 'Bad Request.';
      case 401:
        return 'Unauthorized. Please check your credentials.';
      case 404:
        return 'Not Found.';
      case 500:
        return 'Server Error. Please try again later.';
      default:
        return 'Unhandled status code: ${statusCode}';
    }
  }
}
