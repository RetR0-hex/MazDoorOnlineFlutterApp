// This should be Singleton class

class JWT_TOKEN_DATA {

  static final JWT_TOKEN_DATA _singleton = JWT_TOKEN_DATA._internal();

  late String accessToken;
  late String refreshToken;

  factory JWT_TOKEN_DATA() {
    return _singleton;
  }

  JWT_TOKEN_DATA._internal();

  Map<String, dynamic> getAccessHeader(){
    return {"authorization": "Bearer $accessToken"};
  }

  Map<String, dynamic> getRefreshHeader(){
    return {"authorization": "Bearer $refreshToken"};
  }

}