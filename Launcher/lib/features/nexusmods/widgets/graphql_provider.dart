import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_ce/hive.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/core/services/storage_helper.dart';
import 'package:kyber_launcher/main.dart';

GraphQLClient? nexusGqlClient;

class GraphqlProvider extends StatefulWidget {
  const GraphqlProvider({required this.child, super.key});

  final Widget child;

  @override
  State<GraphqlProvider> createState() => _GraphqlProviderState();
}

class _GraphqlProviderState extends State<GraphqlProvider> {
  late ValueNotifier<GraphQLClient> qlClient;
  Completer<Box<dynamic>?> cacheBox = Completer();

  @override
  void initState() {
    setClient();

    Hive.init(StorageHelper.getCacheDir());

    Hive.openBox<dynamic?>(
          'nexusGqlCache',
        )
        .then(cacheBox.complete)
        .catchError((Object e, StackTrace st) => cacheBox.completeError(e, st))
        .then((_) => setState(() => null));

    box.watch(key: 'nexusModsApiToken').listen((event) async {
      await setClient();
      setState(() {});
    });

    super.initState();
  }

  Future<void> setClient() async {
    final box = await cacheBox.future;

    qlClient = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: HiveStore(box)),
        link: HttpLink(
          'https://api.nexusmods.com/v2/graphql',
          defaultHeaders: {
            if (Preferences.nexusMods.apiToken != null)
              'apikey': Preferences.nexusMods.apiToken!,
          },
        ),
      ),
    );
    nexusGqlClient = qlClient.value;
  }

  @override
  Widget build(BuildContext context) {
    if (!cacheBox.isCompleted) {
      return widget.child;
    }

    return GraphQLProvider(
      client: qlClient,
      child: widget.child,
    );
  }
}
