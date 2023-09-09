String httpScheme = '';
int httpPort = 80;
String httpHost = '';
String apiPrefix = '/api';

initHttp(String scheme, int port, String host, String prefix) {
  httpScheme = scheme;
  httpPort = port;
  httpHost = host;
  apiPrefix = prefix;
}
