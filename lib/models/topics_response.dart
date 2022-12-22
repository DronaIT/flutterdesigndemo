class TopicsResponse {
  List<String>? unitIds;
  int? ids;
  String? topicTitle;
  String? topicId;
  List<String>? unitIdFromUnitIds;

  TopicsResponse({this.unitIds, this.ids, this.topicTitle, this.topicId, this.unitIdFromUnitIds});

  TopicsResponse.fromJson(Map<String, dynamic> json) {
    unitIds = json['unit_ids'].cast<String>();
    ids = json['ids'];
    topicTitle = json['topic_title'];
    topicId = json['topic_id'];
    unitIdFromUnitIds = json['unit_id (from unit_ids)'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit_ids'] = this.unitIds;
    data['ids'] = this.ids;
    data['topic_title'] = this.topicTitle;
    data['topic_id'] = this.topicId;
    data['unit_id (from unit_ids)'] = this.unitIdFromUnitIds;
    return data;
  }
}
