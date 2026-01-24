import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

class StatsSearchCubit extends Cubit<SearchState> {
  StatsSearchCubit() : super(SearchInitial()) {
    _searchQuery.debounceTime(const Duration(milliseconds: 500)).listen((
      query,
    ) async {
      if (query.isEmpty || query.length < 3) {
        emit(SearchInitial());
        return;
      }

      try {
        emit(SearchLoading());
        final result = await sl.get<KyberGRPCService>().statsClient.searchUser(
          StatsSearchRequest(query: query),
        );
        emit(SearchLoaded(result.users));
      } catch (e, s) {
        Logger.root.severe('Error searching user', e, s);
        if (e is GrpcError) {
          emit(SearchError(e.message ?? 'Unknown Error'));
        } else {
          emit(SearchError(e.toString()));
        }
      }
    });
  }

  final BehaviorSubject<String> _searchQuery = BehaviorSubject<String>();

  void search(String query) {
    _searchQuery.add(query);
  }

  @override
  Future<void> close() {
    _searchQuery.close();
    return super.close();
  }
}

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  SearchLoaded(this.result);

  final List<EAUser> result;
}

class SearchError extends SearchState {
  const SearchError(this.error);

  final String error;
}
