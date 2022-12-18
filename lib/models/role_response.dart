class RoleResponse {
  String? roleTitle;
  int? roleAuthority;
  String? roleId;
  bool? isActive;

  RoleResponse({this.roleTitle, this.roleAuthority, this.roleId, this.isActive});

  RoleResponse.fromJson(Map<String, dynamic> json) {
    roleTitle = json['role_title'];
    roleAuthority = json['role_authority'];
    roleId = json['role_id'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_title'] = this.roleTitle;
    data['role_authority'] = this.roleAuthority;
    data['role_id'] = this.roleId;
    data['is_active'] = this.isActive;
    return data;
  }
}
