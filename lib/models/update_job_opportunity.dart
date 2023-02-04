import 'package:flutterdesigndemo/models/job_opportunity_response.dart';

class UpdateJobOpportunity {
  String? id;
  String? createdTime;
  JobOpportunityResponse? fields;

  UpdateJobOpportunity({this.id, this.createdTime, this.fields});

  UpdateJobOpportunity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? new JobOpportunityResponse.fromJson(json['fields']) : null;
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
