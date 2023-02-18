class UserModel {
  String? name, phone, email, uId ,image,bio,coverImage;
bool?  isEmailVerified ;
  UserModel({
    this.email,
    this.name,
    this.phone,

    this.uId,
    this.isEmailVerified,
    this.image,
    this.bio,
    this.coverImage
  });

  UserModel.fromJson({required Map<String, dynamic> json}) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    bio = json['bio'];
    coverImage= json['coverImage'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'uId': uId,
      'image': image,
      'bio': bio,
      'coverImage':coverImage,
      'isEmailVerified':isEmailVerified,
    };
  }


}
