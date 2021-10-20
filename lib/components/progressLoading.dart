import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressLoading {
  ProgressLoading();

  void showLoading(BuildContext context){
    FocusScope.of(context).unfocus();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

  void hideLoading(BuildContext context){
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }
}