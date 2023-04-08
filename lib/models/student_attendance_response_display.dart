class StudentAttendanceResponseDisplay {
  String? studentIds;
  String? presentIds;
  String? absent_ids;
  String? enrollmentNumberFromStudentIds;
  String? nameFromStudentIds;

  StudentAttendanceResponseDisplay({this.studentIds, this.presentIds, this.enrollmentNumberFromStudentIds, this.nameFromStudentIds, this.absent_ids});

  StudentAttendanceResponseDisplay.fromJson(Map<String, dynamic> json) {
    studentIds = json['student_ids'];
    presentIds = json['present_ids'];
    enrollmentNumberFromStudentIds = json['enrollment_numbers'];
    absent_ids = json['absent_ids'];
    nameFromStudentIds = json['name (from student_ids)']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['student_ids'] = this.studentIds;
    data['present_ids'] = this.presentIds;

    data['enrollment_numbers'] = this.enrollmentNumberFromStudentIds;
    data['name (from student_ids)'] = this.nameFromStudentIds;
    data['absent_ids'] = this.absent_ids;

    return data;
  }
}
