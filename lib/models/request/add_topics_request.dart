class AddTopicsRequest {
  String? topicTitle;
  List<String>? unitIds;

  AddTopicsRequest({this.topicTitle, this.unitIds});

  AddTopicsRequest.fromJson(Map<String, dynamic> json) {
    topicTitle = json['topic_title'];
    unitIds = json['unit_ids']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topic_title'] = topicTitle;
    data['unit_ids'] = unitIds;
    return data;
  }
}
