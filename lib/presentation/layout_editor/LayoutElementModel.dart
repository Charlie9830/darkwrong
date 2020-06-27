import 'dart:math';

import 'package:darkwrong/presentation/layout_editor/rotatePoint.dart';
import 'package:flutter/material.dart';

class LayoutElementModel {
  final String uid;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final Color color;
  final double rotation;

  LayoutElementModel({
    this.uid,
    this.xPos,
    this.yPos,
    this.width,
    this.height,
    this.color,
    this.rotation = 0.0,
  });

  LayoutElementModel copyWith({
    String uid,
    double xPos,
    double yPos,
    double width,
    double height,
    double rotation,
    Color color,
  }) {
    return LayoutElementModel(
      uid: uid ?? this.uid,
      xPos: xPos ?? this.xPos,
      yPos: yPos ?? this.yPos,
      width: width ?? this.width,
      height: height ?? this.height,
      rotation: rotation ?? this.rotation,
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

  double get renderWidth => width.clamp(16.0, double.maxFinite);
  double get renderHeight => height.clamp(16.0, double.maxFinite);

  double get debugRenderXPos {
    final normalizedTopLeft = Point(0 - width / 2, 0 - height / 2);
    final rotated = rotatePoint(normalizedTopLeft, rotation);
    return rotated.x + xPos + width / 2;
  }

  double get debugRenderYPos {
    final normalizedTopLeft = Point(0 - width / 2, 0 - height / 2);
    final rotated = rotatePoint(normalizedTopLeft, rotation);
    return rotated.y + yPos + height / 2;
  }

  Rect get rectangle {
    return Rect.fromPoints(
        Offset(xPos, yPos), Offset(xPos + width, yPos + height));
  }
}
