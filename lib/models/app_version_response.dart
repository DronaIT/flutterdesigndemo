class AppVersionResponse {
  int? id;
  String? androidVersion;
  String? iosVersion;
  int? updateType;
  String? enablePushNotifications;

  AppVersionResponse({this.id, this.androidVersion, this.iosVersion, this.updateType, this.enablePushNotifications});

  AppVersionResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    androidVersion = json['android_version'];
    iosVersion = json['ios_version'];
    updateType = json['update_type'];
    enablePushNotifications = json['enable_push_notifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['android_version'] = androidVersion;
    data['ios_version'] = iosVersion;
    data['update_type'] = updateType;
    data['enable_push_notifications'] = enablePushNotifications;
    return data;
  }
}
