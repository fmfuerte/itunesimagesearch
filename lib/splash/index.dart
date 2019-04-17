import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/*
Splash Screen that animates an image to mimic loading
*/

class Splash extends StatefulWidget {
  _SplashState createState() => new _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Animation<double> animation1;
  AnimationController controller1;
  double value = 150.0;
  int i = 0;
  bool show = false;
  double visiblity = 0.0;
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation = new Tween(begin: 150.0, end: 170.0).animate(controller)
      ..addListener(() {
        setState(() {
          value = animation.value.toDouble();
          if (animation.value == 150.0 || animation.value == 170.0) {
            i++;
          }
        });
      })
      ..addStatusListener((status) {
        if ((status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) &&
            i > 8) {
          Navigator.pushNamed(context, "/home");
        }
        if (status == AnimationStatus.completed && i <= 8) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed && i <= 8) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/NewTaskBg2.png"),
            //image: new AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Opacity(
          opacity: pow(value / 170.0, 2).clamp(0.0, 1.0),
          child: new Center(
            child: new Container(
                height: value,
                width: value,
                child: new Hero(
                  tag: "tick",
                  child: new Image.asset('assets/mark.png',
                      width: 150.0, height: 150.0, scale: 1.0),
                )),
          ),
        ),
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
