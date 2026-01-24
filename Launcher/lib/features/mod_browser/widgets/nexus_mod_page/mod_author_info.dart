import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/features/mod_browser/screens/mod_details.dart';
import 'package:kyber_launcher/features/mod_browser/widgets/mod_details/mod_images.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';
import 'package:nexus_bridge/nexus_bridge.dart';
import 'package:nexus_gql/nexus_gql.dart';

class ModAuthorInfo extends StatelessWidget {
  const ModAuthorInfo({
    required this.images,
    required this.data,
    required this.onImageSelected,
    super.key,
  });

  final Query$modByUID$legacyMods$nodes? data;
  final void Function(int) onImageSelected;
  final List<WSNexusModImage> images;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: decoColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: data?.uploader.avatar ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: ProgressRing(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: ProgressRing(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.uploader.name ?? '...',
                          style: const TextStyle(
                            fontFamily: FontFamily.battlefrontUI,
                            fontSize: 19,
                            color: kWhiteColor,
                          ),
                        ),
                        if (data != null && data!.uploader.recognizedAuthor)
                          Row(
                            children: [
                              Icon(
                                mt.Icons.verified_user,
                                color: kActiveColor,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Verified Mod Author'.toUpperCase(),
                                style: const TextStyle(
                                  color: kGrayColor,
                                  fontFamily: FontFamily.battlefrontUI,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ).copyWith(bottom: 6),
                child: ButtonBuilder(
                  onClick: () => router.push(
                    '/mods/mod_browser/users/${data?.uploader.memberId}',
                  ),
                  builder: (context, hovered) {
                    return AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 150),
                      style: TextStyle(
                        color: hovered ? kActiveColor : kWhiteColor,
                        fontFamily: FontFamily.battlefrontUI,
                        fontSize: 15,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'VIEW PROFILE'.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: FontFamily.battlefrontUI,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            mt.Icons.circle_outlined,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const ContainerSeparator(),
        if (data != null)
          Expanded(
            child: Builder(
              builder: (context) {
                if (data == null) {
                  return const Center(
                    child: ProgressRing(),
                  );
                }

                return ModImages(
                  id: data!.modId.toString(),
                  onImageSelected: onImageSelected,
                  images: images,
                );
              },
            ),
          ),
      ],
    );
  }
}
