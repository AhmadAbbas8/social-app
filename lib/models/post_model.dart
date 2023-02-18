class PostModel {
  String? name, uId, image, date, txt, postImage;

  PostModel({
    this.image,
    this.name,
    this.uId,
    this.date,
    this.txt,
    this.postImage,
  });

  PostModel.fromJson({required Map<String, dynamic> json}) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    date = json['date'];
    txt = json['txt'];
    postImage = json['postImage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'postImage': postImage,
      'txt': txt,
      'date': date,
    };
  }
}
