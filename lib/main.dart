import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const Thermostat());
}

class Thermostat extends StatefulWidget {
  const Thermostat({Key? key}) : super(key: key);

  @override
  State<Thermostat> createState() => _ThermostatState();
}

class _ThermostatState extends State<Thermostat>
    with SingleTickerProviderStateMixin {
  // Begin magic numbers
  static const Duration transitionTime = Duration(seconds: 2);
  static const int tempRange = 20;
  static const int minTemp = 60;
  static const int maxTemp = 80;
  static const int midTemp = (minTemp + maxTemp) ~/ 2;
  // End magic numbers

  static final Random _random = Random();
  double _roomTemp = _random.nextInt(tempRange).toDouble() + minTemp;

  double _currentSliderValue = midTemp.toDouble();

  Color _nextColor = const Color.fromARGB(255, 100, 0, 100);
  Color _prevColor = const Color.fromARGB(255, 100, 0, 100);

  // Used to show the room warming/cooling
  late Timer _timer;

  // Animation things
  // late AnimationController _controller;
  // late Animation<Color?> _animation;

  // late ColorTween _colorTween;

  @override
  void initState() {
    super.initState();

    // _colorTween = ColorTween(
    //   begin: _prevColor,
    //   end: _nextColor,
    // );

    // _controller = AnimationController(
    //   duration: transitionTime,
    //   vsync: this,
    // );

    // _animation = _colorTween.animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    changeBackground();

    _timer = Timer.periodic(
        transitionTime,
        (Timer t) => setState(() {
              changeTemp();
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    // _controller.dispose();
    super.dispose();
  }

  void changeBackground() {
    // Color fullRed = Color.fromARGB(255, 200, 0, 0);
    // Color fullBlue = Color.fromARGB(255, 0, 0, 200);

    final int rawDeviationFromMidTemp = _roomTemp.toInt() - midTemp;
    final int scaledDeviationFromMidTemp = 10 * rawDeviationFromMidTemp.abs();

    final int nextRedAmt;
    final int nextBlueAmt;

    if (rawDeviationFromMidTemp.isNegative) {
      nextRedAmt = 100 - scaledDeviationFromMidTemp;
      nextBlueAmt = 100 + scaledDeviationFromMidTemp;
    } else {
      nextRedAmt = 100 + scaledDeviationFromMidTemp;
      nextBlueAmt = 100 - scaledDeviationFromMidTemp;
    }

    // _prevColor = _nextColor;
    _nextColor = Color.fromARGB(255, nextRedAmt, 0, nextBlueAmt);
    // _controller.forward();
  }

  void changeTemp() {
    if (_roomTemp > _currentSliderValue) {
      _roomTemp -= 1;
      changeBackground();
    } else if (_roomTemp < _currentSliderValue) {
      _roomTemp += 1;
      changeBackground();
    }
  }

  Widget slider() {
    return SliderTheme(
      data: const SliderThemeData(thumbColor: Colors.black),
      child: Slider(
          value: _currentSliderValue,
          min: minTemp.toDouble(),
          max: maxTemp.toDouble(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value.roundToDouble();
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Thermostat',
        theme: ThemeData(fontFamily: 'Ubuntu'),
        home: Scaffold(
          backgroundColor: _nextColor,
          appBar: null,
          body: Center(
            child: Column(
              children: [
                Text("${_roomTemp.toInt()}°",
                    style: const TextStyle(fontSize: 55)),
                Text("${_currentSliderValue.toInt()}°",
                    style: const TextStyle(fontSize: 30)),
                slider(),
              ],
            ),
          ),
        ));
  }
}
