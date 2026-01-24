class ExtractionResult {
  const ExtractionResult({
    required this.success,
    required this.extractedFiles,
    this.error,
    this.isFrostyCollection = false,
    this.pluginsInstalled = 0,
  });

  final bool success;
  final List<String> extractedFiles;
  final String? error;
  final bool isFrostyCollection;
  final int pluginsInstalled;
}
