class UserModel{
  String id = "";
  String name = "";
  String sex = "";
  double birthday = 0;
  int bornYear = 0;
  double height = 165;
  double weight = 50;
  String address = "";
  String role = "";//user, docter, admin
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
      this.bmi,
      this.bmiText});

  UserModel.fromJson(Map<String, dynamic> json){
    id = json["id"] ?? "";
    name = json["name"] ?? "";
    sex = json["sex"] ?? "";
    birthday = json["birthday"] ?? 0.0;
    bornYear = json["bornYear"] ?? 0;
    height = json["height"] ?? 165;
    weight = json["weight"] ?? 50;
    address = json["address"] ?? "";
    role = json["role"] ?? "";
    avatar = json["avatar"] ?? "";
    email = json["email"] ?? "";
    phone = json["phone"] ?? "";
    password = json["password"] ?? "";
    bmi = json["bmi"] ?? 0.0;
    bmiText = json["bmiText"] ?? "";
  }

  Map<String, dynamic> toMap() {
    return {
      "id" : id ?? "",
      "name" : name ?? "" ,
      "email" : email ?? "" ,
      "password" : password ?? "" ,
      "sex" : sex ?? "" ,
      "birthday" : birthday ?? 0.0 ,
      "bornYear" : bornYear ?? 0 ,
      "height" : height ?? 165 ,
      "weight" : weight ?? 50 ,
      "address" : address ?? "" ,
      "role" : role ?? "user",
      "avatar" : avatar  ?? "",
      "phone" : phone ?? "",
      "bmi" : bmi ?? 0.0,
      "bmiText" : bmiText ?? "",
    };
  }

}
