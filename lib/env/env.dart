import 'package:envied/envied.dart';
import 'package:karmayogi_mobile/constants/index.dart';
part 'env.g.dart';

@Envied(path: Environment.prod, requireEnvFile: true)
abstract class Env {
  @EnviedField(varName: 'PORTAL_BASE_URL', obfuscate: true)
  static final portalBaseUrl = _Env.portalBaseUrl;

  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static final baseUrl = _Env.baseUrl;

  @EnviedField(varName: 'FRAC_BASE_URL', obfuscate: true)
  static final fracBaseUrl = _Env.fracBaseUrl;

  @EnviedField(varName: 'TERMS_OF_SERVICE_URL', obfuscate: true)
  static final termsOfServiceUrl = _Env.termsOfServiceUrl;

  @EnviedField(varName: 'PARICHAY_BASE_URL', obfuscate: true)
  static final parichayBaseUrl = _Env.parichayBaseUrl;

  @EnviedField(varName: 'FRAC_DICTIONARY_URL', obfuscate: true)
  static final fracDictionaryUrl = _Env.fracDictionaryUrl;

  @EnviedField(varName: 'CONFIG_URL', obfuscate: true)
  static final configUrl = _Env.configUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final apiKey = _Env.apiKey;

  @EnviedField(varName: 'PARICHAY_CLIENT_ID', obfuscate: true)
  static final parichayClientId = _Env.parichayClientId;

  @EnviedField(varName: 'PARICHAY_CLIENT_SECRET', obfuscate: true)
  static final parichayClientSecret = _Env.parichayClientSecret;

  @EnviedField(varName: 'PARICHAY_CODE_VERIFIER', obfuscate: true)
  static final parichayCodeVerifier = _Env.parichayCodeVerifier;

  @EnviedField(varName: 'PARICHAY_KEYCLOAK_CLIENT_SECRET', obfuscate: true)
  static final parichayKeycloakSecret = _Env.parichayKeycloakSecret;

  @EnviedField(varName: 'X_CHANNEL_ID', obfuscate: true)
  static final xChannelId = _Env.xChannelId;

  @EnviedField(varName: 'HOST', obfuscate: true)
  static final host = _Env.host;

  @EnviedField(varName: 'BUCKET', obfuscate: true)
  static final bucket = _Env.bucket;

  @EnviedField(varName: 'VEGA_SOCKET_URL', obfuscate: true)
  static final vegaSocketUrl = _Env.vegaSocketUrl;

  @EnviedField(varName: 'ENTRY_PAGE_FILE_NAME', obfuscate: true)
  static final entryPageFileName = _Env.entryPageFileName;

  @EnviedField(varName: 'TELEMETRY_PDATA_ID', obfuscate: true)
  static final telemetryPdataId = _Env.telemetryPdataId;

  @EnviedField(varName: 'SOURCE_NAME', obfuscate: true)
  static final sourceName = _Env.sourceName;
}
