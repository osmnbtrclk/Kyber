import 'package:kyber_launcher/features/kyber/models/mode.dart';
import 'package:kyber_launcher/features/kyber/models/modes.dart';
import 'package:kyber_launcher/features/map_rotation/models/map_rotation_entry.dart';

class MapRotationInnerList {
  MapRotationInnerList(this.mode, this.maps);

  String mode;
  List<MapRotationEntry> maps;

  Mode getMode() => modes.firstWhere((x) => x.mode == mode);
}
