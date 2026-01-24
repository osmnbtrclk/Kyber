class DownloadTypeHelper {
  static DownloadType getDownloadType(String url) {
    if (url.contains('nexus-cdn')) {
      return DownloadType.nexus;
    } else if (url.contains('.kyber.gg')) {
      return DownloadType.kyber;
    } else {
      return DownloadType.online;
    }
  }
}

enum DownloadType {
  kyber,
  nexus,
  online,
}
