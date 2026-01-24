import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:intl/intl.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/utils/transparent_image.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:nexus_gql/nexus_gql.dart';

class ModHeader extends StatelessWidget {
  const ModHeader({required this.data, super.key});

  final Query$modByUID$legacyMods$nodes? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 100,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  stops: const [0.3, 1],
                  colors: [
                    Colors.transparent.withOpacity(.2),
                    Colors.black,
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Assets.images.kyberNoImage.image(
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  stops: const [0.3, 1],
                  colors: [
                    Colors.transparent.withOpacity(.2),
                    Colors.black,
                  ],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: CachedNetworkImage(
                imageUrl: data?.pictureUrl ?? data?.thumbnailUrl ?? '',
                fit: BoxFit.cover,
                fadeInDuration: kDefaultDuration,
                errorWidget: (context, url, error) =>
                    Image.memory(kTransparentImage),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          data?.name ?? '...',
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: FontFamily.battlefrontUI,
                            height: 1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Created by ',
                                style: TextStyle(
                                  color: kGrayColor,
                                  fontFamily: FontFamily.battlefrontUI,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: data?.author ?? '...',
                                style: const TextStyle(
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontFamily.battlefrontUI,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  FluentIcons.download,
                                  color: kWhiteColor,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  NumberFormat.decimalPattern().format(
                                    data?.downloads ?? 0,
                                  ),
                                  style: const TextStyle(
                                    color: kWhiteColor,
                                    fontFamily: FontFamily.battlefrontUI,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 15),
                            Row(
                              children: [
                                const Icon(
                                  mt.Icons.thumb_up_alt,
                                  color: kWhiteColor,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  NumberFormat.decimalPattern().format(
                                    data?.endorsements ?? 0,
                                  ),
                                  style: const TextStyle(
                                    color: kWhiteColor,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
