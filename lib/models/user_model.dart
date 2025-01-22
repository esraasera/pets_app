class UserModel{
  String name ;
  String email;
  String uId;

  UserModel({
    required this.name,
    required this.email,
    required this.uId,
  });

  factory UserModel.fromJson(Map<String,dynamic>json)=>UserModel(
    name: json['name']??'',
    email: json['email']??'',
    uId: json['uId']??'',
  );

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'uId':uId,
    };
  }
}