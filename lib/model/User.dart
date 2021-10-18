class UserModel{
  String id;
  String name;
  String sex;
  double birthday;
  int bornYear;
  double height;
  double weight;
  String address;
  String role;
  String avatar;
  String email;
  String phone;
  String password;

  UserModel({
      this.id,
      this.name,
      this.sex,
      this.birthday,
      this.bornYear,
      this.height,
      this.weight,
      this.address,
      this.role,
      this.avatar,
      this.email,
      this.phone,
      this.password});

  Map<String, dynamic> toMap() {
    return {
      "name" : name ,
      "email" : email ,
      "password" : password ,
      "sex" : sex ,
      "birthday" : birthday ,
      "bornYear" : bornYear ,
      "height" : height ,
      "weight" : weight ,
      "adress" : address ,
      "role" : role ?? "user",
      "avatar" : avatar ,
      "phone" : phone
    };
  }

}
