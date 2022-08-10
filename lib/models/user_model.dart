class UserModel {
  String uid;
  String email;
  String name;
  String? photoUrl;

  UserModel({required this.uid,required this.email,required this.name, this.photoUrl});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['firstName'] + ' ' + map['secondName'],
      photoUrl: map['photo']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}