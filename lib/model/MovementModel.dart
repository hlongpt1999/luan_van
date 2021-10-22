class MovementModel{
  String idMovement = "";
  String name = "";
  String detail = "";//Chi tiết thực hiện động tác
  double caloLost100g = 0;// Số calo tiêu thu khi thực hiện 1 động tác này.
  String imageDetail = "";// Hình ảnh, video dùng để tham khảo.
  int priority = 0; //0=mất ít calo. ... 5=Tiêu thụ cực nhiều calo.
  String type = "";//Thân trên, thân dưới, bụng, cánh tay...

  MovementModel({
      this.idMovement,
      this.name,
      this.detail,
      this.caloLost100g,
      this.imageDetail,
      this.priority,
      this.type});

  Map<String, dynamic> toMap() {
    return {
      "idMovement" : idMovement,
      "name" : name,
      "detail" : detail,
      "caloLost100g" : caloLost100g,
      "imageDetail" : imageDetail,
      "priority" : priority,
      "type" : type,
    };
  }
}