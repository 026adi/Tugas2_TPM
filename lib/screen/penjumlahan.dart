import 'package:flutter/material.dart';

class PenjumlahanScreen extends StatefulWidget {
  const PenjumlahanScreen({super.key});

  @override
  State<PenjumlahanScreen> createState() => _PenjumlahanScreenState();
}

class _PenjumlahanScreenState extends State<PenjumlahanScreen> {

  String display = "0";
  String operator = "";
  bool isResult = false;

  /// input angka
  void inputNumber(String number) {

    setState(() {

      if (isResult) {
        display = number;
        isResult = false;
        return;
      }

      if (display == "0") {
        display = number;
      } else {
        display += number;
      }

    });

  }

  /// set operator
  void setOperator(String op) {

    if (operator.isNotEmpty) return;

    operator = op;

    setState(() {
      display += op;
      isResult = false;
    });

  }

  /// hitung
  void hitung() {

    if (operator.isEmpty) return;

    List<String> parts = display.split(operator);

    if (parts.length < 2) return;

    double num1 = double.parse(parts[0]);
    double num2 = double.parse(parts[1]);

    double result = 0;

    if (operator == "+") {
      result = num1 + num2;
    } else if (operator == "-") {
      result = num1 - num2;
    }

    setState(() {

      if (result % 1 == 0) {
        display = result.toInt().toString();
      } else {
        display = result.toString();
      }

      operator = "";
      isResult = true;
    });

  }

  /// clear
  void clear() {

    setState(() {
      display = "0";
      operator = "";
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

            } else if (text == "+") {
              setOperator("+");

            } else if (text == "-") {
              setOperator("-");

            } else if (text == "=") {
              hitung();

            } else {
              inputNumber(text);
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
        title: const Text("Penjumlahan & Pengurangan"),
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

          Row(
            children: [
              buildButton("C",
                  color: Colors.red.shade100,
                  textColor: Colors.red),

              buildButton("-",
                  color: Colors.blue.shade100,
                  textColor: Colors.blue),

              buildButton("+",
                  color: Colors.blue.shade100,
                  textColor: Colors.blue),
            ],
          ),

          Row(
            children: [
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
            ],
          ),

          Row(
            children: [
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
            ],
          ),

          Row(
            children: [
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
            ],
          ),

          Row(
            children: [
              buildButton("0"),
              buildButton("=",
                  color: Colors.blue,
                  textColor: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}