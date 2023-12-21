// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:estore/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/services.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  var answer = '';

// Array of button
  List<String> buttons = [
    '0',
    '.',
    '=',
    ' + ',
    '1',
    '2',
    '3',
    ' - ',
    '4',
    '5',
    '6',
    ' x ',
    '7',
    '8',
    '9',
    ' / ',
    'C',
    '+/-',
    '%',
    'DEL'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.only(top: 12, bottom: 12, right: 12),
                  alignment: Alignment.centerRight,
                  child: Text(
                    userInput,
                    style: const TextStyle(fontSize: 22, color: Colors.black),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(9),
                  alignment: Alignment.centerRight,
                  child: Text(
                    answer,
                    style: Theme.of(context).textTheme.headlineLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ]),
          SizedBox(
            height: screenSize(context, isHeight: true, percentage: 59),
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: GridView.builder(
                    reverse: true,
                    itemCount: buttons.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      // Clear Button
                      if (index == 16) {
                        return MyButton(
                          buttontapped: () {
                            SystemSound.play(SystemSoundType.click);
                            setState(() {
                              userInput = '';
                              answer = '0';
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.blue[50],
                          textColor: Colors.black,
                        );
                      }

                      // +/- button
                      else if (index == 17) {
                        return MyButton(
                          buttonText: buttons[index],
                          color: Colors.blue[50],
                          textColor: Colors.black,
                        );
                      }
                      // % Button
                      else if (index == 18) {
                        return MyButton(
                          buttontapped: () {
                            SystemSound.play(SystemSoundType.click);

                            setState(() {
                              userInput += buttons[index];
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.blue[50],
                          textColor: Colors.black,
                        );
                      }
                      // Delete Button
                      else if (index == 19) {
                        return MyButton(
                          buttontapped: () {
                            SystemSound.play(SystemSoundType.click);
                            setState(() {
                              userInput =
                                  userInput.substring(0, userInput.length - 1);
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.blue[50],
                          textColor: Colors.black,
                        );
                      }
                      // Equal_to Button
                      else if (index == 2) {
                        return MyButton(
                          buttontapped: () {
                            SystemSound.play(SystemSoundType.click);
                            setState(() {
                              equalPressed();
                            });
                          },
                          buttonText: buttons[index],
                          color: Colors.orange[700],
                          textColor: Colors.white,
                        );
                      }

                      // other buttons
                      else {
                        return MyButton(
                          buttontapped: () {
                            SystemSound.play(SystemSoundType.click);
                            setState(() {
                              userInput += buttons[index];
                            });
                          },
                          buttonText: buttons[index],
                          color: isOperator(buttons[index])
                              ? Colors.blueAccent
                              : Colors.white,
                          textColor: isOperator(buttons[index])
                              ? Colors.white
                              : Colors.black,
                        );
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == ' / ' || x == ' x ' || x == ' - ' || x == ' + ' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    try {
      String finaluserinput = userInput;
      finaluserinput = userInput.replaceAll('x', '*');

      Parser p = Parser();
      Expression exp = p.parse(finaluserinput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      answer = eval.toString();
    } catch (e) {
      answer = e.toString();
    }
  }
}

// creating Stateless Widget for buttons
class MyButton extends StatelessWidget {
// declaring variables
  final color;
  final textColor;
  final String buttonText;
  final buttontapped;

//Constructor
  const MyButton(
      {super.key,
      this.color,
      this.textColor,
      required this.buttonText,
      this.buttontapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Container(
        color: color,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
