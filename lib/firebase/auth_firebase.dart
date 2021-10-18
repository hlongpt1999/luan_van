// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:luan_van/model/User.dart';
//
// class AuthFireBase{
//   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//
//   void signUp(UserModel MyUser){
//     _firebaseAuth.createUserWithEmailAndPassword(email: MyUser.email, password: MyUser.password).then((user){
//       MyUser.id = user.user.uid;
//       _createUser(MyUser);
//       print("Tạo thành công user");
//     }).catchError((onError){
//       print("Lỗi");
//     });
//   }
//
//   void _createUser(UserModel _user){
//     var createUser = {
//       "name" : _user.name ?? "",
//       "email" : _user.email ?? "",
//       "password" : _user.password ?? "",
//       "sex" : _user.sex ?? "",
//       "birthday" : _user.birthday ?? 946684800,
//       "bornYear" : _user.bornYear ?? 2000,
//       "height" : _user.height ?? "",
//       "weight" : _user.weight ?? "",
//       "adress" : _user.address ?? "",
//       "role" : _user.role ?? "user",
//       "avatar" : _user.avatar ?? "",
//       "phone" : _user.phone ?? ""
//     };
//
//     var ref = FirebaseDatabase.instance.reference().child("users");
//     ref.child(_user.id).set(createUser).then((user) {
//       print("Firebase thành công user");
//     }).catchError((error){
//       print("Firebase fail");
//     });
//
//     users.add(_user);
//   }
// }