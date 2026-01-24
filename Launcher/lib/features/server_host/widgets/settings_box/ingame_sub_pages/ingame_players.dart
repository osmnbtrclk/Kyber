import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kyber_launcher/features/server_host/widgets/settings_box/server_settings_box.dart';
import 'package:kyber_launcher/features/server_moderation/providers/moderation_cubit.dart';
import 'package:kyber_launcher/shared/ui/ui.dart';

class IngamePlayers extends StatelessWidget {
  const IngamePlayers({super.key});

  @override
  Widget build(BuildContext context) {
    return KyberTable(
      itemStyle: const TextStyle(fontSize: 17),
      items: [
        KyberTableItem.custom(
          title: 'Friendly Fire',
          onClick: () {
            final value =
                !(hostingForm.currentState!.fields['friendlyFire']!.value
                    as bool);
            hostingForm.currentState?.fields['friendlyFire']?.didChange(value);
            context.read<ModerationCubit>().sendCommand(
              '/SyncedGame.EnableFriendlyFire ${value ? '1' : '0'}',
            );
          },
          builder: (hovered) {
            return FormBuilderField<bool>(
              initialValue: false,
              builder: (field) {
                return KyberTableSwitch(
                  onChanged: (value) {},
                  value: field.value,
                  hover: hovered,
                );
              },
              name: 'friendlyFire',
            );
          },
        ),
        KyberTableItem.custom(
          title: 'Disable Regeneration',
          onClick: () {
            final value =
                !(hostingForm.currentState!.fields['disableRegeneration']!.value
                    as bool);
            hostingForm.currentState?.fields['disableRegeneration']?.didChange(
              value,
            );
            context.read<ModerationCubit>().sendCommand(
              '/SyncedGame.DisableRegenerateHealth ${value ? '1' : '0'}',
            );
          },
          builder: (hovered) {
            return FormBuilderField<bool>(
              initialValue: false,
              builder: (field) {
                return KyberTableSwitch(
                  onChanged: (value) {},
                  value: field.value,
                  hover: hovered,
                );
              },
              name: 'disableRegeneration',
            );
          },
        ),
        /*KyberTableItem.button(
          title: 'Swap Players',
          text: 'Swap',
          onClick: () {
            final players = context.read<ModerationCubit>().state.players;
            final team1 = players.where((player) => player.teamId == 1).toList();
            final team2 = players.where((player) => player.teamId == 2).toList();

            for (final player in team1) {
              context.read<ModerationCubit>().sendCommand('/Kyber.SetTeamById ${player.id} 2');
            }

            for (final player in team2) {
              context.read<ModerationCubit>().sendCommand('/Kyber.SetTeamById ${player.id} 1');
            }
          },
        ),
        KyberTableItem.button(
          title: 'Shuffle Players',
          text: 'Shuffle',
          onClick: () {
            final players = List<ServerPlayer>.from(context.read<ModerationCubit>().state.players)..shuffle();
            final teamSize = players.length ~/ 2;
            final team1 = players.sublist(0, teamSize);
            final team2 = players.sublist(teamSize);

            for (final player in team1) {
              context.read<ModerationCubit>().sendCommand('/Kyber.SetTeamById ${player.id} 1');
            }

            for (final player in team2) {
              context.read<ModerationCubit>().sendCommand('/Kyber.SetTeamById ${player.id} 2');
            }
          },
        ),*/
      ],
    );
  }
}
