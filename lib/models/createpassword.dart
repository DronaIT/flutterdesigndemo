import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';

class CreatePasswordResponse {
  String? id;
  String? createdTime;
  LoginFieldsResponse? fields;

  CreatePasswordResponse({this.id, this.createdTime, this.fields});

  CreatePasswordResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields =
        json['fields'] != null ? new LoginFieldsResponse.fromJson(json['fields']) : null;
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
//   String? city;
//   String? joiningYear;
//   int? studentId;
//   List<String>? hubIds;
//   String? name;
//   String? address;
//   String? mobileNumber;
//   List<String>? specializationIds;
//   String? gender;
//   String? createdOn;
//   String? updatedOn;
//   String? enrollmentNumber;
//   List<String>? hubIdFromHubIds;
//   List<String>? specializationIdFromSpecializationIds;
//   String? password;
//
//   Fields(
//       {this.city,
//       this.joiningYear,
//       this.studentId,
//       this.hubIds,
//       this.name,
//       this.address,
//       this.mobileNumber,
//       this.specializationIds,
//       this.gender,
//       this.createdOn,
//       this.updatedOn,
//       this.enrollmentNumber,
//       this.hubIdFromHubIds,
//       this.specializationIdFromSpecializationIds,
//       this.password});
//
//   Fields.fromJson(Map<String, dynamic> json) {
//     city = json['city'];
//     joiningYear = json['joining_year'];
//     studentId = json['student_id'];
//     hubIds = json['hub_ids'].cast<String>();
//     name = json['name'];
//     address = json['address'];
//     mobileNumber = json['mobile_number'];
//     specializationIds = json['specialization_ids'].cast<String>();
//     gender = json['gender'];
//     createdOn = json['created_on'];
//     updatedOn = json['updated_on'];
//     enrollmentNumber = json['enrollment_number'];
//     hubIdFromHubIds = json['hub_id (from hub_ids)'].cast<String>();
//     specializationIdFromSpecializationIds =
//         json['specialization_id (from specialization_ids)'].cast<String>();
//     password = json['password'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['city'] = this.city;
//     data['joining_year'] = this.joiningYear;
//     data['student_id'] = this.studentId;
//     data['hub_ids'] = this.hubIds;
//     data['name'] = this.name;
//     data['address'] = this.address;
//     data['mobile_number'] = this.mobileNumber;
//     data['specialization_ids'] = this.specializationIds;
//     data['gender'] = this.gender;
//     data['created_on'] = this.createdOn;
//     data['updated_on'] = this.updatedOn;
//     data['enrollment_number'] = this.enrollmentNumber;
//     data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
//     data['specialization_id (from specialization_ids)'] =
//         this.specializationIdFromSpecializationIds;
//     data['password'] = this.password;
//     return data;
//   }
// }
