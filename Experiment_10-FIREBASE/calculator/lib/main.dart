import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
// import 'package:path/path.dart'; // No longer needed
// import 'package:sqflite/sqflite.dart'; // No longer needed
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Make sure this file exists!

// Main function to initialize Firebase and run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CalculatorApp());
}

// Main App Widget
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: const CalculatorHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Home Page Widget with state
class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _expression = '';
  String _result = '0';

  // Function to handle button presses
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '0';
      } else if (buttonText == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '=') {
        try {
          // Use math_expressions to parse and evaluate the expression
          // ignore: deprecated_member_use
          Parser p = Parser();
          Expression exp = p.parse(
            _expression.replaceAll('×', '*').replaceAll('÷', '/'),
          );
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          _result = eval.toStringAsFixed(
            eval.truncateToDouble() == eval ? 0 : 2,
          );

          // Save to history if the expression is valid
          if (_expression.isNotEmpty) {
            _saveToHistory('$_expression = $_result');
          }
          _expression = _result;
        } catch (e) {
          _result = 'Error';
        }
      } else {
        // Append the button text to the expression
        _expression += buttonText;
      }
    });
  }

  // Save to *only* cloud history
  Future<void> _saveToHistory(String calculation) async {
    // await DatabaseHelper.instance.insertHistory(calculation); // REMOVED
    await FirebaseFirestore.instance.collection('history').add({
      'calculation': calculation,
      'timestamp': FieldValue.serverTimestamp(),
    });
    // We don't need setState() here because StreamBuilder will update automatically
  }

  // Build the calculator UI
  @override
  Widget build(BuildContext context) {
    // No DefaultTabController needed
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator (Firebase)'),
        // No TabBar needed
      ),
      body: Column(
        children: <Widget>[
          // Display for expression and result
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(
                      fontSize: 28.0,
                      color: Colors.white70,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: const TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Calculator buttons
          Expanded(flex: 3, child: _buildButtons()),
          
          // History section
          Expanded(
            flex: 2,
            // No TabBarView needed
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Cloud History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: _buildFirebaseHistory(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for cloud history from Firebase
  Widget _buildFirebaseHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('history')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No cloud history yet.'));
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['calculation']),
              dense: true,
            );
          }).toList(),
        );
      },
    );
  }

  // Helper function to build the button layout
  Widget _buildButtons() {
    final buttons = [
      'C', '⌫', '%', '÷',
      '7', '8', '9', '×',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '.', '0', '00', '=',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        final buttonText = buttons[index];
        return _buildButton(buttonText);
      },
    );
  }

  // Helper function to style individual buttons
  Widget _buildButton(String buttonText) {
    Color color = Colors.blueGrey[800]!;
    Color textColor = Colors.white;

    if ('C⌫%÷×-+='.contains(buttonText)) {
      color = Colors.blueGrey[700]!;
    }
    if (buttonText == '=') {
      color = Colors.orange[800]!;
    }

    return Container(
      margin: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          textStyle: const TextStyle(fontSize: 22.0),
        ),
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(buttonText),
      ),
    );
  }
}

// The entire DatabaseHelper class has been REMOVED