import 'package:oauth2_client/oauth2_client.dart';

class PatreonOAuthClient extends OAuth2Client {
  PatreonOAuthClient({
    required super.redirectUri,
    required super.customUriScheme,
  }) : super(
         authorizeUrl: 'https://www.patreon.com/oauth2/authorize',
         tokenUrl: 'https://www.patreon.com/oauth2/token',
       );
}
