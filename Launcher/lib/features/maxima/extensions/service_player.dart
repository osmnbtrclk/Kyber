import 'package:fluent_ui/fluent_ui.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/gen/rust/api/maxima.dart';

extension on ServicePlayer {
  Image avatarImage() {
    if (avatar != null && avatar!.medium.path.isNotEmpty) {
      return Image.network(avatar!.medium.path);
    }

    return Assets.images.usericonTmp.image();
  }
}
