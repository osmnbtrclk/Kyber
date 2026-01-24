import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/features/stats/models/stats_object.dart';
import 'package:kyber_launcher/features/stats/providers/stats_cubit.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/elements/kyber_tab_bar.dart';

class ClassSelector extends StatelessWidget {
  const ClassSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StatsCubit>();
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        state as StatsLoaded;

        return Row(
          children: [
            SizedBox(
              width: 450,
              height: 200,
              child: KyberTabBar(
                tabs: [
                  for (final hero in state.playerStats!.classes.take(4))
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
                  state.playerStats!.classes.elementAt(index),
                ),
                selectedIndex: state.playerStats!.classes.indexOf(
                  state.selectedObject as ClassCharacter,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 342,
              height: 200,
              child: KyberTabBar(
                tabs: [
                  for (final hero in state.playerStats!.classes.skip(4).take(3))
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
                  state.playerStats!.classes.elementAt(index + 4),
                ),
                selectedIndex: state.playerStats!.classes
                    .skip(4)
                    .take(3)
                    .toList()
                    .indexOf(state.selectedObject as ClassCharacter),
              ),
            ),
          ],
        );
      },
    );
  }
}
