class PayPalModel {
  String? scope;
  String? accessToken;
  String? tokenType;
  String? appId;
  int? expiresIn;
  String? nonce;

  PayPalModel(
      {this.scope,
      this.accessToken,
      this.tokenType,
      this.appId,
      this.expiresIn,
      this.nonce});

  PayPalModel.fromJson(Map<String, dynamic> json) {
    scope = json['scope'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    appId = json['app_id'];
    expiresIn = json['expires_in'];
    nonce = json['nonce'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scope'] = scope;
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    data['app_id'] = appId;
    data['expires_in'] = expiresIn;
    data['nonce'] = nonce;
    return data;
  }
}
