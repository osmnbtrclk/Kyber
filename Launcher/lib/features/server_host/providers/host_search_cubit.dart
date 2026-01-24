import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyber_launcher/features/server_host/screens/server_host.dart';
import 'package:rxdart/rxdart.dart';

class HostSearchCubit extends Cubit<HostSearchState> {
  HostSearchCubit() : super(const HostSearchState('')) {
    _searchQuery.debounceTime(const Duration(milliseconds: 50)).listen((
      query,
    ) async {
      emit(HostSearchState(query));
    });
  }

  final BehaviorSubject<String> _searchQuery = BehaviorSubject<String>();

  @override
  Future<void> close() {
    _searchQuery.close();
    return super.close();
  }

  void clear() {
    searchController.clear();
    _searchQuery.add('');
    emit(const HostSearchState(''));
  }

  void addSearchQuery(String query) {
    _searchQuery.add(query);
  }
}

class HostSearchState {
  const HostSearchState(this.searchQuery);

  final String searchQuery;
}
