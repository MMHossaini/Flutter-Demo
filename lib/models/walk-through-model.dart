import "package:flutter/material.dart";

class WalkThrough {
  IconData icon;
  String title;
  String description;
  Color backgroundColor;
  Widget extraWidget;

  WalkThrough(
      {this.icon,
      this.title,
      this.description,
      this.backgroundColor,
      this.extraWidget});
}
