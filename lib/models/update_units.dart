import 'package:flutterdesigndemo/models/units_response.dart';

class UpdateUnits {
  String? id;
  String? createdTime;
  UnitsResponse? fields;

  UpdateUnits({this.id, this.createdTime, this.fields});

  UpdateUnits.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? UnitsResponse.fromJson(json['fields']) : null;
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
