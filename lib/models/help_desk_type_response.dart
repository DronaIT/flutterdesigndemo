class HelpDeskTypeResponse {
  int? id;
  String? title;
  //List<String>? tBLHELPDESK;

  HelpDeskTypeResponse({this.id, this.title,});

  HelpDeskTypeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
   // tBLHELPDESK = json['TBL_HELPDESK'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    //data['TBL_HELPDESK'] = this.tBLHELPDESK;
    return data;
  }
}
