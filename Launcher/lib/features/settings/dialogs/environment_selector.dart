import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/core/services/module_version_service.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/features/kyber/providers/kyber_api_status_cubit.dart';
import 'package:kyber_launcher/features/maxima/providers/maxima_cubit.dart';
import 'package:kyber_launcher/features/settings/dialogs/update_dialog.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/gen/rust/api/maxima.dart';
import 'package:kyber_launcher/main.dart';
import 'package:kyber_launcher/shared/ui/dialog/kyber_dialog.dart';
import 'package:kyber_launcher/shared/ui/elements/dropdown/kyber_dropdown.dart';

class EnvironmentSelector extends StatefulWidget {
  const EnvironmentSelector({super.key});

  @override
  State<EnvironmentSelector> createState() => _EnvironmentSelectorState();
}

class _EnvironmentSelectorState extends State<EnvironmentSelector> {
  late String selectedEnv;

  @override
  void initState() {
    selectedEnv = Preferences.admin.apiEnv;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KyberContentDialog(
      title: const Text('Select Environment'),
      constraints: const BoxConstraints(maxWidth: 600, maxHeight: 450),
      content: Column(
        children: [
          const Text(
            'Please select the environment you want to use for KYBER.',
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                BorderSide(
                  color: kActiveColor,
                  width: 2,
                ),
              ),
              borderRadius: BorderRadius.circular(kDefaultInnerBorderRadius),
              color: Colors.black.withOpacity(.4),
            ),
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Do not change this setting unless instructed by the KYBER team. You will not be able to log into other environments without access.',
              style: TextStyle(
                fontFamily: FontFamily.battlefrontUI,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 10),
          KyberDropdown<String>(
            onChanged: (value) {
              selectedEnv = value;
              setState(() => null);
            },
            itemBuilder: (DropdownItem<dynamic> item) {
              item as DropdownItem<String>;
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontFamily: FontFamily.battlefrontUI,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            items: context
                .read<LightswitchCubit>()
                .state
                .environments
                .map((e) => DropdownItem(value: e.id, label: e.name))
                .toList(),
            selectedItem: selectedEnv,
          ),
        ],
      ),
      actions: [
        Button(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Button(
          onPressed: () async {
            try {
              final service = KyberGRPCService.fromEnv(selectedEnv);

              if (!context.read<MaximaCubit>().state.isEntitled(
                UserEntitlement.admin,
              )) {
                final token = await getAuthToken();
                await service.login(token);
              }

              Preferences.admin.apiEnv = selectedEnv;
              final config = await service.launcherClient.getLauncherConfig(
                Empty(),
              );
              for (final target in config.defaultChannels.entries) {
                await box.put('${target.key}_release_channel', target.value);
              }

              final updateAvailable = await ModuleVersionService()
                  .updateAvailable(module: VersionModule.installer);
              if (!updateAvailable) {
                NotificationService.warning(
                  message: 'Please restart the Launcher to apply the changes.',
                );
              } else {
                NotificationService.info(
                  message:
                      'Environment changed successfully. Downloading latest version of the Launcher...',
                );
                Navigator.of(context).pop();
                await showKyberDialog(
                  context: navigatorKey.currentContext!,
                  builder: (context) => const UpdateDialog(forceInstall: true),
                );
              }
            } on GrpcError catch (e) {
              if (e.code == StatusCode.permissionDenied) {
                NotificationService.error(
                  message:
                      'You are not allowed to access this environment. If you think this is a mistake, please contact support.',
                );
              } else {
                NotificationService.error(
                  message:
                      'An error occurred while changing the environment: ${e.message}',
                );
              }
            } catch (e) {
              NotificationService.error(
                message: 'An error occurred while changing the environment: $e',
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
