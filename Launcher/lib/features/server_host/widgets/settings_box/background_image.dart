import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/features/kyber/providers/kyber_status_cubit.dart';
import 'package:kyber_launcher/features/kyber/services/map_helper.dart';
import 'package:kyber_launcher/features/map_rotation/providers/map_rotation_cubit.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';

class HostingBackgroundImage extends StatelessWidget {
  const HostingBackgroundImage({super.key});

  String getMapName(BuildContext context) {
    var index = 0;
    final state = context.read<KyberStatusCubit>().state;
    if (state is KyberStatusHosting) {
      index = state.serverState.mapRotationIndex;
    }

    return context.read<MapRotationCubit>().state.maps.elementAt(index).map;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapRotationCubit, MapRotationState>(
      builder: (context, state) {
        final image = state.maps.isNotEmpty
            ? MapHelper.getImageForMap(getMapName(context)) ??
                  Assets.images.kyberNoImage
            : Assets.images.kyberNoImage;
        return SizedBox(
          height: 200,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.srcATop,
            ),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 6,
                sigmaY: 6,
                tileMode: TileMode.mirror,
              ),
              child: image.image(
                height: 200,
                fit: BoxFit.fitWidth,
                key: Key(
                  state.maps.isNotEmpty ? state.maps.first.map : 'no-image',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
