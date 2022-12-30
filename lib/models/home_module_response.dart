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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_ids'] = this.roleIds;
    data['module_id'] = this.moduleId;
    data['module_title'] = this.moduleTitle;
    data['module_image'] = this.moduleImage;
    data['role_id (from role_ids)'] = this.roleIdFromRoleIds;
    return data;
  }
}
