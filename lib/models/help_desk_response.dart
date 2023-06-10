import 'package:flutterdesigndemo/models/helpdesk_responses.dart';

class HelpDeskResponse {
  String? id;
  String? createdTime;
  HelpdeskResponses? fields;

  HelpDeskResponse({this.id, this.createdTime, this.fields});

  HelpDeskResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields =
    json['fields'] != null ? new HelpdeskResponses.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdTime'] = this.createdTime;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    return data;
  }
}