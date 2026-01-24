import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/features/stats/models/stats_object.dart';
import 'package:kyber_launcher/features/stats/providers/stats_cubit.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_tab_bar.dart';

class VehicleSelector extends StatelessWidget {
  const VehicleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StatsCubit>();
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        state as StatsLoaded;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 360,
              height: 200,
              child: KyberTabBar(
                tabs: [
                  for (final hero in state.playerStats!.vehicles.take(3))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          hero.type.icon.svg(),
                          AutoSizeText(
                            hero.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontFamily.battlefrontUI,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (index) => cubit.selectHero(
                  state.playerStats!.vehicles.elementAt(index),
                ),
                selectedIndex: state.playerStats!.vehicles.indexOf(
                  state.selectedObject as VehicleCharacter,
                ),
              ),
            ),
            SizedBox(
              width: 360,
              height: 200,
              child: KyberTabBar(
                tabs: [
                  for (final hero
                      in state.playerStats!.vehicles.skip(3).take(3))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 30,
                      ),
                      child: Column(
                        children: [
                          hero.type.icon.svg(),
                          Text(
                            hero.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontFamily.battlefrontUI,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: (index) => cubit.selectHero(
                  state.playerStats!.vehicles.elementAt(index + 3),
                ),
                selectedIndex: state.playerStats!.vehicles
                    .skip(3)
                    .take(3)
                    .toList()
                    .indexOf(state.selectedObject as VehicleCharacter),
              ),
            ),
          ],
        );
      },
    );
  }
}
