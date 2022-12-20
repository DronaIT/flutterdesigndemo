import 'package:flutterdesigndemo/models/hub_response.dart';

class UpdateHub {
  String? id;
  String? createdTime;
  HubResponse? fields;

  UpdateHub({this.id, this.createdTime, this.fields});

  UpdateHub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields =
        json['fields'] != null ? new HubResponse.fromJson(json['fields']) : null;
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

// class Fields {
//   List<String>? tBLEMPLOYEE;
//   String? hubName;
//   List<String>? tBLSTUDENT;
//   List<String>? tBLSPECIALIZATION;
//   String? city;
//   String? hubId;
//   String? address;
//
//   Fields(
//       {this.tBLEMPLOYEE,
//       this.hubName,
//       this.tBLSTUDENT,
//       this.tBLSPECIALIZATION,
//       this.city,
//       this.hubId,
//       this.address});
//
//   Fields.fromJson(Map<String, dynamic> json) {
//     tBLEMPLOYEE = json['TBL_EMPLOYEE'].cast<String>();
//     hubName = json['hub_name'];
//     tBLSTUDENT = json['TBL_STUDENT'].cast<String>();
//     tBLSPECIALIZATION = json['TBL_SPECIALIZATION'].cast<String>();
//     city = json['city'];
//     hubId = json['hub_id'];
//     address = json['address'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['TBL_EMPLOYEE'] = this.tBLEMPLOYEE;
//     data['hub_name'] = this.hubName;
//     data['TBL_STUDENT'] = this.tBLSTUDENT;
//     data['TBL_SPECIALIZATION'] = this.tBLSPECIALIZATION;
//     data['city'] = this.city;
//     data['hub_id'] = this.hubId;
//     data['address'] = this.address;
//     return data;
//   }
// }
