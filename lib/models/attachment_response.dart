class AttachmentResponse {
  String? id;
  String? url;
  String? filename;
  int? size;
  String? type;
  Thumbnails? thumbnails;

  AttachmentResponse(
      {this.id,
      this.url,
      this.filename,
      this.size,
      this.type,
      this.thumbnails});

  AttachmentResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    filename = json['filename'];
    size = json['size'];
    type = json['type'];
    thumbnails = json['thumbnails'] != null
        ? Thumbnails.fromJson(json['thumbnails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['filename'] = filename;
    data['size'] = size;
    data['type'] = type;
    if (thumbnails != null) {
      data['thumbnails'] = thumbnails!.toJson();
    }
    return data;
  }
}

class Thumbnails {
  Small? small;
  Small? large;

  Thumbnails({this.small, this.large});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    small = json['small'] != null ? Small.fromJson(json['small']) : null;
    large = json['large'] != null ? Small.fromJson(json['large']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (small != null) {
      data['small'] = small!.toJson();
    }
    if (large != null) {
      data['large'] = large!.toJson();
    }
    return data;
  }
}

class Small {
  String? url;
  int? width;
  int? height;

  Small({this.url, this.width, this.height});

  Small.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
