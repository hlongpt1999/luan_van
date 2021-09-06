import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget LoginForm(BuildContext context){
  return Container(
    margin: new EdgeInsets.symmetric(horizontal: 20.0),
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Form(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "User name",
                    labelText: "User Name",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.white,),
                  ),
                  style: TextStyle(fontSize: 20),
                ),

                //Space between 2 TextForm.
                SizedBox(height: 30,),

                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.white,),
                  ),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )),
      ],
    ),
  );
}