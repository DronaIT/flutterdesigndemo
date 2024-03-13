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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_title'] = roleTitle;
    data['role_authority'] = roleAuthority;
    data['role_id'] = roleId;
    data['is_active'] = isActive;
    return data;
  }
}
