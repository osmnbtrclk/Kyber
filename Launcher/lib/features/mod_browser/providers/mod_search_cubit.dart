import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kyber_launcher/core/routing/app_router.dart';
import 'package:kyber_launcher/features/mod_browser/providers/mod_browser_cubit.dart';
import 'package:kyber_launcher/features/nexusmods/widgets/graphql_provider.dart';
import 'package:nexus_gql/nexus_gql.dart';
import 'package:rxdart/rxdart.dart';

class ModSearchCubit extends Cubit<SearchState> {
  ModSearchCubit() : super(SearchInitial()) {
    _subscription = _searchQuery
        .debounceTime(const Duration(milliseconds: 500))
        .listen((query) async {
          if (query.isEmpty) {
            emit(SearchInitial());
            return;
          }

          try {
            emit(SearchLoading());
            final mbCubit = navigatorKey.currentContext!
                .read<ModBrowserCubit>();
            final result = await nexusGqlClient!.query$searchMods(
              .new(
                variables: .new(
                  query: query,
                  sort: mbCubit.currentSortBy.gqlSort,
                  timeFilter: mbCubit.getTimeFilter(),
                ),
              ),
            );

            if (result.hasException) {
              emit(SearchError(error: result.exception.toString()));
              return;
            }

            emit(SearchLoaded(result.parsedData!.mods.nodes));
          } on GraphQLError catch (e) {
            return emit(SearchError(error: e.message));
          } catch (e) {
            return emit(SearchError());
          }
        });
  }

  final BehaviorSubject<String> _searchQuery = BehaviorSubject<String>();
  StreamSubscription<String>? _subscription;

  void search(String query) {
    _searchQuery.add(query);
  }

  @override
  Future<void> close() async {
    await _searchQuery.close();
    await _subscription?.cancel();

    return super.close();
  }
}

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  SearchLoaded(this.results);

  final List<Query$searchMods$mods$nodes> results;
}

class SearchError extends SearchState {
  SearchError({this.error = 'An error occurred'});

  final String error;
}
