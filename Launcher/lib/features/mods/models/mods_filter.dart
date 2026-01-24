import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/features/kyber/providers/kyber_proxy_cubit.dart';
import 'package:kyber_launcher/features/maxima/providers/maxima_cubit.dart';

enum ModScope {
  all,
  gameplay,
  cosmetic,
}

class ModsFilter {
  const ModsFilter({
    this.scope = ModScope.all,
    this.query,
  });

  final String? query;
  final ModScope scope;

  ModsFilter copyWith({
    String? query,
    ModScope? scope,
  }) {
    return ModsFilter(
      query: query ?? this.query,
      scope: scope ?? this.scope,
    );
  }
}
