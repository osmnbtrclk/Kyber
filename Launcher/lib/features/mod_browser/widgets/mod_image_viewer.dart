import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/mod_browser/screens/mod_details.dart';
import 'package:kyber_launcher/features/mod_browser/widgets/mod_details/mod_images.dart';
import 'package:kyber_launcher/gen/assets.gen.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/cards/kyber_container.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_tab_bar.dart';
import 'package:nexus_bridge/nexus_bridge.dart';
import 'package:nexus_gql/nexus_gql.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ModImageViewer extends StatefulWidget {
  const ModImageViewer({
    required this.onClose,
    required this.images,
    required this.data,
    super.key,
    this.initialIndex,
  });

  final int? initialIndex;
  final List<WSNexusModImage> images;
  final Query$modByUID$legacyMods$nodes data;
  final VoidCallback onClose;

  @override
  State<ModImageViewer> createState() => _ModImageViewerState();
}

class _ModImageViewerState extends State<ModImageViewer> {
  int selectedIndex = 0;

  final ListController controller = ListController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    selectedIndex = widget.initialIndex ?? 0;
    Timer.run(() {
      if (widget.initialIndex != null && widget.initialIndex != 0) {
        controller.jumpToItem(
          index: widget.initialIndex!,
          scrollController: scrollController,
          alignment: 0,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KyberCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.data.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: FontFamily.battlefrontUI,
                          height: 1,
                        ),
                      ),
                      Text(
                        'VIEW IMAGES',
                        style: TextStyle(
                          color: decoColor.lighten(20),
                          fontFamily: FontFamily.battlefrontUI,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 32,
                      child: KyberTabBar(
                        onChanged: (index) {
                          if (index == 1) {
                            return;
                          }

                          if (selectedIndex == 0 && index == 0) {
                            return;
                          }

                          if (selectedIndex == widget.images.length - 1 &&
                              index == 2) {
                            return;
                          }

                          setState(() {
                            selectedIndex = index == 0
                                ? selectedIndex - 1
                                : selectedIndex + 1;
                          });
                          controller.animateToItem(
                            index: selectedIndex,
                            scrollController: scrollController,
                            alignment: 0.5,
                            duration: (estimatedDistance) =>
                                const Duration(milliseconds: 500),
                            curve: (estimatedDistance) => Curves.easeInOut,
                          );
                        },
                        selectedIndex: -1,
                        tabs: [
                          const Icon(mt.Icons.arrow_back_ios_new_rounded),
                          Text(
                            '${selectedIndex + 1}/${widget.images.length}'
                                .toUpperCase(),
                          ),
                          const Icon(mt.Icons.arrow_forward_ios_rounded),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: KyberTabBar(
                        onChanged: (index) {
                          if (index == 0) {
                            widget.onClose();
                          }
                        },
                        selectedIndex: -1,
                        tabs: const [
                          Icon(mt.Icons.arrow_back),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const ContainerSeparator(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 53,
                  child: ModImages(
                    images: widget.images,
                    id: '',
                    onImageSelected: (index) {
                      setState(() {
                        selectedIndex = index;
                      });

                      controller.animateToItem(
                        index: selectedIndex,
                        scrollController: scrollController,
                        alignment: 0.5,
                        duration: (estimatedDistance) =>
                            const Duration(milliseconds: 500),
                        curve: (estimatedDistance) => Curves.easeInOut,
                      );
                    },
                    selectedImage: selectedIndex,
                    controller: controller,
                    scrollController: scrollController,
                  ),
                ),
                Container(
                  width: 2,
                  color: decoColor,
                ),
                Expanded(
                  flex: 200,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        top: 50,
                        bottom: 50,
                        left: 200,
                        right: 200,
                        child: InteractiveViewer(
                          trackpadScrollCausesScale: true,
                          child: CachedNetworkImage(
                            imageUrl: widget.images[selectedIndex].url
                                .replaceAll('/thumbnails/', '/'),
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => const Center(
                              child: ProgressRing(),
                            ),
                            fadeOutDuration: Duration.zero,
                            fadeInDuration: Duration.zero,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Assets.icons.kblImageDivider.svg(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
