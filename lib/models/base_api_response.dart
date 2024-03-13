class BaseLoginResponse<T> {
  List<BaseApiResponseWithSerializable<T>>? records;
  String offset = "";

  BaseLoginResponse({this.records});

  BaseLoginResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    if (json['records'] != null) {
      records = <BaseApiResponseWithSerializable<T>>[];
      json['records'].forEach((v) {
        records!.add(BaseApiResponseWithSerializable<T>.fromJson(v, create));
      });
    }
    if (json['offset'] != null && json['offset'].toString().isNotEmpty){
      offset = json['offset'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    return data;
  }
}

class BaseApiResponseWithSerializable<T> {
  String? id;
  String? createdTime;
  T? fields;

  BaseApiResponseWithSerializable({this.id, this.createdTime, this.fields});

  factory BaseApiResponseWithSerializable.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return BaseApiResponseWithSerializable(id: json['id'], createdTime: json['createdTime'], fields: create(json["fields"]));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdTime": createdTime,
        "fields": this.fields,
      };
}

abstract class Serializable {
  Map<String, dynamic> toJson();
}


class BaseResponse<T> {
  List<BaseApiResponseWithSerializable<T>>? records;
  String offset = "";

  BaseResponse({this.records});

  BaseResponse.fromJson(Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    if (json['records'] != null) {
      records = <BaseApiResponseWithSerializable<T>>[];
      json['records'].forEach((v) {
        records!.add(BaseApiResponseWithSerializable<T>.fromJson(v, create));
      });
    }
    if (json['offset'] != null && json['offset'].toString().isNotEmpty){
      offset = json['offset'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    return data;
  }
}
