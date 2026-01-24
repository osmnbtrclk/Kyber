import 'dart:convert';
import 'dart:io';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:kyber/kyber.dart';
import 'package:kyber_launcher/core/services/app_settings.dart';
import 'package:kyber_launcher/features/patreon/models/patreon_identity_response.dart';
import 'package:kyber_launcher/features/patreon/models/patreon_oauth_client.dart';
import 'package:kyber_launcher/features/patreon/constants/oauth_landing_page.dart';
import 'package:kyber_launcher/gen/rust/api/maxima.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class PatreonService {
  PatreonService._();

  static final _oauthClient = PatreonOAuthClient(
    redirectUri: 'http://localhost:13022',
    customUriScheme: 'http://localhost:13022',
  );
  static final _oauthHelper = OAuth2Helper(
    _oauthClient,
    clientId:
        'gSKcmE6aCG6XQVuWz7DFmZilWw3SaA_ZLaqzOWtO0iWlPDXRoSJOH97a0PEbZ0c2',
    scopes: ['identity'],
  );

  static Future<String?> requestOAuthLogin() async {
    if (Platform.isMacOS) {
      final x = await _oauthClient.requestAuthorization(
        clientId: _oauthHelper.clientId,
        scopes: _oauthHelper.scopes,
      );
      return x.code;
    }

    final url = Uri.https('www.patreon.com', '/oauth2/authorize', {
      'response_type': 'code',
      'client_id': _oauthHelper.clientId,
      'redirect_uri': 'http://localhost:13022',
      'scope': _oauthHelper.scopes?.join(' '),
    });

    final response = await FlutterWebAuth2.authenticate(
      callbackUrlScheme: 'http://localhost:13022',
      url: url.toString(),
      options: const FlutterWebAuth2Options(
        landingPageHtml: oauthLandingPage,
        useWebview: false,
      ),
    );

    final uri = Uri.parse(response);
    final error = uri.queryParameters['error'];
    if (error != null) {
      final description = uri.queryParameters['error_description'];
      throw PatreonException(
        code: error,
        message: description ?? 'Unknown error',
      );
    }

    final authCode = uri.queryParameters['code'];

    return authCode;
  }

  static Future<void> fetchToken(String authCode) async {
    final service = sl.get<KyberGRPCService>();
    final data = await service.authClient.patreonLogin(
      AuthCodeRequest(authCode: authCode),
    );

    Preferences.patreon.patreonId = data.userId;
    Preferences.patreon.membershipId = data.membershipId;

    await _oauthHelper.tokenStorage.addToken(
      AccessTokenResponse.fromMap({
        'access_token': data.tokenInfo.accessToken,
        'token_type': data.tokenInfo.tokenType,
        'expires_in': data.tokenInfo.expiresIn.toInt(),
        'refresh_token': data.tokenInfo.refreshToken,
        'expiration_date': DateTime.now()
            .add(Duration(seconds: data.tokenInfo.expiresIn.toInt()))
            .millisecondsSinceEpoch,
        'scope': data.tokenInfo.scope,
      }),
    );
  }

  static Future<bool> isPatreonMember() async {
    final queryBuilder = Uri(
      queryParameters: {
        'fields[user]':
            'first_name,last_name,full_name,vanity,email,about,image_url,thumb_url,created,url',
        'fields[member]':
            'campaign_lifetime_support_cents,currently_entitled_amount_cents,email,full_name,is_follower,last_charge_date,last_charge_status,lifetime_support_cents,next_charge_date,note,patron_status,pledge_cadence,pledge_relationship_start,will_pay_amount_cents',
        'include': 'memberships',
      },
    );

    final response = await _oauthHelper.get(
      'https://www.patreon.com/api/oauth2/v2/identity$queryBuilder',
    );
    final data = PatreonResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
    if (data.included == null || data.included!.isEmpty) {
      return false;
    }

    final membership = data.included!.first.attributes!.patronStatus;
    if (membership == null || membership != 'active_patron') {
      return false;
    }

    return true;
  }

  static Future<void> addToWhitelist() async {
    final service = sl.get<KyberGRPCService>();
    final authToken = await getAuthToken();
    await service.authClient.linkPatreonAccount(
      LinkPatreonAccountRequest(
        patreonId: Preferences.patreon.patreonId,
        membershipId: Preferences.patreon.membershipId,
        token: authToken,
      ),
    );
  }
}

class PatreonException implements Exception {
  PatreonException({required this.code, required this.message});

  final String code;
  final String message;

  @override
  String toString() {
    return 'PatreonException: $code - $message';
  }
}
