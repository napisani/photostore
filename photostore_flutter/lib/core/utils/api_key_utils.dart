const ACCESS_TOKEN_KEY = "access_token";

class APIKeyUtils {
  static appendAPIKeyToURL(String url, Map<String, String> headers) {
    String token = headers[ACCESS_TOKEN_KEY];
    if (token != null && token != '') {
      if (!url.contains('?')) {
        url += "?";
      } else {
        url += "&";
      }
      return url + ACCESS_TOKEN_KEY + "=" + Uri.encodeFull(token);
    }
    return url;
  }
}
