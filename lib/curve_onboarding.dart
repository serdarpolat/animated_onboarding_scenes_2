import 'dart:ui';

import 'package:animated_curve_onboarding2/my_painter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CurveOnboarding extends StatefulWidget {
  @override
  _CurveOnboardingState createState() => _CurveOnboardingState();
}

class _CurveOnboardingState extends State<CurveOnboarding>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> a1;
  Animation<double> a2;
  double get w => MediaQuery.of(context).size.width;
  double get h => MediaQuery.of(context).size.height;

  int count = 0;
  int swipe = 0;

  List<double> posLeft = [0.0, -240.0, -480.0];

  List<Color> colors;
  Color turkuaz = Color(0xff5ED8DF);
  Color pink = Color(0xffF798EF);
  Color yellow = Color(0xffFFDC33);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _controller.addListener(() {
      setState(() {
        print(_controller.status);
      });
    });

    a1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: Curves.easeInQuad)));
    a2 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.easeInQuad)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      colors = [turkuaz, pink, yellow];
    } else if (count == 1) {
      colors = [pink, yellow, turkuaz];
    } else {
      colors = [yellow, turkuaz, pink];
    }
    return Scaffold(
      body: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Container(
                  width: w,
                  height: h,
                  color: count == 0 ? pink : count == 1 ? yellow : turkuaz,
                ),
                ...List.generate(colors.length, (i) {
                  return ContainerWidget(
                    posLeft: posLeft[i],
                    w: w,
                    h: h,
                    paintValOne: a1.value,
                    paintValTwo: a2.value,
                    color: colors[i],
                  );
                }),
                Positioned(
                  bottom: 40,
                  left: (w - 80) / 2,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 480),
                    curve: Curves.easeOutQuad,
                    width: 80,
                    height: 80,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          _controller.value != 0
                              ? Icons.close
                              : swipe == 2 ? Icons.close : Icons.arrow_forward,
                        ),
                        iconSize: 40,
                        color: Colors.white,
                        onPressed: () {
                          if (count != 2) {
                            swipe++;
                            _controller.forward().whenComplete(() {
                              _controller.reset();
                              count++;
                              print(count);
                            });
                          } else {
                            return;
                          }
                        },
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: count == 0 ? turkuaz : count == 1 ? pink : yellow,
                      border: Border.all(
                        color:
                            count == 0 ? yellow : count == 1 ? turkuaz : pink,
                        width: 5,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: w,
                  height: h * 0.7,
                  child: Stack(
                    children: List.generate(boards.length, (index) {
                      return AnimatedPositioned(
                        top: h * 0.25,
                        left: w * (swipe - index),
                        duration: Duration(milliseconds: 1720),
                        curve: swipe == index
                            ? Interval(0.80, 1.0)
                            : Interval(0.0, 0.25),
                        child: BoardWidget(
                          boardModel: boards[index],
                          color:
                              count == 0 ? yellow : count == 1 ? turkuaz : pink,
                        ),
                      );
                    }),
                  ),
                ),
                Positioned(
                  top: h * 0.15,
                  child: Opacity(
                    opacity: _controller.value != 0 ? 0 : 1,
                    child: Container(
                      width: w,
                      child: Text(
                        "How to use Hand Sanitizer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(3, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class BoardModel {
  final String animPath;
  final String title;

  BoardModel(this.animPath, this.title);
}

List<BoardModel> boards = [
  BoardModel("assets/json_data/page0.json",
      "Dispense the hand sanitizer on your palms."),
  BoardModel("assets/json_data/page1.json",
      "Rub well over palms, back of hands and fingernails until dry."),
  BoardModel("assets/json_data/page2.json",
      "Waterless use for refreshingly clean hands."),
];

class BoardWidget extends StatelessWidget {
  final BoardModel boardModel;
  final Color color;

  const BoardWidget({Key key, this.boardModel, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
      width: w,
      child: Column(
        children: <Widget>[
          Container(
            width: w * 0.6,
            height: w * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 10),
                  blurRadius: 0,
                ),
              ],
              border: Border.all(
                color: color,
                width: 5,
              ),
            ),
            child: Lottie.asset(
              boardModel.animPath,
              repeat: true,
              animate: true,
            ),
          ),
          SizedBox(height: 24),
          Container(
            width: w / 2,
            child: Text(
              boardModel.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContainerWidget extends StatelessWidget {
  final double w;
  final double h;
  final double posLeft;
  final double paintValOne;
  final double paintValTwo;
  final Color color;

  const ContainerWidget({
    Key key,
    this.w,
    this.h,
    this.posLeft,
    this.paintValOne,
    this.paintValTwo,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 1200),
      curve: Curves.fastLinearToSlowEaseIn,
      top: 0,
      left: posLeft * (1 - paintValOne),
      child: Container(
        width: w,
        height: h,
        child: CustomPaint(
          painter: MyPainter(
            paintValOne,
            paintValTwo,
            color,
          ),
        ),
      ),
    );
  }
}
