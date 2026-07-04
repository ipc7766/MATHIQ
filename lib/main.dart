import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'calculator_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mathiq',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  static const List<String> _buttons = [
    'AC',
    'C',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '00',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    final CalculatorController controller = Get.put(CalculatorController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Display Section - Prevents text overflow
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Obx(
                      () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          controller.userInput.value,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          controller.userOutput.value,
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons Section - Prevents grid overflow
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _buttons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.1,
                          ),
                      itemBuilder: (context, index) {
                        final String text = _buttons[index];
                        return CalcButton(
                          text: text,
                          onPressed: () => controller.handleButtons(text),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalcButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CalcButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool isOperator = const ['/', 'x', '-', '+', '='].contains(text);
    final bool isSpecial = const ['AC', 'C', '%'].contains(text);

    final Color? bgColor = isOperator
        ? Colors.amber[700]
        : isSpecial
        ? Colors.grey[700]
        : Colors.grey[850];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSpecial ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
