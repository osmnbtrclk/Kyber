import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/features/kyber/models/mode.dart';
import 'package:kyber_launcher/features/server_host/providers/host_search_cubit.dart';
import 'package:kyber_launcher/features/server_host/widgets/create_server/map_rotation/map_list.dart';
import 'package:kyber_launcher/features/server_host/widgets/create_server/map_rotation/mode_list.dart';
import 'package:kyber_launcher/shared/ui/ui.dart';

class LoadMapDialog extends StatefulWidget {
  const LoadMapDialog({super.key});

  @override
  State<LoadMapDialog> createState() => _LoadMapDialogState();
}

class _LoadMapDialogState extends State<LoadMapDialog> {
  Mode? selectedMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HostSearchCubit(),
      child: KyberContentDialog(
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 600,
        ),
        title: const Text('LOAD MAP'),
        content: selectedMode == null
            ? ModeList(
                onModeSelected: (mode) => setState(() => selectedMode = mode),
              )
            : MapList(
                selectedMode: selectedMode,
                onAdd: (map) => Navigator.of(context).pop(map),
                onBack: () => setState(() => selectedMode = null),
              ),
        actions: [
          KyberButton(
            onPressed: () => Navigator.of(context).pop(),
            text: 'Cancel',
          ),
        ],
      ),
    );
  }
}
