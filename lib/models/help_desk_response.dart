import 'package:flutterdesigndemo/models/helpdesk_responses.dart';

class HelpDeskResponse {
  String? id;
  String? createdTime;
  HelpdeskResponses? fields;

  HelpDeskResponse({this.id, this.createdTime, this.fields});

  HelpDeskResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? HelpdeskResponses.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdTime'] = createdTime;
    if (fields != null) {
      data['fields'] = fields!.toJson();
    }
    return data;
  }
}
