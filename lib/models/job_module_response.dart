class JobModuleResponse {
  String? applied_students_name;
  String? applied_students_email;
  String? applied_students_enrollment_number;
  String? applied_students;
  String? applied_students_number;
  String? applied_students_resume;
  String? applied_students_specialization;
  String? applied_students_semester;
  String? applied_students_is_placed_now;
  bool selected = false;

  JobModuleResponse({
    this.applied_students_name,
    this.applied_students_email,
    this.applied_students,
    this.applied_students_number,
    this.applied_students_enrollment_number,
    this.applied_students_resume,
    this.applied_students_specialization,
    this.applied_students_semester,
    this.applied_students_is_placed_now,
  });

  JobModuleResponse.fromJson(Map<String, dynamic> json) {
    applied_students = json['applied_students'];
    applied_students_name = json['applied_students_name'];
    applied_students_email = json['applied_students_email'];
    applied_students_enrollment_number = json['applied_students_enrollment_number'];
    applied_students_number = json['applied_students_number'];
    applied_students_resume = json['applied_students_resume'];
    applied_students_specialization = json['applied_students_specialization'];
    applied_students_semester = json['applied_students_semester'];
    applied_students_is_placed_now = json['applied_students_is_placed_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['applied_students'] = applied_students;
    data['applied_students_name'] = applied_students_name;
    data['applied_students_email'] = applied_students_email;
    data['applied_students_enrollment_number'] = applied_students_enrollment_number;
    data['applied_students_number'] = applied_students_number;
    data['applied_students_resume'] = applied_students_resume;
    data['applied_students_specialization'] = applied_students_specialization;
    data['applied_students_semester'] = applied_students_semester;
    data['applied_students_is_placed_now'] = applied_students_is_placed_now;
    return data;
  }
}