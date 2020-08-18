import 'package:flutter/material.dart';
import 'package:thesis_demo/ressources/colors.dart';
import 'package:thesis_demo/ressources/strings.dart';

final snackBarHelper = SnackBar(
  content: Text(
    snackBarText,
    style: TextStyle(color: snackBarTextColor),
  ),
  backgroundColor: snackBarBackgroundColor,
);
