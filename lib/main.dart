import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:blog/home_page.dart';
import 'hex_color.dart';

void main() {
  Wind.instance.mainLoop();
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Trip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Rain(),
    );
  }
}

class Rain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#1980B3'),
      //ao
      //backgroundColor: HexColor('3B27BA'),
      body: Stack(
        children: [
          ...List.generate(
            500, // 雨粒の数
            (_) => Particle(
              key: UniqueKey(),
              rainArea: 5000,
            ),
          ),
          HomePage(),
        ],
      ),
    );
  }
}

class Particle extends StatefulWidget {
  Particle({required Key key, required this.rainArea}) : super(key: key);
  final double rainArea;

  @override
  _ParticleState createState() => _ParticleState();
}

class _ParticleState extends State<Particle>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  final random = Random();
  late double initXPos;
  late double initYPos;
  late double strokeWidth;
  late double length;
  late double resetTime;

  var count = 0;

  @override
  void initState() {
    super.initState();
    reset();
    animationController.addListener(() {
      count++;
      if (count > resetTime) {
        reset();
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void reset() {
    count = 0;
    initXPos = (random.nextDouble() * widget.rainArea) - (widget.rainArea / 2);
    initYPos = -random.nextDouble() * 1000;
    strokeWidth = random.nextDouble() / 4;
    length = random.nextDouble() * 280;
    resetTime = 10 + random.nextDouble() * 100;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            xPos: initXPos +
                (count *
                    (Wind.instance.xVelocity *
                        (Wind.instance.yVelocity + 60.0))),
            yPos: initYPos + (count * (Wind.instance.yVelocity + 60.0)),
            strokeWidth: strokeWidth * 5,
            length: length,
            xVelocity: Wind.instance.xVelocity,
          ),
        );
      },
    );
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.xPos,
    required this.yPos,
    required this.strokeWidth,
    required this.length,
    required this.xVelocity,
  });

  final double xPos;
  final double yPos;
  final double strokeWidth;
  final double length;
  final double xVelocity;

  @override
  void paint(Canvas canvas, Size size) {
    //yellow,orange
    var color_list = [
      HexColor("#FFF100"),
      HexColor("#FF9472"),
      HexColor("#fffff0"),
      HexColor("#ffd700")
    ];
    final paint = Paint();
    final random = Random();
    int num = Random().nextInt(3);
    final fluctuation = random.nextDouble() / 50;
    paint.strokeWidth = strokeWidth;
    paint.color = color_list[num];
    canvas.drawLine(
      Offset(xPos, yPos),
      Offset(
        xPos + (40 + length) * (xVelocity + fluctuation),
        yPos + (40 + length), // 40 は最小の長さ
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 風を定義しているクラス
class Wind {
  Wind._();

  static Wind instance = Wind._();
  final random = Random();
  double xVelocity = 0;
  int yVelocity = 0;

  /// 風が吹くタイミングを決定する
  int time = 0;

  /// 風向きを変える
  void changeWindow() {
    xVelocity = xVelocity + (random.nextDouble() - .5) / 10;
    yVelocity = random.nextInt(5);
  }

  Future<void> mainLoop() async {
    int count = 0;
    time = random.nextInt(500);
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      count++;
      changeWindow();
      if (count > time) {
        count = 0;
        time = random.nextInt(500);
        xVelocity = xVelocity + (random.nextDouble() - .5);
      }
    }
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ここにタブのタイトルがくる',
      /*
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

       */
      themeMode: ThemeMode.dark,
      //darkTheme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: '〇〇みゅ〜じあむ'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

 */
