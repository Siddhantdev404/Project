# 🧮 Flutter Firebase Calculator

A simple, functional calculator app built with Flutter. It performs all basic arithmetic operations and features a **real-time cloud-based history** that saves all calculations to **Firebase Cloud Firestore**.

## 📸 Screenshot



## ✨ Features

* **Standard Calculator:** Performs addition, subtraction, multiplication, division, and percentage calculations.
* **Utility Buttons:** Includes 'C' (Clear), '⌫' (Backspace), and '00' for ease of use.
* **Real-time Cloud History:** Every calculation is automatically saved to a Cloud Firestore collection.
* **Live Updates:** The history list updates instantly across all devices using a `StreamBuilder` connected to Firestore.
* **Error Handling:** Displays "Error" for any malformed expressions (e.g., "5++2").
* **Clean UI:** A dark-mode, responsive layout built using Flutter's `GridView` and `Expanded` widgets.

## 🛠️ Technologies Used

This project is built using:

* **[Flutter](https://flutter.dev/):** The cross-platform UI toolkit.
* **[Dart](https://dart.dev/):** The programming language for Flutter.
* **[Firebase Core](https://pub.dev/packages/firebase_core):** Required to initialize a Firebase app in Flutter.
* **[Cloud Firestore](https://pub.dev/packages/cloud_firestore):** A flexible, scalable NoSQL cloud database to store and sync data.
* **[math_expressions](https://pub.dev/packages/math_expressions):** A library used to parse and evaluate the string expression to get the correct mathematical result.

## 🚀 Getting Started

To run this project, you **must** configure Firebase.

### 1. Flutter Setup

1.  **Clone the repository** (or download the source code):
    ```bash
    git clone <your-repository-url-here>
    cd <repository-directory>
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

### 2. Firebase Project Setup

1.  **Create a Firebase Project:** Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.

2.  **Install the Firebase CLI:** If you don't have it, install the Firebase command-line tool:
    ```bash
    npm install -g firebase-tools
    ```

3.  **Configure Firebase in your App:**
    * Log in to the CLI: `firebase login`
    * Activate the FlutterFire CLI: `dart pub global activate flutterfire_cli`
    * From your project's root directory, run the `configure` command:
        ```bash
        flutterfire configure
        ```
    * This command will automatically register your app for Android, iOS, and Web (if desired) and generate the `lib/firebase_options.dart` file.

4.  **Set up Firestore Database:**
    * In the Firebase Console, go to the "Firestore Database" section.
    * Click "Create database".
    * Start in **Test Mode**. This will allow read/write access for development.
        > **Important:** For a production app, you must set up proper [security rules](https://firebase.google.com/docs/firestore/security/get-started) to protect your data.
    * Choose a location for your database.

5.  **Run the app:**
    Connect a device or start an emulator, then run:
    ```bash
    flutter run
    ```
    Your first calculation should now appear in the Firebase Console!

## 📂 Code Structure

The entire application logic is contained in `lib/main.dart`:

* **`main()` (async function):** Now responsible for initializing Firebase with `Firebase.initializeApp()` before running the app.
* **`CalculatorApp` (StatelessWidget):** The root `MaterialApp` widget.
* **`CalculatorHomePage` (StatefulWidget):** The main screen of the app.
    * Manages the state for `_expression` and `_result`.
    * `_onButtonPressed()`: The core logic for handling all button taps.
    * `_saveToHistory()`: An `async` method that adds a new document to the `history` collection in Firestore. It includes the calculation string and a `serverTimestamp`.
    * `_buildFirebaseHistory()`: A **`StreamBuilder`** that listens to the `history` collection (ordered by timestamp) and automatically rebuilds the `ListView` whenever the data changes in the cloud.

    OUTPUT VIDEO:
    
    https://drive.google.com/drive/folders/1hBNfrflRYTUQ8FTOPHM_Ad2SqSn3m75g?usp=drive_link