import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorController extends GetxController {
  final RxString userInput = ''.obs;
  final RxString userOutput = '0'.obs;

  // Reusable instances to save RAM and improve speed
  final Parser _parser = Parser();
  final ContextModel _contextModel = ContextModel();

  void handleButtons(String text) {
    if (text == 'AC') {
      userInput.value = '';
      userOutput.value = '0';
    } else if (text == 'C') {
      if (userInput.value.isNotEmpty) {
        userInput.value = userInput.value.substring(
          0,
          userInput.value.length - 1,
        );
      }
    } else if (text == '=') {
      calculateResult();
    } else {
      _appendInput(text);
    }
  }

  void _appendInput(String text) {
    // Basic logic to prevent simple invalid inputs (improves accuracy & speed)
    if (userInput.value.isEmpty && ['/', 'x', '+', '-', '%'].contains(text))
      return;

    // Prevent multiple consecutive operators
    if (userInput.value.isNotEmpty) {
      String lastChar = userInput.value.substring(userInput.value.length - 1);
      if (['/', 'x', '+', '-', '%'].contains(lastChar) &&
          ['/', 'x', '+', '-', '%'].contains(text)) {
        userInput.value =
            userInput.value.substring(0, userInput.value.length - 1) + text;
        return;
      }
    }

    userInput.value += text;
  }

  void calculateResult() {
    if (userInput.value.isEmpty) return;

    try {
      String finalInput = userInput.value.replaceAll('x', '*');

      // Handle percentage
      finalInput = finalInput.replaceAll('%', '/100');

      Expression exp = _parser.parse(finalInput);
      double eval = exp.evaluate(EvaluationType.REAL, _contextModel);

      // Improved Accuracy: Handling floating point precision and formatting
      if (eval.isInfinite || eval.isNaN) {
        userOutput.value = "Error";
      } else {
        // Fix for 0.1 + 0.2 precision issues and removing trailing zeros
        String result = eval.toStringAsPrecision(12);
        if (result.contains('.')) {
          result = result
              .replaceAll(RegExp(r'0+$'), '')
              .replaceAll(RegExp(r'\.$'), '');
        }
        userOutput.value = result;
      }
    } catch (e) {
      userOutput.value = "Error";
    }
  }
}
