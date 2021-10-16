import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:luan_van/model/User.dart';

class AuthFireBase{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void signUp(UserModel _user){
    _firebaseAuth.createUserWithEmailAndPassword(email: _user.email, password: _user.password).then((value){
      //TODO: Đăng ký thành công thì sẽ làm những gì.
      users.add(_user).then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }).catchError((onError){
      //TODO: Xử lý không đăng ký thành công
    });
  }
}