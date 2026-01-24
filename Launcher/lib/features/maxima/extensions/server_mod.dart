import 'package:fixnum/fixnum.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_collection/kyber_collection.dart';

extension FrostyParsing on ServerMod {
  ServerMod fromFrostyMod(FrostyMod mod) {
    return ServerMod(
      name: mod.details.name,
      version: mod.details.version,
      link: mod.details.link,
      fileSize: Int64(mod.size),
    );
  }
}
