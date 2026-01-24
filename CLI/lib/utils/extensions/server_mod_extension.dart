import 'package:fixnum/fixnum.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_collection/kyber_collection.dart';

extension ServerModExtension on FrostyMod {
  ServerMod toServerMod() {
    return ServerMod(
      name: details.name,
      version: details.version,
      link: details.link,
      fileSize: Int64(size),
    );
  }
}
