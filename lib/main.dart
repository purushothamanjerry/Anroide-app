import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String result = "0";
  double firstNum = 0;
  double secondNum = 0;
  String operator = "";
  String expression = "";
  bool justCalculated = false; // Track if "=" was pressed

  void onButtonPress(String text) {
    setState(() {
      if (text == "C") {
        result = "0";
        firstNum = 0;
        secondNum = 0;
        operator = "";
        expression = "";
        justCalculated = false;
      } 
      else if (text == "+" || text == "-" || text == "X" || text == "/") {
        operator = text;firstNum = double.tryParse(result) ?? 0;
        String displayNum = firstNum % 1 == 0 ? firstNum.toInt().toString() : firstNum.toString();
          expression = "$displayNum $operator";

        result = "0";
        justCalculated = false;
      } 
      else if (text == "=") {
  if (operator.isEmpty) return; // Skip if no operation
  secondNum = double.tryParse(result) ?? 0;
  double res = _calculate(firstNum, secondNum, operator);
  expression = "";
  result = res % 1 == 0 ? res.toInt().toString() : res.toString(); // ✅ fixed display
  firstNum = res;
  operator = "";
  justCalculated = true;
}
      else {
        if (justCalculated) {
          result = text;
          expression = "";
          justCalculated = false;
        } else if (result == "0") {
          result = text;
        } else {
          result += text;
        }
      }
    });
  }

  double _calculate(double a, double b, String op) {
    switch (op) {
      case "+": return a + b;
      case "-": return a - b;
      case "X": return a * b;
      case "/": return b != 0 ? a / b : 0;
      default: return b;
    }
  }

  Widget Circledigits(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => onButtonPress(text),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(List<String> texts) {
    return Row(
      children: texts
          .map((text) => Expanded(child: Circledigits(text))) // 👈 responsive buttons
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  expression,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  result,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 30),

                // ✅ Using buildRow for cleaner layout
                buildRow(["7", "8", "9", "X"]),
                buildRow(["4", "5", "6", "-"]),
                buildRow(["1", "2", "3", "+"]),
                buildRow(["/", "0", "C", "="]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
