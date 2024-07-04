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
  List<String>? lecture_time;
  List<String>? employee_name;
  List<String>? lectureSubjectId;
  List<String>? lecture_subject_title;
  List<String>? lecture_specialization_id;
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

  List<String>? placement_attendance_form;
  List<String>? appliedJob;
  List<String>? shortlistedJob;
  List<String>? selectedJob;
  List<String>? placedJob;
  List<String>? rejectedJob;
  List<int>? isSelfPlacedCurrently;

  List<String>? job_title_selected_job;
  List<String>? company_name_from_selected_job;
  List<String>? contact_name_from_selected_job;
  List<String>? city_from_selected_job;
  List<String>? job_description_from_selected_job;

  List<String>? company_name_from_placed_job;
  List<String>? job_title_from_placed_job;
  List<String>? job_description_from_placed_job;
  List<String>? placed_job_code;

  List<String>? job_title_from_rejected_job;
  List<String>? company_name_from_rejected_job;
  List<String>? job_description_from_rejected_job;

  List<String>? job_title_from_applied_job;
  List<String>? company_name_from_applied_job;
  List<String>? contact_name_from_applied_job;
  List<String>? job_description_from_applied_job;

  List<String>? self_place_company;
  List<String>? self_place_company_code;
  List<String>? self_place_company_name;
  List<String>? applied_self_place_job;
  List<String>? applied_self_place_job_title;
  List<String>? placed_self_place_job;
  List<String>? placed_self_place_job_title;
  List<String>? self_place_company_status;

  String? token;
  String? warning_letter_1_for_applying;
  String? warning_letter_2_for_applying;
  String? warning_letter_3_for_applying;
  String? warning_letter_1_for_appearing;
  String? warning_letter_2_for_appearing;
  String? warning_letter_3_for_appearing;

  List<String>? semesterByStudent;
  List<String>? presentSemesterByStudent;
  List<String>? absentSemesterByStudent;
  List<String>? present_specialization_id;
  List<String>? absent_specialization_id;
  int? Total_lectures;

  List<String>? admission_batch_start;
  List<String>? admission_batch_end;
  List<String>? last_company_name;

  List<AttachmentResponse>? resume;
  List<AttachmentResponse>? profile_pic;
  String? father_full_name;
  String? is_placed_now;
  int? has_resigned;
  bool selected = false;
  int totalJobsCame = 0;
  int missedToApply = 0;
  int missedToAppearForInterview = 0;

  List<String>? assigned_to;
  List<String>? assigned_to_employee_name;

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
    this.lecture_time,
    this.employee_name,
    this.lectureSubjectId,
    this.lecture_subject_title,
    this.lecture_specialization_id,
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
    this.placement_attendance_form,
    this.appliedJob,
    this.shortlistedJob,
    this.selectedJob,
    this.placedJob,
    this.rejectedJob,
    this.isSelfPlacedCurrently,
    this.token,
    this.percentage,
    this.Total_lectures,
    this.batch,
    this.passed_out_year,
    this.job_title_from_applied_job,
    this.company_name_from_applied_job,
    this.contact_name_from_applied_job,
    this.job_description_from_applied_job,
    this.self_place_company,
    this.self_place_company_code,
    this.self_place_company_name,
    this.applied_self_place_job,
    this.applied_self_place_job_title,
    this.placed_self_place_job,
    this.placed_self_place_job_title,
    this.self_place_company_status,
    this.job_title_selected_job,
    this.company_name_from_selected_job,
    this.contact_name_from_selected_job,
    this.city_from_selected_job,
    this.job_description_from_selected_job,
    this.company_name_from_placed_job,
    this.job_title_from_placed_job,
    this.job_description_from_placed_job,
    this.placed_job_code,
    this.company_name_from_rejected_job,
    this.job_title_from_rejected_job,
    this.job_description_from_rejected_job,
    this.semesterByStudent,
    this.presentSemesterByStudent,
    this.absentSemesterByStudent,
    this.present_specialization_id,
    this.absent_specialization_id,
    this.admission_batch_start,
    this.admission_batch_end,
    this.last_company_name,
    this.resume,
    this.profile_pic,
    this.father_full_name,
    this.is_placed_now,
    this.has_resigned,
    this.warning_letter_1_for_appearing,
    this.warning_letter_2_for_appearing,
    this.warning_letter_3_for_appearing,
    this.warning_letter_1_for_applying,
    this.warning_letter_2_for_applying,
    this.warning_letter_3_for_applying,
    this.assigned_to,
    this.assigned_to_employee_name,
  });

  LoginFieldsResponse.fromJson(Map<String, dynamic> json) {
    semesterByStudent = json['semester_by_student']?.cast<String>();
    presentSemesterByStudent = json['present_semester_by_student']?.cast<String>();
    absentSemesterByStudent = json['absent_semester_by_student']?.cast<String>();
    present_specialization_id = json['present_specialization_id']?.cast<String>();
    absent_specialization_id = json['absent_specialization_id']?.cast<String>();

    admission_batch_start = json['admission_batch_start']?.cast<String>();
    admission_batch_end = json['admission_batch_end']?.cast<String>();
    last_company_name = json['last_company_name']?.cast<String>();

    job_title_from_applied_job = json['job_title_from_applied_job']?.cast<String>();
    company_name_from_applied_job = json['company_name_from_applied_job']?.cast<String>();
    contact_name_from_applied_job = json['contact_name_from_applied_job']?.cast<String>();

    company_name_from_rejected_job = json['company_name_from_rejected_job']?.cast<String>();
    job_title_from_rejected_job = json['job_title_from_rejected_job']?.cast<String>();
    job_description_from_rejected_job = json['job_description_from_rejected_job']?.cast<String>();

    company_name_from_placed_job = json['company_name_from_placed_job']?.cast<String>();
    job_title_from_placed_job = json['job_title_from_placed_job']?.cast<String>();
    job_description_from_placed_job = json['job_description_from_placed_job']?.cast<String>();
    placed_job_code = json['placed_job_code']?.cast<String>();

    job_title_selected_job = json['job_title_selected_job']?.cast<String>();
    company_name_from_selected_job = json['company_name_from_selected_job']?.cast<String>();
    contact_name_from_selected_job = json['contact_name_from_selected_job']?.cast<String>();
    city_from_selected_job = json['city_from_selected_job']?.cast<String>();
    job_description_from_selected_job = json['job_description_from_selected_job']?.cast<String>();

    job_title_from_applied_job = json['job_title_from_applied_job']?.cast<String>();
    company_name_from_applied_job = json['company_name_from_applied_job']?.cast<String>();
    contact_name_from_applied_job = json['contact_name_from_applied_job']?.cast<String>();
    job_description_from_applied_job = json['job_description_from_applied_job']?.cast<String>();

    self_place_company = json['self_place_company']?.cast<String>();
    self_place_company_code = json['self_place_company_code']?.cast<String>();
    self_place_company_name = json['self_place_company_name']?.cast<String>();
    applied_self_place_job = json['applied_self_place_job']?.cast<String>();
    applied_self_place_job_title = json['applied_self_place_job_title']?.cast<String>();
    placed_self_place_job = json['placed_self_place_job']?.cast<String>();
    placed_self_place_job_title = json['placed_self_place_job_title']?.cast<String>();
    self_place_company_status = json['self_place_company_status']?.cast<String>();

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
    lecture_time = json['lecture_time']?.cast<String>();
    employee_name = json['employee_name']?.cast<String>();
    lectureSubjectId = json['lecture_subject_id']?.cast<String>();
    lecture_specialization_id = json['lecture_specialization_id']?.cast<String>();

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
    placement_attendance_form = json['placement_attendance_form']?.cast<String>();
    appliedJob = json['applied_job']?.cast<String>();
    shortlistedJob = json['shortlisted_job']?.cast<String>();
    selectedJob = json['selected_job']?.cast<String>();
    placedJob = json['placed_job']?.cast<String>();
    rejectedJob = json['rejected_job']?.cast<String>();
    isSelfPlacedCurrently = json['is_self_placed_currently']?.cast<int>();
    token = json['token'];
    warning_letter_1_for_applying = json['warning_letter_1_for_applying'];
    warning_letter_2_for_applying = json['warning_letter_2_for_applying'];
    warning_letter_3_for_applying = json['warning_letter_3_for_applying'];
    warning_letter_1_for_appearing = json['warning_letter_1_for_appearing'];
    warning_letter_2_for_appearing = json['warning_letter_2_for_appearing'];
    warning_letter_3_for_appearing = json['warning_letter_3_for_appearing'];

    father_full_name = json['father_full_name'];
    percentage = json['percentage'];
    is_placed_now = json['is_placed_now'];
    has_resigned = json['has_resigned'];

    assigned_to = json['assigned_to']?.cast<String>();
    assigned_to_employee_name = json['assigned_to_employee_name']?.cast<String>();

    if (json['resume'] != null) {
      resume = <AttachmentResponse>[];
      json['resume'].forEach((v) {
        resume!.add(AttachmentResponse.fromJson(v));
      });
    }
    if (json['profile_pic'] != null) {
      profile_pic = <AttachmentResponse>[];
      json['profile_pic'].forEach((v) {
        profile_pic!.add(AttachmentResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['batch'] = batch;
    data['passed_out_year'] = passed_out_year;
    data['company_name_from_rejected_job'] = company_name_from_rejected_job;
    data['job_title_from_rejected_job'] = job_title_from_rejected_job;
    data['job_description_from_rejected_job'] = job_description_from_rejected_job;
    data['lecture_subject_title'] = lecture_subject_title;

    data['company_name_from_placed_job'] = company_name_from_placed_job;
    data['job_title_from_placed_job'] = job_title_from_placed_job;
    data['job_description_from_placed_job'] = job_description_from_placed_job;
    data['placed_job_code'] = placed_job_code;

    data['job_title_selected_job'] = job_title_selected_job;
    data['company_name_from_selected_job'] = company_name_from_selected_job;
    data['contact_name_from_selected_job'] = contact_name_from_selected_job;
    data['city_from_selected_job'] = city_from_selected_job;
    data['job_description_from_selected_job'] = job_description_from_selected_job;
    data['job_description_from_applied_job'] = job_description_from_applied_job;

    data['self_place_company'] = self_place_company;
    data['self_place_company_code'] = self_place_company_code;
    data['self_place_company_name'] = self_place_company_name;
    data['applied_self_place_job'] = applied_self_place_job;
    data['applied_self_place_job_title'] = applied_self_place_job_title;
    data['placed_self_place_job'] = placed_self_place_job;
    data['placed_self_place_job_title'] = placed_self_place_job_title;
    data['self_place_company_status'] = self_place_company_status;

    data['semester_by_student'] = semesterByStudent;
    data['present_semester_by_student'] = presentSemesterByStudent;
    data['absent_semester_by_student'] = absentSemesterByStudent;
    data['present_specialization_id'] = present_specialization_id;
    data['absent_specialization_id'] = absent_specialization_id;

    data['city'] = city;
    data['joining_year'] = joiningYear;
    data['password'] = password;
    data['student_id'] = studentId;
    data['hub_ids'] = hubIds;
    data['name'] = name;
    data['address'] = address;
    data['mobile_number'] = mobileNumber;
    data['email'] = email;
    data['specialization_ids'] = specializationIds;
    data['gender'] = gender;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['enrollment_number'] = enrollmentNumber;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['specialization_id (from specialization_ids)'] = specializationIdFromSpecializationIds;

    data['Total_lectures'] = Total_lectures;

    data['division'] = division;
    data['semester'] = semester;
    data['lecture_ids'] = lectureIds;
    data['absent_lecture_ids'] = absentLectureIds;
    data['absent_lecture_date'] = absentLectureDate;
    data['absent_subject_title'] = absentSubjectTitle;
    data['absent_subject_id'] = absentSubjectId;
    data['present_lecture_date'] = presentLectureDate;
    data['present_subject_title'] = presentSubjectTitle;
    data['present_subject_id'] = presentSubjectId;
    data['present_lecture_ids'] = presentLectureIds;
    data['lecture_date'] = lecture_date;
    data['lecture_time'] = lecture_time;
    data['employee_name'] = employee_name;
    data['lecture_subject_id'] = lectureSubjectId;
    data['lecture_specialization_id'] = lecture_specialization_id;
    data['percentage'] = percentage;
    data['sr_number'] = sr_number;
    data['birthdate'] = birthdate;
    data['aadhar_card_number'] = aadhar_card_number;
    data['caste'] = caste;
    data['hsc_school'] = hsc_school;
    data['hsc_school_city'] = hsc_school_city;
    data['hsc_percentage'] = hsc_percentage;
    data['mother_name'] = mother_name;
    data['mother_number'] = mother_number;
    data['father_number'] = father_number;
    data['pin_code'] = pin_code;
    data['is_banned_from_placement'] = is_banned;

    data['admission_batch_start'] = admission_batch_start;
    data['admission_batch_end'] = admission_batch_end;
    data['last_company_name'] = last_company_name;

    data['placement_attendance_form'] = placement_attendance_form;
    data['applied_job'] = appliedJob;
    data['shortlisted_job'] = shortlistedJob;
    data['selected_job'] = selectedJob;
    data['placed_job'] = placedJob;
    data['rejected_job'] = rejectedJob;
    data['is_self_placed_currently'] = isSelfPlacedCurrently;
    data['token'] = token;

    data['warning_letter_1_for_applying'] = warning_letter_1_for_applying;
    data['warning_letter_2_for_applying'] = warning_letter_2_for_applying;
    data['warning_letter_3_for_applying'] = warning_letter_3_for_applying;
    data['warning_letter_1_for_appearing'] = warning_letter_1_for_appearing;
    data['warning_letter_2_for_appearing'] = warning_letter_2_for_appearing;
    data['warning_letter_3_for_appearing'] = warning_letter_3_for_appearing;

    data['father_full_name'] = father_full_name;
    data['is_placed_now'] = is_placed_now;
    data['has_resigned'] = has_resigned;
    data['assigned_to'] = assigned_to;
    data['assigned_to_employee_name'] = assigned_to_employee_name;

    if (resume != null) {
      data['resume'] = resume!.map((v) => v.toJson()).toList();
    }
    if (profile_pic != null) {
      data['profile_pic'] = profile_pic!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
