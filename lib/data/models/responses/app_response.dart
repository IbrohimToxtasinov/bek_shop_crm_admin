class AppResponse {
  String errorMessage;
  int? statusCode;
  dynamic data;

  AppResponse({
    this.errorMessage = "",
    this.data,
    this.statusCode,
  });
}
