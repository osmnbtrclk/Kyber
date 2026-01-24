import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/stats/providers/stats_cubit.dart';
import 'package:kyber_launcher/shared/ui/utils/background_blur.dart';
import 'package:kyber_launcher/shared/ui/utils/button_builder.dart';

class HeroSelector extends StatelessWidget {
  const HeroSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StatsCubit>();
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        state as StatsLoaded;

        return Row(
          children: [
            Expanded(
              child: StaggeredGrid.extent(
                maxCrossAxisExtent: 35,
                children: [
                  for (final hero in state.playerStats!.heroes.where(
                    (e) => e.type.isLightSide,
                  ))
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: ButtonBuilder(
                        onClick: () {
                          cubit.selectHero(hero);
                        },
                        builder: (context, hovered) {
                          return BackgroundBlur(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                border: Border.all(
                                  width: 2,
                                  color: hovered
                                      ? kActiveColor
                                      : state.selectedObject == hero
                                      ? kInactiveColor
                                      : decoColor,
                                ),
                              ),
                              child: hero.type.portrait.image(),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: StaggeredGrid.extent(
                maxCrossAxisExtent: 35,
                children: [
                  for (final hero in state.playerStats!.heroes.where(
                    (e) => !e.type.isLightSide,
                  ))
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: ButtonBuilder(
                        onClick: () {
                          cubit.selectHero(hero);
                        },
                        builder: (context, hovered) {
                          return BackgroundBlur(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                border: Border.all(
                                  width: 2,
                                  color: hovered
                                      ? kActiveColor
                                      : state.selectedObject == hero
                                      ? kInactiveColor
                                      : decoColor,
                                ),
                              ),
                              child: hero.type.portrait.image(),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
