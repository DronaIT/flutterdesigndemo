class TopicsResponse {
  List<String>? unitIds;
  int? ids;
  String? topicTitle;
  String? topicId;
  List<String>? unitIdFromUnitIds;
  bool selected = false;

  TopicsResponse({this.unitIds, this.ids, this.topicTitle, this.topicId, this.unitIdFromUnitIds});

  TopicsResponse.fromJson(Map<String, dynamic> json) {
    unitIds = json['unit_ids']?.cast<String>();
    ids = json['ids'];
    topicTitle = json['topic_title'];
    topicId = json['topic_id'];
    unitIdFromUnitIds = json['unit_id (from unit_ids)']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit_ids'] = unitIds;
    data['ids'] = ids;
    data['topic_title'] = topicTitle;
    data['topic_id'] = topicId;
    data['unit_id (from unit_ids)'] = unitIdFromUnitIds;
    return data;
  }
}
