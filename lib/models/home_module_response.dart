class homeModuleResponse {
  List<String>? roleIds;
  String? moduleId;
  String? moduleTitle;
  String? moduleImage;
  List<String>? roleIdFromRoleIds;

  homeModuleResponse({this.roleIds, this.moduleId, this.moduleTitle, this.roleIdFromRoleIds, this.moduleImage});

  homeModuleResponse.fromJson(Map<String, dynamic> json) {
    roleIds = json['role_ids']?.cast<String>();
    moduleId = json['module_id'];
    moduleTitle = json['module_title'];
    moduleImage = json['module_image'];
    roleIdFromRoleIds = json['role_id (from role_ids)']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['role_ids'] = roleIds;
    data['module_id'] = moduleId;
    data['module_title'] = moduleTitle;
    data['module_image'] = moduleImage;
    data['role_id (from role_ids)'] = roleIdFromRoleIds;
    return data;
  }
}
