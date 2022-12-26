class AddTopicsRequest {
  String? topicTitle;

  AddTopicsRequest({this.topicTitle});

  AddTopicsRequest.fromJson(Map<String, dynamic> json) {
    topicTitle = json['topic_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic_title'] = this.topicTitle;
    return data;
  }
}
