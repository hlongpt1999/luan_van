class UserModel{
  String id = "";
  String name = "";
  String sex = "";
  double birthday = 0;
  int bornYear = 0;
  double height = 0;
  double weight = 0;
  String address = "";
  String role = "";
  String avatar = "";
  String email = "";
  String phone = "";
  String password = "";
  double bmi = 0;
  String bmiText = "Ổn định";

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
      this.password,
      this.bmi});

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
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
      "phone" : phone,
      "bmi" : bmi,
      "bmiText" : bmiText,
    };
  }

}
