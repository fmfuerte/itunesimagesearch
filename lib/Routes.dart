import 'package:flutter/material.dart';
import 'package:itunesmoviessearch/home/index.dart';
import 'package:itunesmoviessearch/view_detail/index.dart';
import 'package:itunesmoviessearch/splash/index.dart';

/*
Class that manages the routing of the app. it also launches the splash page
*/

class Routes {
  var routes = <String, WidgetBuilder>{
    "/home": (BuildContext context) => new SearchView(),
    "/detail": (BuildContext context) => new ViewDetail(),
  };
  Routes() {
    runApp(new MaterialApp(
      title: "Flutter Do App",
      debugShowCheckedModeBanner: false,
      home: new Container(child: new Splash()),
      routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home':
            return new MyCustomRoute(
              builder: (_) => new SearchView(),
              settings: settings,
            );
//          case '/splash':
//            return new MyCustomRoute(
//              builder: (_) => new Splash(),
//              settings: settings,
//            );
        }
      },
    ));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) {
      return child;
    }
    return new FadeTransition(opacity: animation, child: child);
  }
}
