class PetModel{
  String? name ;
  String? age;
  String image;
  String? gender;
  String? kind;
  String? dateTime;
  String? id ;

  PetModel({
    required this.name,
    required this.id,
    this.age,
    required this.image,
    this.gender,
    this.kind,
    this.dateTime,
  });

  PetModel copyWith({
    String? image,
    String? name,
    String? age,
    String? gender,
    String? kind,
    String? dateTime,
    String? id,
  }) {
    return PetModel(
      image: image ?? this.image,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      kind: kind ?? this.kind,
      dateTime: dateTime ?? this.dateTime,
      id: id ?? this.id,
    );
  }

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
    name: json['name'] ?? '',
    age: json['age'] ?? '',
    id: json['id'] ?? '',
    gender: json['gender'] ?? '',
    kind: json['kind'] ?? '',
    dateTime: json['dateTime'] ?? '',
    image: json['image'] ??
        'https://img.freepik.com/premium-vector/cartoon-dog-with-happy-expression-its-face_1249027-448.jpg?w=740',
  );


  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'age':age,
      'id':id,
      'image':image,
      'gender':gender,
      'dateTime':dateTime,
      'kind':kind,
    };
  }
}