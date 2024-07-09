import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String displayText = '0';
  String operand = '';
  double num1 = 0;
  double num2 = 0;

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'CLEAR') {
        displayText = '0';
        num1 = 0;
        num2 = 0;
        operand = '';
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == 'x' ||
          buttonText == '/') {
        num1 = double.parse(displayText);
        operand = buttonText;
        displayText = '0';
      } else if (buttonText == '=') {
        num2 = double.parse(displayText);
        if (operand == '+') {
          displayText = (num1 + num2).toString();
        } else if (operand == '-') {
          displayText = (num1 - num2).toString();
        } else if (operand == 'x') {
          displayText = (num1 * num2).toString();
        } else if (operand == '/') {
          displayText = (num1 / num2).toString();
        }
        operand = '';
      } else {
        if (displayText == '0') {
          displayText = buttonText;
        } else {
          displayText += buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            textStyle: const TextStyle(fontSize: 24.0),
            backgroundColor: color,
          ),
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding:
            const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            color: Colors.white,
            child: Text(
              displayText,
              style:
              const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(child: Divider()),
          Column(children: [
            Row(children: [
              buildButton("7", Colors.blue),
              buildButton("8", Colors.blue),
              buildButton("9", Colors.blue),
              buildButton("/", Colors.lightBlue),
            ]),
            Row(children: [
              buildButton("4", Colors.blue),
              buildButton("5", Colors.blue),
              buildButton("6", Colors.blue),
              buildButton("x", Colors.lightBlue),
            ]),
            Row(children: [
              buildButton("1", Colors.blue),
              buildButton("2", Colors.blue),
              buildButton("3", Colors.blue),
              buildButton("-", Colors.lightBlue),
            ]),
            Row(children: [
              buildButton(".", Colors.blue),
              buildButton("0", Colors.blue),
              buildButton("00", Colors.blue),
              buildButton("+", Colors.lightBlue),
            ]),
            Row(children: [
              buildButton("CLEAR", Colors.lightBlue),
              buildButton("=", Colors.lightBlue),
            ])
          ])
        ],
      ),
    );
  }
}
