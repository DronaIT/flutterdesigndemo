class DocumentResponse {
  String? id;
  String? url;
  String? filename;
  String? type;

  DocumentResponse({this.id, this.url, this.filename, this.type});

  DocumentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    filename = json['filename'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['filename'] = filename;
    data['type'] = type;
    return data;
  }
}
