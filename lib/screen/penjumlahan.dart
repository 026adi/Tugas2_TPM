import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class PenjumlahanScreen extends StatefulWidget {
  const PenjumlahanScreen({super.key});

  @override
  State<PenjumlahanScreen> createState() => _PenjumlahanScreenState();
}

class _PenjumlahanScreenState extends State<PenjumlahanScreen> {

  String display = "0";
  bool isResult = false;

  /// input angka / titik
  void input(String value) {

    setState(() {

      if (isResult) {
        display = value;
        isResult = false;
        return;
      }

      if (display == "0") {
        display = value;
      } else {
        display += value;
      }

    });

  }

  /// operator (+ - * /)
  void operator(String op) {

    setState(() {

      if (isResult) {
        isResult = false;
      }

      display += op;

    });

  }

  /// hitung expression
  void hitung() {

    try {

      String finalExpression = display.replaceAll('×', '*').replaceAll('÷', '/');

      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();

      double result = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {

        if (result % 1 == 0) {
          display = result.toInt().toString();
        } else {
          display = result.toString();
        }

        isResult = true;

      });

    } catch (e) {
      setState(() {
        display = "Error";
      });
    }
  }

  /// clear
  void clear() {
    setState(() {
      display = "0";
      isResult = false;
    });
  }

  /// tombol
  Widget buildButton(String text,
      {Color color = Colors.white, Color textColor = Colors.black}) {

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.all(22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {

            if (text == "C") {
              clear();

            } else if (text == "=") {
              hitung();

            } else if (text == "+" || text == "-" || text == "×" || text == "÷") {
              operator(text);

            } else {
              input(text);
            }

          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [

          /// DISPLAY
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.blue.shade100,
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(20),
            child: Text(
              display,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          /// ROW 1
          Row(
            children: [
              buildButton("C", color: Colors.red.shade100, textColor: Colors.red),
              buildButton("÷", color: Colors.blue.shade100, textColor: Colors.blue),
              buildButton("×", color: Colors.blue.shade100, textColor: Colors.blue),
              buildButton("-", color: Colors.blue.shade100, textColor: Colors.blue),
            ],
          ),

          /// ROW 2
          Row(
            children: [
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("+", color: Colors.blue.shade100, textColor: Colors.blue),
            ],
          ),

          /// ROW 3
          Row(
            children: [
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton(".", color: Colors.grey.shade200),
            ],
          ),

          /// ROW 4
          Row(
            children: [
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("=",
                  color: Colors.blue,
                  textColor: Colors.white),
            ],
          ),

          /// ROW 5
          Row(
            children: [
              buildButton("0"),
            ],
          ),
        ],
      ),
    );
  }
}