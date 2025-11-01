import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Main function to run the app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  
  // 1. REMOVED the GlobalKey line

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

  // 2. UPDATED this function to use setState()
  Future<void> _saveToHistory(String calculation) async {
    await DatabaseHelper.instance.insertHistory(calculation);
    // Trigger the page to rebuild, which refreshes the FutureBuilder
    setState(() {});
  }

  // Build the calculator UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Calculator (SQLite)'),
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
          
          // --- THIS IS THE CORRECTED LAYOUT FOR HISTORY ---
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title for the history section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Local History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                
                // Local History List
                Expanded(
                  child: _buildLocalHistory(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for local history from SQLite
  Widget _buildLocalHistory() {
    return FutureBuilder<List<String>>(
      // 3. REMOVED the 'key' property from here
      future: DatabaseHelper.instance.getHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No local history yet.'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(snapshot.data![index]),
              dense: true,
            );
          },
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
          // --- THIS TYPO IS NOW FIXED ---
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
  
  // --- THE STRAY FUNCTION HAS BEEN REMOVED FROM HERE ---
}

// Singleton class to manage the SQLite database
class DatabaseHelper {
  static const _databaseName = "CalculatorHistory.db";
  static const _databaseVersion = 1;

  static const table = 'history';
  static const columnId = '_id';
  static const columnCalculation = 'calculation';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create it if it doesn't exist
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnCalculation TEXT NOT NULL
          )
          ''');
  }

  // Helper method to insert a calculation into the database
  Future<int> insertHistory(String calculation) async {
    Database db = await instance.database;
    return await db.insert(table, {columnCalculation: calculation});
  }

  // Helper method to get all calculations from the database
  Future<List<String>> getHistory() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: '$columnId DESC',
    );
    return List.generate(maps.length, (i) {
      return maps[i][columnCalculation];
    });
  }
}