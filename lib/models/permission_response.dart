class PermissionResponse {
  List<String>? roleIds;
  String? permissionId;
  String? permissionTitle;
  List<String>? moduleIds;
  List<String>? moduleIdFromModuleIds;
  List<String>? roleIdFromRoleIds;

  PermissionResponse({this.roleIds, this.permissionId, this.permissionTitle, this.moduleIds, this.moduleIdFromModuleIds, this.roleIdFromRoleIds});

  PermissionResponse.fromJson(Map<String, dynamic> json) {
    roleIds = json['role_ids'].cast<String>();
    permissionId = json['permission_id'];
    permissionTitle = json['permission_title'];
    moduleIds = json['module_ids'].cast<String>();
    moduleIdFromModuleIds = json['module_id (from module_ids)'].cast<String>();
    roleIdFromRoleIds = json['role_id (from role_ids)'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_ids'] = this.roleIds;
    data['permission_id'] = this.permissionId;
    data['permission_title'] = this.permissionTitle;
    data['module_ids'] = this.moduleIds;
    data['module_id (from module_ids)'] = this.moduleIdFromModuleIds;
    data['role_id (from role_ids)'] = this.roleIdFromRoleIds;
    return data;
  }
}
