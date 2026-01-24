import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:kyber_collection/kyber_collection.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/mod_collections/providers/mod_collection_cubit.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/utils/background_blur.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';
import 'package:kyber_launcher/shared/ui/utils/hive_listener.dart';

class CollectionList extends StatefulWidget {
  const CollectionList({
    required this.onCollectionSelected,
    super.key,
    this.selectedCollection,
  });

  final Function(int index)? onCollectionSelected;
  final int? selectedCollection;

  @override
  State<CollectionList> createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: HiveListener<ModCollectionMetaData>(
        box: collectionBox,
        builder: (Box bx) {
          bx as Box<ModCollectionMetaData>;

          return BlocBuilder<ModCollectionCubit, ModCollectionState>(
            builder: (context, state) => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 46,
              ),
              itemCount: bx.length,
              itemBuilder: (context, index) {
                final item = bx.getAt(index)!;
                return ButtonBuilder(
                  builder: (context, hovered) {
                    return BackgroundBlur(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: hovered
                                ? kActiveColor
                                : (widget.selectedCollection ??
                                          state.selectedIndex) ==
                                      index
                                ? kWhiteColor
                                : decoColor,
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontFamily: FontFamily.battlefrontUI,
                                  fontSize: 19,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  onClick: () => widget.onCollectionSelected != null
                      ? widget.onCollectionSelected!(index)
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
