import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';

class StatusCubit extends Cubit<ApplicationStatus> {
  StatusCubit()
    : super(ApplicationStatus(initialized: Preferences.general.setup));

  void setInitialized(bool initialized) {
    emit(state.copyWith(initialized: initialized));
  }
}

class ApplicationStatus {
  const ApplicationStatus({
    required this.initialized,
  });

  final bool initialized;

  ApplicationStatus copyWith({
    bool? initialized,
  }) {
    return ApplicationStatus(
      initialized: initialized ?? this.initialized,
    );
  }
}
