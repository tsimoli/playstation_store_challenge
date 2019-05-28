import 'package:flutter/material.dart';
import 'package:playstation_store_challenge/icon_row.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playstation store challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> pageNames = ["Menu", "Dashboard", "Chat"];

  bool initAnimationReady = false;
  PageController controller = PageController(initialPage: 1);
  Animatable<Color> background;
  double menuRowOffset = 0.0;
  ColorTween iconColor = ColorTween(begin: Colors.white, end: Colors.black);
  double prevScrollValue = 1;

  @override
  void initState() {
    super.initState();
    background = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.black,
          end: Colors.blue[800],
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.blue[800],
          end: Colors.white,
        ),
      ),
    ]);

    controller.addListener(() {
      setState(() {
        menuRowOffset = (-(MediaQuery.of(context).size.width / 2) + 25.5) *
            (controller.page - 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final color = controller.hasClients ? controller.page / 2 : 0.5;

            return DecoratedBox(
              decoration: BoxDecoration(
                color: background.evaluate(AlwaysStoppedAnimation(color)),
              ),
              child: child,
            );
          },
          child: Stack(
            children: [
              Transform.translate(
                  offset: Offset(menuRowOffset, 0),
                  child: IconRow(
                      setInitAnimationReady: setInitAnimationReady,
                      iconColor: iconColor.lerp(
                          controller.hasClients ? controller.page - 1 : .0),
                      currentPage:
                          controller.hasClients ? controller.page - 1 : .0)),
              initAnimationReady
                  ? PageView(
                      controller: controller,
                      children: <Widget>[
                        ...pageNames.map((pageName) => Container(
                            alignment: Alignment.center,
                            child: Text(pageName,
                                style: TextStyle(
                                    fontSize: 40,
                                    color: pageName == "Chat"
                                        ? Colors.black
                                        : Colors.white))))
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void setInitAnimationReady() {
    setState(() {
      initAnimationReady = true;
    });
  }
}
