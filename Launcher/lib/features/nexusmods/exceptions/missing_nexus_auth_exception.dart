class MissingNexusAuthException implements Exception {
  MissingNexusAuthException([this.message]);

  String? message;

  @override
  String toString() {
    const result = 'MissingNexusAuthException';
    if (message is String) return '$result: $message';
    return result;
  }
}
