import 'package:flutter/material.dart';

class LayoutElementModel {
  final String uid;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final Color color;

  LayoutElementModel({
    this.uid,
    this.xPos,
    this.yPos,
    this.width,
    this.height,
    this.color,
  });

  LayoutElementModel copyWith({
    String uid,
    double xPos,
    double yPos,
    double width,
    double height,
    Color color,
  }) {
    return LayoutElementModel(
      uid: uid ?? this.uid,
      xPos: xPos ?? this.xPos,
      yPos: yPos ?? this.yPos,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
    );
  }

  LayoutElementModel combinedWith({
    LayoutElementModel xComponent,
    LayoutElementModel yComponent,
  }) {
    return copyWith(
      xPos: xComponent?.xPos ?? this.xPos,
      yPos: yComponent?.yPos ?? this.yPos,
      width: xComponent?.width ?? this.width,
      height: yComponent?.height ?? this.height,
    );
  }

  double get leftEdge => xPos;
  double get rightEdge => xPos + width;
  double get topEdge => yPos;
  double get bottomEdge => yPos + height;

  double get renderWidth => width; // width.clamp(16.0, double.maxFinite);
  double get renderHeight => height; //height.clamp(16.0, double.maxFinite);

  Rect getRectangle() {
    return Rect.fromPoints(Offset(0, 0), Offset(width, height));
  }
}
