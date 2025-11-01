# 🧮 Flutter SQLite Calculator

A simple, functional calculator app built with Flutter. It performs all basic arithmetic operations and features a persistent history section that saves all calculations locally using an **SQLite** database.

## 📸 Screenshot



## ✨ Features

* **Standard Calculator:** Performs addition, subtraction, multiplication, division, and percentage calculations.
* **Utility Buttons:** Includes 'C' (Clear), '⌫' (Backspace), and '00' for ease of use.
* **Persistent Local History:** Every calculation you complete is automatically saved to a local SQLite database.
* **Real-time History Display:** The history list updates instantly on the UI as new calculations are made.
* **Error Handling:** Displays "Error" for any malformed expressions (e.g., "5++2").
* **Clean UI:** A dark-mode, responsive layout built using Flutter's `GridView` and `Expanded` widgets.

## 🛠️ Technologies Used

This project is built using:

* **[Flutter](https://flutter.dev/):** The cross-platform UI toolkit.
* **[Dart](https://dart.dev/):** The programming language for Flutter.
* **[sqflite](https://pub.dev/packages/sqflite):** A Flutter plugin for SQLite, used for all local database operations (create, insert, query).
* **[path](https://pub.dev/packages/path):** Used to construct the correct database file path on the device's file system.
* **[math_expressions](https://pub.dev/packages/math_expressions):** A powerful library used to parse the string expression (e.g., "5+3*2") and evaluate it to get the correct mathematical result.

## 🚀 Getting Started

To run this project locally, follow these steps:

### Prerequisites

You must have the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.

### Installation & Running

1.  **Clone the repository** (or download the source code):
    ```bash
    git clone <your-repository-url-here>
    cd <repository-directory>
    ```

2.  **Install dependencies:**
    Open the project in your terminal and run:
    ```bash
    flutter pub get
    ```
    This will install `sqflite`, `path`, and `math_expressions`.

3.  **Run the app:**
    Connect a device or start an emulator, then run:
    ```bash
    flutter run
    ```

## 📂 Code Structure

The entire application logic is contained in `lib/main.dart`:

* **`CalculatorApp` (StatelessWidget):** The root `MaterialApp` widget that sets up the app's theme and title.
* **`CalculatorHomePage` (StatefulWidget):** The main screen of the app.
    * Manages the state for the current `_expression` and `_result`.
    * `_onButtonPressed()`: The core logic for handling all button taps.
    * `_saveToHistory()`: A method that calls the `DatabaseHelper` to insert a new calculation.
    * `_buildLocalHistory()`: A `FutureBuilder` that fetches and displays the list of calculations from the database.
* **`DatabaseHelper` (Singleton Class):**
    * Manages all database operations in a single instance.
    * `_initDatabase()`: Initializes and creates the 'history' table if it doesn't exist.
    * `insertHistory()`: Inserts a new calculation string into the database.
    * `getHistory()`: Queries the database and returns a `List<String>` of all calculations, ordered from newest to oldest.

## 📄 License

This project is open-source. Feel free to use this code as a reference or starting point for your own projects. Consider adding an [MIT License](https://opensource.org/licenses/MIT) if you make it public.