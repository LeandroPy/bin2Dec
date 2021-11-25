import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

class BinToDecPage extends StatefulWidget {
  const BinToDecPage({Key? key}) : super(key: key);

  @override
  _BinToDecPageState createState() => _BinToDecPageState();
}

class _BinToDecPageState extends State<BinToDecPage> {
  Timer? _debounce;
  final TextEditingController binaryController = TextEditingController();
  String binaryConverted = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Binary to Decimal'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: TextField(
                    controller: binaryController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(label: Text('Binary')),
                    onChanged: _binaryChanged),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: Center(
                  child: Row(
                    children: [
                      const Text(
                        'Decimal: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        binaryConverted,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[300]!),
                  ),
                  child: const Center(
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: _clearInputAndResult,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearInputAndResult() {
    setState(() {
      binaryController.text = '';
      binaryConverted = '';
    });
  }

  bool _isValidBinary(String inputValue) {
    // Validated if contains any character other than 0 or 1
    String regexExpression = '[^01]';
    return inputValue == '' || !inputValue.contains(RegExp(regexExpression));
  }

  String _convertBinaryToDecimal(String inputValue) {
    int currentIndex = 0;
    num convertedValue = 0;
    int inputValueLength = inputValue.length;
    while (currentIndex < inputValueLength) {
      int exponencial = inputValueLength - (currentIndex + 1);
      int currentCharacter =
          int.parse(inputValue.substring(currentIndex, currentIndex + 1));

      convertedValue += currentCharacter * (pow(2, exponencial));
      currentIndex++;
    }

    return '$convertedValue';
  }

  void _binaryChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!_isValidBinary(value)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Binary'),
          ),
        );
        return;
      }
      setState(() {
        binaryConverted = _convertBinaryToDecimal(value);
      });
    });
  }
}
