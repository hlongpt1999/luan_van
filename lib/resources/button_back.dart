import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';

Widget buttonBack(String _text){
  return Center(
    child: Wrap(
      direction: Axis.vertical,
      children: <Widget>[
        ButtonTheme(
          height: MySize.heightNextBack,
          child: RaisedButton(
              disabledColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(MySize.radiusNextBack))),
              onPressed: (){},
              textColor: Colors.white,
              color: Colors.deepOrange,
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                        child: Icon(
                          Icons.skip_previous,
                          color:Colors.white,
                          size: 40,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(_text,
                          style: TextStyle(color: Colors.white,fontSize: 20),),
                      ),


                    ],
                  )
              )
          ),
        ),
      ],
    ),
  );
}