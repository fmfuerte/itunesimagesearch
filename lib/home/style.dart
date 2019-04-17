import 'package:flutter/material.dart';
  

TextStyle subHeader = new TextStyle(
  fontSize: 15.0,
  color: Colors.white,
);
TextStyle title =
    new TextStyle(fontSize: 35.0, color: Colors.white, fontFamily: 'avenir');
TextStyle cardTitle =
    new TextStyle(fontSize: 25.0, color: Colors.black, fontFamily: 'avenir');
TextStyle subTitle =
    new TextStyle(fontSize: 15.0, color: Colors.black, fontFamily: 'avenir');
BoxDecoration decoration = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage("assets/NewTaskBg2.png"),
    fit: BoxFit.cover,
  ),
);

BoxDecoration background = new BoxDecoration(
  image: new DecorationImage(
    image: new AssetImage("assets/NewTaskBg2.png"),
    fit: BoxFit.cover,
  ),
);