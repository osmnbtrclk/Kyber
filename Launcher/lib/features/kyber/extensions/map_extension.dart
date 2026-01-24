import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/utils/extensions/bloc_nullable.dart';
import 'package:kyber_launcher/features/kyber/services/map_helper.dart';
import 'package:kyber_launcher/features/mods/services/level_declaration_service.dart';
import 'package:kyber_launcher/features/server_host/providers/host_collection_cubit.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/injection_container.dart';

extension KyberMapExtension on KyberMap {
  Widget getImage(BuildContext context, [ModCollectionMetaData? collection]) {
    if (isCustom) {
      var c = collection;
      if (c == null && context.readOrNull<HostCollectionCubit>() != null) {
        c = context.read<HostCollectionCubit>().state.selectedModCollection;
      }

      if (c == null) {
        return Assets.images.kyberNoImage.image(fit: BoxFit.fitWidth);
      }

      final image = sl<LevelDeclarationService>().getMapImage(
        c,
        map,
        name: name,
      );

      if (image != null && image.isNotEmpty) {
        return Image.memory(image, fit: BoxFit.fitWidth);
      }
    }

    return MapHelper.getImageForMap(map)!.image(fit: BoxFit.fitWidth);
  }
}
