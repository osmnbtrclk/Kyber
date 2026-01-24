abstract class DownloadPlatformIntegration {
  Future<void> updateProgress(double progress);

  Future<void> setIndeterminate();

  Future<void> clear();
}
