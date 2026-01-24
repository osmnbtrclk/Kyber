import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/injection_container.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventsLoading()) {
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final posts = await sl
          .get<KyberGRPCService>()
          .launcherClient
          .getLauncherConfig(Empty());
      emit(EventsLoaded(posts: posts.posts));
    } on GrpcError catch (e) {
      emit(EventsError(error: e.message ?? e.codeName));
    } catch (e) {
      emit(EventsError(error: e.toString()));
    }
  }
}

abstract class EventState {}

class EventsError extends EventState {
  final String error;

  EventsError({required this.error});
}

class EventsLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Post> posts;

  EventsLoaded({required this.posts});
}
