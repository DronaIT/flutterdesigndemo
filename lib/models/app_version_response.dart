class AppVersionResponse {
  int? id;
  String? androidVersion;
  String? iosVersion;
  int? updateType;
  String? enablePushNotifications;
  String? text_to_display;
  String? image_to_display;
  String? is_clickable;
  String? type;

  AppVersionResponse({
    this.id,
    this.androidVersion,
    this.iosVersion,
    this.updateType,
    this.enablePushNotifications,
    this.text_to_display,
    this.image_to_display,
    this.is_clickable,
    this.type,
  });

  AppVersionResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    androidVersion = json['android_version'];
    iosVersion = json['ios_version'];
    updateType = json['update_type'];
    enablePushNotifications = json['enable_push_notifications'];
    text_to_display = json['text_to_display'];
    image_to_display = json['image_to_display'];
    is_clickable = json['is_clickable'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['android_version'] = androidVersion;
    data['ios_version'] = iosVersion;
    data['update_type'] = updateType;
    data['enable_push_notifications'] = enablePushNotifications;
    data['text_to_display'] = text_to_display;
    data['image_to_display'] = image_to_display;
    data['is_clickable'] = is_clickable;
    data['type'] = type;
    return data;
  }
}
