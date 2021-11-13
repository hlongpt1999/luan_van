import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SpinKitSpinningLines(
              color: Colors.blue,
              size: 50.0,
            ),
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