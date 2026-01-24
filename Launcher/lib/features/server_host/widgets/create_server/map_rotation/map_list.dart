import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/kyber/extensions/map_extension.dart';
import 'package:kyber_launcher/features/kyber/models/mode.dart';
import 'package:kyber_launcher/features/kyber/services/map_helper.dart';
import 'package:kyber_launcher/features/map_rotation/providers/map_rotation_cubit.dart';
import 'package:kyber_launcher/features/map_rotation/models/map_rotation_entry.dart';
import 'package:kyber_launcher/features/mods/services/level_declaration_service.dart';
import 'package:kyber_launcher/features/server_browser/widgets/server_list/server_list_header.dart';
import 'package:kyber_launcher/features/server_host/providers/host_collection_cubit.dart';
import 'package:kyber_launcher/features/server_host/providers/host_search_cubit.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/shared/ui/buttons/custom_icon_button.dart';
import 'package:kyber_launcher/shared/ui/cards/kyber_container.dart';
import 'package:kyber_launcher/shared/ui/elements/header/kyber_header.dart';

class MapList extends StatefulWidget {
  const MapList({
    required this.selectedMode,
    required this.onBack,
    this.onAdd,
    super.key,
  });

  final Mode? selectedMode;
  final VoidCallback onBack;
  final void Function(MapRotationEntry entry)? onAdd;

  @override
  State<MapList> createState() => _MapListState();
}

class _MapListState extends State<MapList> {
  late List<KyberMap> maps;

  @override
  void initState() {
    maps = getMaps();
    super.initState();
  }

  void filterMaps(String query) {
    setState(() {
      maps = getMaps().where((map) {
        return map.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  List<KyberMap> getMaps() {
    final maps = MapHelper.getMapsForMode(widget.selectedMode!.mode);
    final collection = context
        .read<HostCollectionCubit>()
        .state
        .selectedModCollection;
    final customMaps = sl.get<LevelDeclarationService>().getMapsForMode(
      mode: widget.selectedMode!.mode,
      collection: collection,
    );

    return <KyberMap>[...maps, ...customMaps];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: DefaultTextStyle(
            style: const TextStyle(
              fontFamily: FontFamily.battlefrontUI,
              color: decoColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      CustomIconButton(
                        onPressed: widget.onBack,
                        iconData: mt.Icons.keyboard_backspace_sharp,
                        text: 'BACK',
                      ),
                    ],
                  ),
                ),
                if (widget.onAdd == null) ...[
                  CustomPaint(
                    size: const Size(2, 30),
                    painter: DashedLineVerticalPainter(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: HeaderButton(
                      title: 'ADD ALL',
                      onClick: () =>
                          context.read<MapRotationCubit>().addGameMode(
                            widget.selectedMode!,
                            context
                                .read<HostCollectionCubit>()
                                .state
                                .selectedModCollection,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const CardSection(),
        Expanded(
          child: BlocListener<HostSearchCubit, HostSearchState>(
            listener: (context, state) {
              filterMaps(state.searchQuery);
            },
            child: ListView.separated(
              itemBuilder: (context, index) => Container(
                color: Colors.black,
                height: 43,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.black.withOpacity(.5),
                              Colors.transparent,
                            ],
                          ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height),
                          );
                        },
                        blendMode: BlendMode.dstIn,
                        child: maps[index].getImage(context),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Transform.rotate(
                            angle: 3.14,
                            child: CustomIconButton(
                              onPressed: () {
                                if (widget.onAdd != null) {
                                  widget.onAdd!(
                                    MapRotationEntry(
                                      map: maps[index].map,
                                      mode: widget.selectedMode!.mode,
                                    ),
                                  );
                                } else {
                                  context.read<MapRotationCubit>().addMap(
                                    MapRotationEntry(
                                      map: maps[index].map,
                                      mode:
                                          maps[index].mode ??
                                          widget.selectedMode!.mode,
                                      isCustom: maps[index].isCustom,
                                    ),
                                  );
                                }
                              },
                              size: 20,
                              iconData: widget.onAdd != null
                                  ? FluentIcons.add
                                  : FluentIcons.export,
                            ),
                          ),
                        ),
                        Container(
                          color: decoColor,
                          width: 2,
                          height: 300,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                            ),
                            child: Text(
                              maps[index].name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: FontFamily.battlefrontUI,
                                fontWeight: FontWeight.bold,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => const CardSection(),
              itemCount: maps.length,
            ),
          ),
        ),
      ],
    );
  }
}
