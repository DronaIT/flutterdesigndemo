class App_data_response {
  int? id;
  String? title;
  String? description;
  String? url;
  String? isForStudent;

  App_data_response({this.id, this.title, this.description, this.url, this.isForStudent});

  App_data_response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    isForStudent = json['isForStudent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['isForStudent'] = isForStudent;
    return data;
  }
}