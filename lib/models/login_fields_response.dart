import 'attachment_response.dart';

class LoginFieldsResponse {
  String? city;
  String? percentage;
  String? joiningYear;
  String? password;
  int? studentId;
  List<String>? hubIds;
  String? name;
  String? address;
  String? mobileNumber;
  String? email = " ";
  List<String>? specializationIds;
  String? gender;
  String? createdOn;
  String? updatedOn;
  String? enrollmentNumber;
  List<String>? hubIdFromHubIds;
  List<String>? specializationIdFromSpecializationIds;
  String? batch;
  String? passed_out_year;
  String? division;
  String? semester;
  List<String>? lectureIds;
  List<String>? absentLectureIds;
  List<String>? absentLectureDate;
  List<String>? absentSubjectTitle;
  List<String>? absentSubjectId;

  List<String>? presentLectureIds;
  List<String>? presentLectureDate;
  List<String>? presentSubjectTitle;
  List<String>? presentSubjectId;
  List<String>? lecture_date;
  List<String>? lectureSubjectId;
  List<String>? lecture_subject_title;
  int attendanceStatus = 1;

  String? sr_number;
  String? birthdate;
  String? aadhar_card_number;
  String? caste;
  String? hsc_school;
  String? hsc_school_city;
  String? hsc_percentage;
  String? mother_name;
  String? mother_number;
  String? father_number;
  String? pin_code;
  int? is_banned;

  List<String>? appliedJob;
  List<String>? shortlistedJob;
  List<String>? selectedJob;
  List<String>? placedJob;
  List<String>? rejectedJob;

  List<String>? job_title_selected_job;
  List<String>? company_name_from_selected_job;
  List<String>? contact_name_from_selected_job;
  List<String>?  city_from_selected_job;
  List<String>? job_description_from_selected_job;

  List<String>? company_name_from_placed_job;
  List<String>? job_title_from_placed_job;
  List<String>? job_description_from_placed_job;

  List<String>? job_title_from_rejected_job;
  List<String>? company_name_from_rejected_job;
  List<String>? job_description_from_rejected_job;


  List<String>? job_title_from_applied_job;
  List<String>? company_name_from_applied_job;
  List<String>? contact_name_from_applied_job;
  List<String>? job_description_from_applied_job;

  String? token;
  List<dynamic>? semesterByStudent;
  List<dynamic>? presentSemesterByStudent;
  List<dynamic>? absentSemesterByStudent;
  int? Total_lectures;
  List<Attachment_response>? resume;

  LoginFieldsResponse({
    this.city,
    this.joiningYear,
    this.password,
    this.studentId,
    this.hubIds,
    this.name,
    this.address,
    this.mobileNumber,
    this.email,
    this.specializationIds,
    this.gender,
    this.createdOn,
    this.updatedOn,
    this.enrollmentNumber,
    this.hubIdFromHubIds,
    this.specializationIdFromSpecializationIds,
    this.division,
    this.semester,
    this.lectureIds,
    this.absentLectureIds,
    this.absentLectureDate,
    this.absentSubjectTitle,
    this.absentSubjectId,
    this.presentLectureIds,
    this.presentLectureDate,
    this.presentSubjectTitle,
    this.presentSubjectId,
    this.lecture_date,
    this.lectureSubjectId,
    this.lecture_subject_title,
    this.sr_number,
    this.birthdate,
    this.aadhar_card_number,
    this.caste,
    this.hsc_school,
    this.hsc_school_city,
    this.hsc_percentage,
    this.mother_name,
    this.mother_number,
    this.father_number,
    this.pin_code,
    this.is_banned,
    this.appliedJob,
    this.shortlistedJob,
    this.selectedJob,
    this.placedJob,
    this.rejectedJob,
    this.token,
    this.percentage,
    this.Total_lectures,

    this.batch,
    this.passed_out_year,
    this.job_title_from_applied_job,
    this.company_name_from_applied_job,
    this.contact_name_from_applied_job,
    this.job_description_from_applied_job,


    this.job_title_selected_job,
    this.company_name_from_selected_job,
    this.contact_name_from_selected_job,
    this.city_from_selected_job,
    this.job_description_from_selected_job,

    this.company_name_from_placed_job,
    this.job_title_from_placed_job,
    this.job_description_from_placed_job,

    this.company_name_from_rejected_job,
    this.job_title_from_rejected_job,
    this.job_description_from_rejected_job,
    this.semesterByStudent,
    this.presentSemesterByStudent,
    this.absentSemesterByStudent,
    this.resume
  });


  LoginFieldsResponse.fromJson(Map<String, dynamic> json) {

    semesterByStudent = json['semester_by_student'];
    presentSemesterByStudent = json['present_semester_by_student'];
    absentSemesterByStudent = json['absent_semester_by_student'];

    job_title_from_applied_job = json['job_title_from_applied_job']?.cast<String>();
    company_name_from_applied_job = json['company_name_from_applied_job']?.cast<String>();
    contact_name_from_applied_job = json['contact_name_from_applied_job']?.cast<String>();

    job_description_from_applied_job = json['job_description_from_applied_job']?.cast<String>();

    company_name_from_rejected_job = json['company_name_from_rejected_job']?.cast<String>();
    job_title_from_rejected_job = json['job_title_from_rejected_job']?.cast<String>();
    job_description_from_rejected_job = json['job_description_from_rejected_job']?.cast<String>();

    company_name_from_placed_job = json['company_name_from_placed_job']?.cast<String>();
    job_title_from_placed_job = json['job_title_from_placed_job']?.cast<String>();
    job_description_from_placed_job = json['job_description_from_placed_job']?.cast<String>();

    job_title_selected_job = json['job_title_selected_job']?.cast<String>();
    company_name_from_selected_job = json['company_name_from_selected_job']?.cast<String>();
    contact_name_from_selected_job = json['contact_name_from_selected_job']?.cast<String>();
    city_from_selected_job = json['city_from_selected_job']?.cast<String>();
    job_description_from_selected_job = json['job_description_from_selected_job']?.cast<String>();

    job_title_from_applied_job = json['job_title_from_applied_job']?.cast<String>();
    company_name_from_applied_job = json['company_name_from_applied_job']?.cast<String>();
    contact_name_from_applied_job = json['contact_name_from_applied_job']?.cast<String>();
    job_description_from_applied_job = json['job_description_from_applied_job']?.cast<String>();

    lecture_subject_title = json['lecture_subject_title']?.cast<String>();
    city = json['city'];
    joiningYear = json['joining_year'];
    password = json['password'];
    studentId = json['student_id'];
    hubIds = json['hub_ids']?.cast<String>();
    name = json['name'];
    address = json['address'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    specializationIds = json['specialization_ids']?.cast<String>();
    gender = json['gender'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    enrollmentNumber = json['enrollment_number'];
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    specializationIdFromSpecializationIds = json['specialization_id (from specialization_ids)']?.cast<String>();

    Total_lectures = json['Total_lectures'];

    division = json['division'];
    semester = json['semester'];
    lectureIds = json['lecture_ids']?.cast<String>();
    absentLectureIds = json['absent_lecture_ids']?.cast<String>();
    absentLectureDate = json['absent_lecture_date']?.cast<String>();
    absentSubjectTitle = json['absent_subject_title']?.cast<String>();
    absentSubjectId = json['absent_subject_id']?.cast<String>();
    presentLectureIds = json['present_lecture_ids']?.cast<String>();
    presentLectureDate = json['present_lecture_date']?.cast<String>();
    presentSubjectTitle = json['present_subject_title']?.cast<String>();
    presentSubjectId = json['present_subject_id']?.cast<String>();
    lecture_date = json['lecture_date']?.cast<String>();
    lectureSubjectId = json['lecture_subject_id']?.cast<String>();

    sr_number = json['sr_number'];
    birthdate = json['birthdate'];
    aadhar_card_number = json['aadhar_card_number'];
    caste = json['caste'];
    hsc_school = json['hsc_school'];
    hsc_school_city = json['hsc_school_city'];
    hsc_percentage = json['hsc_percentage'];
    mother_name = json['mother_name'];
    mother_number = json['mother_number'];
    father_number = json['father_number'];
    pin_code = json['pin_code'];
    is_banned = json['is_banned_from_placement'];
    batch = json['batch'];
    passed_out_year = json['passed_out_year'];
    appliedJob = json['applied_job']?.cast<String>();
    shortlistedJob = json['shortlisted_job']?.cast<String>();
    selectedJob = json['selected_job']?.cast<String>();
    placedJob = json['placed_job']?.cast<String>();
    rejectedJob = json['rejected_job']?.cast<String>();
    token = json['token'];
    percentage = json['percentage'];
    if (json['resume'] != null) {
      resume = <Attachment_response>[];
      json['resume'].forEach((v) {
        resume!.add(new Attachment_response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['batch'] = this.batch;
    data['passed_out_year'] = this.passed_out_year;
    data['company_name_from_rejected_job'] = this.company_name_from_rejected_job;
    data['job_title_from_rejected_job'] = this.job_title_from_rejected_job;
    data['job_description_from_rejected_job'] = this.job_description_from_rejected_job;
    data['lecture_subject_title'] = this.lecture_subject_title;

    data['company_name_from_placed_job'] = this.company_name_from_placed_job;
    data['job_title_from_placed_job'] = this.job_title_from_placed_job;
    data['job_description_from_placed_job'] = this.job_description_from_placed_job;

    data['job_title_selected_job'] = this.job_title_selected_job;
    data['company_name_from_selected_job'] = this.company_name_from_selected_job;
    data['contact_name_from_selected_job'] = this.contact_name_from_selected_job;
    data['city_from_selected_job'] = this.city_from_selected_job;
    data['job_description_from_selected_job'] = this.job_description_from_selected_job;

    data['semester_by_student'] = this.semesterByStudent;
    data['present_semester_by_student'] = this.presentSemesterByStudent;
    data['absent_semester_by_student'] = this.absentSemesterByStudent;

    data['city'] = this.city;
    data['joining_year'] = this.joiningYear;
    data['password'] = this.password;
    data['student_id'] = this.studentId;
    data['hub_ids'] = this.hubIds;
    data['name'] = this.name;
    data['address'] = this.address;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['specialization_ids'] = this.specializationIds;
    data['gender'] = this.gender;
    data['created_on'] = this.createdOn;
    data['updated_on'] = this.updatedOn;
    data['enrollment_number'] = this.enrollmentNumber;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['specialization_id (from specialization_ids)'] = this.specializationIdFromSpecializationIds;

    data['Total_lectures'] = this.Total_lectures;

    data['division'] = this.division;
    data['semester'] = this.semester;
    data['lecture_ids'] = this.lectureIds;
    data['absent_lecture_ids'] = this.absentLectureIds;
    data['absent_lecture_date'] = this.absentLectureDate;
    data['absent_subject_title'] = this.absentSubjectTitle;
    data['absent_subject_id'] = this.absentSubjectId;
    data['present_lecture_date'] = this.presentLectureDate;
    data['present_subject_title'] = this.presentSubjectTitle;
    data['present_subject_id'] = this.presentSubjectId;
    data['present_lecture_ids'] = this.presentLectureIds;
    data['lecture_date'] = this.lecture_date;
    data['lecture_subject_id'] = this.lectureSubjectId;
    data['percentage'] = this.percentage;
    data['sr_number'] = this.sr_number;
    data['birthdate'] = this.birthdate;
    data['aadhar_card_number'] = this.aadhar_card_number;
    data['caste'] = this.caste;
    data['hsc_school'] = this.hsc_school;
    data['hsc_school_city'] = this.hsc_school_city;
    data['hsc_percentage'] = this.hsc_percentage;
    data['mother_name'] = this.mother_name;
    data['mother_number'] = this.mother_number;
    data['father_number'] = this.father_number;
    data['pin_code'] = this.pin_code;
    data['is_banned_from_placement'] = this.is_banned;

    data['applied_job'] = this.appliedJob;
    data['shortlisted_job'] = this.shortlistedJob;
    data['selected_job'] = this.selectedJob;
    data['placed_job'] = this.placedJob;
    data['rejected_job'] = this.rejectedJob;
    data['token'] = this.token;
    if (this.resume != null) {
      data['resume'] = this.resume!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
