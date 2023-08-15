class TableNames {
  static const APIENDPOINTS = "https://api.airtable.com/v0/appv5323SIrE230U9/";
  static const APIKEY = "key5iHhi8YUs0mRRJ";
  static const PROJECTBASE = "appv5323SIrE230U9";

  // Kaleyra keys
  static const KALEYRA_APIKEY = "";
  static const KALEYRA_SENDER = "DFBVOC";
  static const TEMPLATE_ID_SIGNUP = "1007956316471143887";
  static const TEMPLATE_ID_FORGOT_PASSWORD = "1007956316471143887";

  static const CLOUDARY_CLOUD_NAME = "diz8xhbjv";
  static const CLOUDARY_PRESET = "kgicun2o";
  static const CLOUDARY_FOLDER_COMPANY_LOGO = "CompanyLogo";
  static const CLOUDARY_FOLDER_COMPANY_LOI = "CompanyLOI";
  static const CLOUDARY_FOLDER_HELP_DESK= "HelpDesk";
  static const CLOUDARY_FOLDER_COMPANY_LOC = "CompanyLOC";
  static const CLOUDARY_FOLDER_APP_ASSETS = "AppAssets";
  static const CLOUDARY_FOLDER_STUDENT_RESUME = "student_resume";
  static const CLOUDARY_FOLDER_COMPANY_BONDS = "CompanyBonds";
  static const CLOUDARY_FOLDER_PLACEMENT_ATTENDANCE = "PlacementAttendance";
  static const CLOUDARY_FOLDER_COMPANY_INCENTIVE_STRUCTURE = "CompanyIncentiveStructure";
  static const CLOUDARY_FOLDER_ANNOUNCEMENT = "Announcement";

  static const STUDENT_ROLE_ID = "DR09";
  static const ORGANIZATION_ROLE_ID = "DR24";
  static const FACULTY_ROLE_ID = "DR05";

  static const MODULE_MANAGE_USER = "DM01";
  static const MODULE_SETUP_COLLAGE = "DM02";
  static const MODULE_ACADEMIC_DETAIL = "DM05";
  static const MODULE_ATTENDANCE = "DM03";
  static const MODULE_PLACEMENT = "DM04";
  static const MODULE_UPLOAD_DOCUMENT = "DM06";
  static const MODULE_STUDENT_DIRECTORY = "DM07";
  static const MODULE_HELP_DESK = "DM08";
  static const MODULE_TASK = "DM09";
  static const MODULE_ANNOUNCEMENT = "DM10";
  static const MODULE_TIME_TABLE = "DM11";

  static const DIVISION_A = "Class A";
  static const DIVISION_B = "Class B";
  static const DIVISION_C = "Class C";
  static const DIVISION_D = "Class D";

  static const TASK_IMPORTANCE_HIGH = "High";
  static const TASK_IMPORTANCE_MEDIUM = "Medium";
  static const TASK_IMPORTANCE_LOW = "Low";

  static const PLACED = "Placed";
  static const UNPLACED = "UnPlaced";

  static const ONE_HOUR = "1 Hour";
  static const TWO_HOUR = "2 Hour";

  static const TB_STUDENT = "TBL_STUDENT";
  static const TBL_MODULE = "TBL_MODULE";
  static const TBL_ROLE = "TBL_ROLE";
  static const TBL_HUB = "TBL_HUB_CENTER";
  static const TBL_SPECIALIZATION = "TBL_SPECIALIZATION";
  static const TBL_EMPLOYEE = "TBL_EMPLOYEE";
  static const TBL_PERMISSION = "TBL_PERMISSION";
  static const TBL_SUBJECT = "TBL_SUBJECT";
  static const TBL_UNITS = "TBL_UNITS";
  static const TBL_TOPICS = "TBL_TOPICS";
  static const TBL_STUDENT_ATTENDANCE = "TBL_STUDENT_ATTENDANCE";
  static const TBL_SECTOR = "TBL_SECTORS";
  static const TBL_COMPANY_APPROACH = "TBL_COMPANY_APPROACH";
  static const TBL_COMPANY_DETAIL = "TBL_COMPANY";
  static const TBL_JOBS = "TBL_JOBS";
  static const TBL_PLACEMENT_ATTENDANCE = "TBL_PLACEMENT_ATTENDANCE";
  static const TBL_APP_TRACKING = "TBL_APP_TRACKING";
  static const TBL_APP_DATA = "TBL_APP_DATA";
  static const TBL_HELPDESK_TYPE = "TBL_HELPDESK_TYPE";
  static const TBL_HELPDESK = "TBL_HELPDESK";
  static const TBL_ANNOUNCEMENT = "TBL_ANNOUNCEMENT";
  static const TBL_TIMETABLE = "TBL_TIMETABLE";

  static const TB_USERS_PHONE = "mobile_number";
  static const TB_USERS_ENROLLMENT = "enrollment_number";
  static const TB_USERS_PASSWORD = "password";
  static const CLM_ROLE_ID = "role_ids";
  static const CLM_HUB_IDS = "hub_ids";
  static const CLM_HUB_IDS_FROM_HUB_ID = "hub_id (from hub_ids)";
  static const CLM_HUB_ID = "hub_id";

  static const CLM_SPE_ID = "specialization_id";
  static const CLM_SPE_IDS = "specialization_ids";
  static const CLM_SPE_IDS_FROM_SPE_ID = "specialization_name (from specialization_ids)";
  static const CLM_SUBJECT_IDS = "subject_ids";
  static const CLM_COMPANY_CODE = "company_code";
  static const CLM_JOB_CODE = "job_code";

  static const CLM_SUBJECT_ID = "subject_id";
  static const CLM_UNIT_ID = "unit_id";
  static const CLM_UNIT_IDS = "unit_ids";
  static const CLM_TOPIC_ID = "topic_id";
  static const CLM_SEMESTER = "semester";
  static const CLM_DIVISION = "division";
  static const CLM_ENROLLMENT_NUMBERS = "enrollment_numbers";
  static const CLM_MOTHER_NUMBER = "mother_numbers";
  static const CLM_FATHER_NUMBERS = "father_numbers";
  static const CLM_COMPANY_ID = "company_id";
  static const CLM_STATUS = "status";
  /*
      0 => Job apply time is yet to come (Now < start time)
      1 => Job apply time is running (start time < Now < end time)
      2 => Job apply time is over (end time < Now)
  */
  static const CLM_DISPLAY_INTERNSHIP = "display_internship";
  static const CLM_APPLIED_STUDENTS = "applied_students";
  static const CLM_SHORT_LISTED_STUDENTS = "shortlisted_students";
  static const CLM_SELECTED_STUDENTS = "selected_students";

  static const CLM_APPLIED_JOB = "applied_job";
  static const CLM_PLACED_JOB = "placed_job";
  static const CLM_REJECTED_JOB = "rejected_job";
  static const CLM_BANNED_FROM_PLACEMENT = "is_banned_from_placement";

  static const CLM_PRESENT_SUBJECT_IDS = "present_subject_id";
  static const CLM_ABSENT_SUBJECT_IDS = "absent_subject_id";

  static const CLM_ASSIGNED_TO = "assigned_to";
  static const CLM_ASSIGNED_NUMBER = "assigned_mobile_number";
  static const CLM_AUTHORITY_OF = "authority_of";
  static const CLM_AUTHORITY_OF_NUMBER = "authority_mobile_number";
  static const CLM_CREATED_BY_EMPLOYEE = "created_by_employee";
  static const CLM_CREATED_BY_EMPLOYEE_NUMBER = "employee_mobile_number";
  static const CLM_CREATED_BY_STUDENT = "created_by_student";
  static const CLM_CREATED_BY_ORGANIZATION = "created_by_organization";
  static const CLM_FIELD_TYPE = "field_type";
  static const CLM_TICKET_STATUS = "Status";

  static const CLM_STUDENT_HUBNAME = "student_hub_name";
  static const CLM_STUDENT_SPENAME = "student_specialization_name";
  static const CLM_STUDENT_SEMESTER = "student_semester";
  static const CLM_STUDENT_DIVISION = "student_division";
  static const CLM_TICKET_TYPEID = "ticket_type_id";

  static const PERMISSION_ID_ADD_EMPLOYEE = "DP0101";
  static const PERMISSION_ID_UPDATE_EMPLOYEE = "DP0102";
  static const PERMISSION_ID_VIEW_EMPLOYEE = "DP0103";
  static const PERMISSION_ID_ADD_STUDENT = "DP0104";
  static const PERMISSION_ID_VIEW_STUDENT = "DP0105";
  static const PERMISSION_ID_UPDATE_STUDENT = "DP0106";

  static const PERMISSION_ID_ADD_HUB = "DP0201";
  static const PERMISSION_ID_UPDATE_HUB = "DP0202";
  static const PERMISSION_ID_VIEW_HUB = "DP0203";

  static const PERMISSION_ID_ADD_SPECILIZATION = "DP0501";
  static const PERMISSION_ID_UPDATE_SPECILIZATION = "DP0502";
  static const PERMISSION_ID_VIEW_SPECILIZATION = "DP0503";

  static const PERMISSION_ID_ADD_SUBJECT = "DP0504";
  static const PERMISSION_ID_UPDATE_SUBJECT = "DP0506";
  static const PERMISSION_ID_VIEW_SUBJECT = "DP0505";

  static const PERMISSION_ID_TAKE_ATTENDANCE = "DP0301";
  static const PERMISSION_ID_VIEWSELF_ATTENDANCE = "DP0302";
  static const PERMISSION_ID_VIEW_OTHERS_ATTENDANCE = "DP0303";
  static const PERMISSION_ID_VIEW_ACCESSIBLE_ATTENDANCE = "DP0304";
  static const PERMISSION_ID_UPDATE_ACCESSIBLE_ATTENDANCE = "DP0305";
  static const PERMISSION_ID_ATTENDANCE_REPORTS = "DP0306";

  static const PERMISSION_ID_COMPANY_APPROCH = "DP0401";
  static const PERMISSION_ID_CREATE_COMPANY = "DP0402";
  static const PERMISSION_ID_JOBALERTS = "DP0403";
  static const PERMISSION_ID_APPLY_INTERNSHIP = "DP0404";
  static const PERMISSION_ID_UPDATE_INTERNSHIP = "DP0405";

  static const PERMISSION_ID_GET_COMPANY_DETAIL = "DP0406";
  static const PERMISSION_ID_EDIT_COMPANY_DETAIL = "DP0407";
  static const PERMISSION_ID_VIEWJOBS = "DP0408";
  static const PERMISSION_ID_EDITJOBS = "DP0409";
  static const PERMISSION_ID_PUBLISHED_INTERSHIP = "DP0412";
  static const PERMISSION_ID_APPROVED_INTERSHIP = "DP0411";
  static const PERMISSION_ID_SHORTlIST_STUDENTS = "DP0413";
  static const PERMISSION_ID_SELECTED_STUDENT = "DP0415";
  static const PERMISSION_ID_APPLIED_INTERNSHIP = "DP0416";
  static const PERMISSION_ID_SHORT_LISTED_INTERNSHIP = "DP0417";
  static const PERMISSION_ID_SELECTED_INTERNSHIP = "DP0418";
  static const PERMISSION_ID_COMPLETED_INTERNSHIP = "DP0419";
  static const PERMISSION_ID_UPLOAD_RESUME = "DP0420";
  static const PERMISSION_ID_PLACED_UNPLACED_STUDENT_LIST = "DP0421";

  static const PERMISSION_ID_VIEW_RESUME = "DP0421";
  static const PERMISSION_ID_VIEW_DOCUMENTS = "DP0602";
  static const PERMISSION_ID_UPLOAD_DOCUMENTS = "DP0601";

  static const PERMISSION_ID_VIEW_STUDENT_DIRECTORY = "DP0701";

  static const PERMISSION_ID_VIEW_OTHER_TICKET = "DP0801";
  static const PERMISSION_ID_UPDATE_TICKET_STATUS = "DP0802";
  static const PERMISSION_ID_UPDATE_TICKET_CATEGORY = "DP0803";

  static const PERMISSION_ID_VIEW_ANNOUNCEMENT = "DP1001";
  static const PERMISSION_ID_ADD_ANNOUNCEMENT = "DP1002";
  static const PERMISSION_ID_UPDATE_ANNOUNCEMENT = "DP1003";

  static const PERMISSION_ID_VIEW_TIME_TABLE = "DP1101";
  static const PERMISSION_ID_ADD_TIME_TABLE = "DP1102";
  static const PERMISSION_ID_UPDATE_TIME_TABLE = "DP1103";
  static const PERMISSION_ID_VIEW_ALL_TIME_TABLE = "DP1104";

  static const EXCEL_COL_NAME = "name";
  static const EXCEL_COL_MOBILE_NUMBER = "mobile_number";
  static const EXCEL_COL_GENDER = "gender";
  static const EXCEL_COL_CITY = "city";
  static const EXCEL_COL_ADDRESS = "address";
  static const EXCEL_COL_PIN_CODE = "pin_code";
  static const EXCEL_COL_HUB_IDS = "hub_ids";
  static const EXCEL_COL_SPECIALIZATION_IDS = "specialization_ids";
  static const EXCEL_COL_JOINING_YEAR = "joining_year";
  static const EXCEL_COL_EMAIL = "email";
  static const EXCEL_COL_SEMESTER = "semester";
  static const EXCEL_COL_DIVISION = "division";
  static const EXCEL_COL_SR_NUMBER = "sr_number";
  static const EXCEL_COL_BIRTHDATE = "birthdate(dd/mm/yyyy)";
  static const EXCEL_COL_AADHAR_CARD_NUMBER = "aadhar_card_number";
  static const EXCEL_COL_CASTE = "caste";
  static const EXCEL_COL_HSC_SCHOOL = "hsc_school";
  static const EXCEL_COL_HSC_SCHOOL_CITY = "hsc_school_city";
  static const EXCEL_COL_HSC_PERCENTAGE = "hsc_percentage";
  static const EXCEL_COL_MOTHER_NAME = "mother_name";
  static const EXCEL_COL_MOTHER_NUMBER = "mother_number";
  static const EXCEL_COL_FATHER_NUMBER = "father_number";
  static const EXCEL_COL_BATCH = "batch(20xx-xx)";
  static const APPDATA_TITLE= "Student upload format";

  static const LOGIN_ROLE_EMPLOYEE = "Employee";
  static const LOGIN_ROLE_STUDENT = "Student";
  static const LOGIN_ROLE_ORGANIZATION = "Organization";

  static const ANNOUNCEMENT_ROLE_EMPLOYEE = "employee";
  static const ANNOUNCEMENT_ROLE_STUDENT = "student";
  static const ANNOUNCEMENT_ROLE_ORGANIZATION = "organization";

  static const TB_CONTACT_NUMBER = "contact_number";

  static const TICKET_STATUS_OPEN = "Open";
  static const TICKET_STATUS_INPROGRESS = "In Progress";
  static const TICKET_STATUS_HOLD = "Hold";
  static const TICKET_STATUS_RESOLVED = "Resolved";
  static const TICKET_STATUS_SUGGESTION = "Suggestions";
  static const TICKET_STATUS_COMPLETED = "Completed";

  static const HELPDESK_TYPE_TICKET = "ticket";
  static const HELPDESK_TYPE_TASK = "task";

  static const TIMETABLE_MODE_STATUS_ONLINE = "online";

  static const LUK_ADD_TIME_TABLE = "addTimeTable";
  static const LUK_UPDATE_TIME_TABLE = "updateTimeTable";
}
