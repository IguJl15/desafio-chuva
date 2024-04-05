class AppError implements Exception {
  final String message;
  final Exception? originalException;

  AppError({required this.message, this.originalException});
}
