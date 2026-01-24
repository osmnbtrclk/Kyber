import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/features/maxima/providers/maxima_cubit.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/utils/hive_listener.dart';
import 'package:path/path.dart';

class KyberBackground extends StatelessWidget {
  const KyberBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HiveListener(
          box: box,
          keys: const [
            'removeBackground',
            'backgroundImage',
            'customBackground',
          ],
          builder: (_) {
            ImageProvider? imageProvider;
            if (Preferences.customization.customBackground) {
              imageProvider = FileImage(
                File(
                  join(FileHelper.getLauncherDirectory().path, 'background'),
                ),
              );
            } else if (Preferences.customization.backgroundImage != null &&
                context.read<MaximaCubit>().state.isEntitled(
                  .admin,
                )) {
              final imagePath = Preferences.customization.backgroundImage!;
              if (imagePath.startsWith('http')) {
                imageProvider = CachedNetworkImageProvider(imagePath);
              } else {
                imageProvider = AssetImage(imagePath);
              }
            } else {
              imageProvider = Assets.images.background.provider();
            }

            return Container(
              decoration: BoxDecoration(
                image: Preferences.admin.removeBackground
                    ? null
                    : DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.2),
                          BlendMode.darken,
                        ),
                      ),
                color: Preferences.admin.removeBackground ? Colors.black : null,
              ),
            );
          },
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: material.Material(
            type: .transparency,
            textStyle: FluentTheme.of(context).typography.body?.copyWith(
              fontFamily: FontFamily.battlefrontUI,
            ),
            child: NavigationPaneTheme(
              data: const NavigationPaneThemeData(
                backgroundColor: Colors.transparent,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
