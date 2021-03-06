import 'package:flutter/material.dart';
import 'package:luan_van/components/Constants.dart';

Widget backgroundPainterCircle(){
  return new Container(
    height: double.infinity,
    width: double.infinity,
    child: new CustomPaint(
      painter: new CircularBackgroundPainter(),
    ),
  );
}

class CircularBackgroundPainter extends CustomPainter {
  final Paint mainPaint;
  final Paint middlePaint;
  final Paint lowerPaint;
  CircularBackgroundPainter()
      : mainPaint = new Paint(),
        middlePaint = new Paint(),
        lowerPaint = new Paint() {
    mainPaint.color = new Color(Const.colorMainPaint);
    mainPaint.isAntiAlias = true;
    mainPaint.style = PaintingStyle.fill;
    middlePaint.color = new Color(Const.colorMiddlePaint);
    middlePaint.isAntiAlias = true;
    middlePaint.style = PaintingStyle.fill;
    lowerPaint.color = new Color(Const.colorLowPaint);
    lowerPaint.isAntiAlias = true;
    lowerPaint.style = PaintingStyle.fill;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();
    //canvas.translate(radius, radius);
    drawBellAndLeg(radius, canvas, size);
    canvas.restore();
  }
  void drawBellAndLeg(radius, canvas, Size size) {
    Path upperPath = new Path();
    upperPath.addRect(Rect.fromLTRB(0, 0, size.width, size.height / 4));
    upperPath.addArc(
        Rect.fromLTRB(-140, 40, size.width + 50, size.height / 1.95), 0.1, 30);
    Path middlePath = new Path();
    middlePath.addRect(Rect.fromLTRB(0, 0, size.width, size.height / 4));
    middlePath.addArc(
        Rect.fromLTRB(-135, 0, size.width + 50, size.height / 2.2), 0.1, 30);
    Path lowerPath = new Path();
    lowerPath.addRect(Rect.fromLTRB(0, 0, size.width, size.height / 5));
    lowerPath.addArc(
        Rect.fromLTRB(-150, -100, size.width + 50, size.height / 2.5), 0.1, 30);
    canvas.drawPath(upperPath, lowerPaint);
    canvas.drawPath(middlePath, middlePaint);
    canvas.drawPath(lowerPath, mainPaint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}