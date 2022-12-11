class RoleResponse {
  String? roleTitle;
  int? roleAuthority;
  List<String>? tBLPERMISSION;
  String? roleId;
  List<String>? tBLMODULE;
  bool? isActive;

  RoleResponse({this.roleTitle, this.roleAuthority, this.tBLPERMISSION, this.roleId, this.tBLMODULE, this.isActive});

  RoleResponse.fromJson(Map<String, dynamic> json) {
    roleTitle = json['role_title'];
    roleAuthority = json['role_authority'];
    tBLPERMISSION = json['TBL_PERMISSION']?.cast<String>();
    roleId = json['role_id'];
    tBLMODULE = json['TBL_MODULE']?.cast<String>();
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_title'] = this.roleTitle;
    data['role_authority'] = this.roleAuthority;
    data['TBL_PERMISSION'] = this.tBLPERMISSION;
    data['role_id'] = this.roleId;
    data['TBL_MODULE'] = this.tBLMODULE;
    data['is_active'] = this.isActive;
    return data;
  }
}
