class TMUrls {
  static String baseURL = 'https://task-manager-api.ostad.live/api/v1';

  static String SignupURL = '$baseURL/Registration';
  static String LoginURL = '$baseURL/Login';
  static String createTask = '$baseURL/createTask';
  static String taskCount = '$baseURL/taskStatusCount';

  static String AllTask(String status) => '$baseURL/listTaskByStatus/$status';
  static String deleteTask(String taskId) => '$baseURL/deleteTask/$taskId';
  static String updateTask(String taskId, String status) =>
      '$baseURL/updateTaskStatus/$taskId/$status';

  // Not directly visible in the source screenshots; follows the same
  // '$baseURL/...' pattern as the confirmed entries above.
  static String updateProfile = '$baseURL/ProfileUpdate';
  static String recoverVerifyEmail(String email) =>
      '$baseURL/RecoverVerifyEmail/$email';
  static String recoverVerifyOtp(String email, String otp) =>
      '$baseURL/RecoverVerifyOtp/$email/$otp';
  static String recoverResetPassword = '$baseURL/RecoverResetPassword';
}
