import 'package:flutterdesigndemo/models/job_opportunity_response.dart';

class UpdateJobOpportunity {
  String? id;
  String? createdTime;
  JobOpportunityResponse? fields;

  UpdateJobOpportunity({this.id, this.createdTime, this.fields});

  UpdateJobOpportunity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? JobOpportunityResponse.fromJson(json['fields']) : null;
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
