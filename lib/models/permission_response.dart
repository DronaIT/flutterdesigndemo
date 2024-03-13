class PermissionResponse {
  List<String>? roleIds;
  String? permissionId;
  String? permissionTitle;
  List<String>? moduleIds;
  List<String>? moduleIdFromModuleIds;
  List<String>? roleIdFromRoleIds;

  PermissionResponse({this.roleIds, this.permissionId, this.permissionTitle, this.moduleIds, this.moduleIdFromModuleIds, this.roleIdFromRoleIds});

  PermissionResponse.fromJson(Map<String, dynamic> json) {
    roleIds = json['role_ids']?.cast<String>();
    permissionId = json['permission_id'];
    permissionTitle = json['permission_title'];
    moduleIds = json['module_ids']?.cast<String>();
    moduleIdFromModuleIds = json['module_id (from module_ids)']?.cast<String>();
    roleIdFromRoleIds = json['role_id (from role_ids)']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_ids'] = roleIds;
    data['permission_id'] = permissionId;
    data['permission_title'] = permissionTitle;
    data['module_ids'] = moduleIds;
    data['module_id (from module_ids)'] = moduleIdFromModuleIds;
    data['role_id (from role_ids)'] = roleIdFromRoleIds;
    return data;
  }
}
