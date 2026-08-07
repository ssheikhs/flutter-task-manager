class ApiResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String? errorMessage;

  ApiResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage,
  });
}
