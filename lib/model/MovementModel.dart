class MovementModel{
  String idMovement = "";
  String name = "";
  String detail = "";//Chi tiết thực hiện động tác
  double caloLost100g = 0;// Số calo tiêu thu khi thực hiện 1 động tác này.
  String imageDetail = "";// Hình ảnh, video dùng để tham khảo.
  int priority = 0; //0=mất ít calo. ... 5=Tiêu thụ cực nhiều calo.
  String type = "";//Thân trên, thân dưới, bụng, cánh tay...
  String link="";//liên kết để hướng dẫn động tác.
  int quantity=0;
  String donvi = "";

  MovementModel({
      this.idMovement,
      this.name,
      this.detail,
      this.caloLost100g,
      this.imageDetail,
      this.priority,
      this.type,
      this.link,
      this.quantity,
      this.donvi});

  MovementModel.fromJson(Map<String, dynamic> json){
    idMovement = json["idMovement"] ?? "";
    name = json["name"] ?? "";
    type = json["type"] ?? "";
    detail = json["detail"] ?? "";
    caloLost100g = double.parse(json["caloLost100g"].toString()) ?? 0.0;
    priority = json["priority"]  ?? 0;
    imageDetail = json["imageDetail"]  ?? "";
    quantity = json["quantity"] ?? 0;
    link = json["link"] ?? "";
    donvi = json ["donvi"] ?? "";
  }

  Map<String, dynamic> toMap() {
    return {
      "idMovement" : idMovement ?? "",
      "name" : name ?? "",
      "detail" : detail ?? "",
      "caloLost100g" : caloLost100g ?? 0.0,
      "imageDetail" : imageDetail ?? "",
      "priority" : priority ?? 0,
      "type" : type ?? "",
      "link" : link ?? "",
      "quantity" : quantity ?? 0,
      "donvi" : donvi
    };
  }
}