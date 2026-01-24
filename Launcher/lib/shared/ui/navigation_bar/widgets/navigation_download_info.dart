import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/core/config/colors.dart';
import 'package:kyber_launcher/features/download_manager/models/download_state.dart';
import 'package:kyber_launcher/features/download_manager/providers/download_manager_cubit.dart';
import 'package:kyber_launcher/features/settings/dialogs/chromium_download_dialog.dart';
import 'package:kyber_launcher/gen/fonts.gen.dart';
import 'package:kyber_launcher/shared/ui/utils/background_blur.dart';

class NavigationDownloadInfo extends StatefulWidget {
  const NavigationDownloadInfo({super.key});

  @override
  State<NavigationDownloadInfo> createState() => _NavigationDownloadInfoState();
}

class _NavigationDownloadInfoState extends State<NavigationDownloadInfo> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(
      builder: (context, state) {
        return SizedBox.shrink();
      },
    );
  }
}
