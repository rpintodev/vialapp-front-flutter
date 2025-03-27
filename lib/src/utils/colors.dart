
import 'package:flutter/cupertino.dart';

class KConstantColors {
  //! light
  static const greyColor = Color(0xFF368983);
  static const whiteColor = Color(0xFF368983);
  static var faintWhiteColor = whiteColor.withOpacity(0.5);

  //! dark
  static const bgColor = Color.fromRGBO(250, 250, 250, 1);
  static const bgColorFaint = Color.fromRGBO(30, 30, 30, 1);
  static var faintBgColor = bgColor.withOpacity(0.5);

  //! other
  static const appPrimaryColor = Color.fromRGBO(0, 0, 255, 2);
  static const primaryColor = Color.fromRGBO(168, 168, 168, 2);
  static const secondaryColor = appPrimaryColor;
  static const blueColor = CupertinoColors.systemBlue;
  static const green = Color.fromRGBO(4, 149, 65, 1);
  static const redColor = CupertinoColors.systemRed;
}
