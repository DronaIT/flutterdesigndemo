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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['filename'] = this.filename;
    data['type'] = this.type;
    return data;
  }
}
