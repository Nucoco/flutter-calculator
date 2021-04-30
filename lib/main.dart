import 'package:flutter/material.dart';
import 'dart:math' as Math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

enum CALC_TYPE { add, sub, multi, div }

class _CalculatorState extends State<Calculator> {
  double _setNumber = 0;
  double _displayNumber = 0;
  double _firstNum = 0;
  CALC_TYPE _calcType;
  int _displayPow = 0;
  bool _decimalFlag = false;

  void _setNum(double num) {
    _displayPow = 0;
    if (_displayNumber == _setNumber) {
      if (10000000000 > _displayNumber) {
        setState(() {
          if (!_decimalFlag)
            _displayNumber = _displayNumber * 10 + num;
          else {
            int count = 1;
            for (int i = 0;
                _displayNumber * Math.pow(10, i) !=
                    (_displayNumber * Math.pow(10, i)).ceil();
                i++) {
              count++;
            }
            _displayNumber = double.parse(
                (_displayNumber + (num / Math.pow(10, count)))
                    .toStringAsFixed(count));
            _checkDecimal();
          }
          _setNumber = _displayNumber;
        });
      }
    } else {
      setState(() {
        _displayNumber = num;
        _setNumber = _displayNumber;
        _calcType = null;
      });
    }
  }

  void _calcBtnPressed(CALC_TYPE type) {
    _setNumber = _displayNumber;
    _firstNum = _setNumber;
    _setNumber = 0;
    _displayNumber = 0;
    _calcType = type;
  }

  void _calcAdd() {
    setState(() {
      _displayNumber = _firstNum + _setNumber;
      _checkDecimal();
      _firstNum = _displayNumber;
    });
  }

  void _calcSub() {
    setState(() {
      _displayNumber = _firstNum - _setNumber;
      _checkDecimal();
      _firstNum = _displayNumber;
    });
  }

  void _calcMulti() {
    setState(() {
      _displayNumber = _firstNum * _setNumber;
      _checkDecimal();
      _firstNum = _displayNumber;
    });
  }

  void _calcDiv() {
    setState(() {
      _displayNumber = _firstNum / _setNumber;
      _checkDecimal();
      _firstNum = _displayNumber;
    });
  }

  void _invertNum() {
    setState(() {
      _displayNumber = -_displayNumber;
      _setNumber = -_setNumber;
    });
  }

  void _checkDecimal() {
    double checkNum = _displayNumber;
    if (10000000000 < _displayNumber ||
        _displayNumber == _displayNumber.toInt()) {
      for (int i = 0; 10000000000 < _displayNumber / Math.pow(10, i); i++) {
        _displayPow = i;
        checkNum = checkNum / 10;
      }
      _displayNumber = checkNum.floor().toDouble();
    } else {
      int count = 0;
      for (int i = 0; 1 < _displayNumber / Math.pow(10, i); i++) {
        count = i;
      }
      int displayCount = 10 - count;
      _displayNumber =
          double.parse(_displayNumber.toStringAsFixed(displayCount));
    }
  }

  void _clearNum() {
    setState(() {
      _setNumber = 0;
      _displayNumber = 0;
      _firstNum = 0;
      _calcType = null;
      _displayPow = 0;
      _decimalFlag = false;
    });
  }

  void _clearEntryNum() {
    setState(() {
      _setNumber = 0;
      _displayNumber = 0;
      _displayPow = 0;
      _decimalFlag = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 20,
            child: _displayPow > 0
                ? Text(
                    "10^${_displayPow.toString()}",
                    style: TextStyle(fontSize: 20),
                  )
                : Container(),
          ),
          Text(
            _displayNumber == _displayNumber.toInt()
                ? _displayNumber.toInt().toString()
                : _displayNumber.toString(),
            style: TextStyle(
              fontSize: 60,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Placeholder(),
                      ),
                      fnBtn('CE', _clearEntryNum),
                      fnBtn('C', _clearNum),
                      calBtn('÷', _calcBtnPressed, CALC_TYPE.div),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      numBtn('7', _setNum, 7),
                      numBtn('8', _setNum, 8),
                      numBtn('9', _setNum, 9),
                      calBtn('×', _calcBtnPressed, CALC_TYPE.multi),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      numBtn('4', _setNum, 4),
                      numBtn('5', _setNum, 5),
                      numBtn('6', _setNum, 6),
                      calBtn('-', _calcBtnPressed, CALC_TYPE.sub),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      numBtn('1', _setNum, 1),
                      numBtn('2', _setNum, 2),
                      numBtn('3', _setNum, 3),
                      calBtn('+', _calcBtnPressed, CALC_TYPE.add),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      fnBtn('+/-', _invertNum),
                      numBtn('0', _setNum, 0),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: FlatButton(
                            onPressed: () {
                              _decimalFlag = true;
                            },
                            child: Text(
                              ".",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: FlatButton(
                            onPressed: () {
                              switch (_calcType) {
                                case CALC_TYPE.add:
                                  _calcAdd();
                                  break;
                                case CALC_TYPE.sub:
                                  _calcSub();
                                  break;
                                case CALC_TYPE.multi:
                                  _calcMulti();
                                  break;
                                case CALC_TYPE.div:
                                  _calcDiv();
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: Text(
                              "=",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget fnBtn(String label, Function fn, {CALC_TYPE calcType, double num}) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FlatButton(
          onPressed: () {
            fn();
          },
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget calBtn(String label, Function fn, CALC_TYPE calcType) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FlatButton(
          onPressed: () {
            fn(calcType);
          },
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget numBtn(String label, Function fn, double num) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: FlatButton(
          onPressed: () {
            fn(num);
          },
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}
