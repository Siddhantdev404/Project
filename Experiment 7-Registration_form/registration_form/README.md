# registration_form

A new Flutter project.

This is a modern, visually striking registration form built with Flutter. It serves as a showcase for implementing **advanced custom theming**, a **dynamic gradient background**, and **robust form validation** using a single `StatefulWidget`.

---

## ✨ Features

* **Custom Global Theming:** Uses `ThemeData` to establish consistent, high-quality styling for all form elements:
    * **Input Decoration:** Applies a global style with rounded borders, a semi-transparent white fill, and a distinctive focus border (`Colors.deepPurpleAccent`).
    * **Elevated Button:** Defines a bold, elevated style with custom padding and font styling for the primary Call to Action (CTA).
* **Dynamic Background:** Features a multi-color **linear gradient** layered with large, translucent, animated circular elements created using a `Stack` and `Positioned` widgets.
* **Comprehensive Client-Side Validation:** Ensures data integrity using `GlobalKey<FormState>` and `TextFormField` validators for:
    * Required fields.
    * Valid email format (using RegExp).
    * Minimum password length and password matching.
    * Required acceptance of terms and conditions.
* **Diverse Input Fields:** Includes common form elements like `TextFormField`, `RadioListTile` (Gender), `DropdownButtonFormField` (Country), and a `Checkbox`.
* **UX Enhancements:** Provides immediate user feedback via `SnackBar` messages for both validation errors (e.g., missing terms) and successful submission.

---

## 🛠️ Getting Started

To run this project locally, follow these simple steps.

### 1. Prerequisites

You must have the Flutter SDK installed and configured on your system.

* **Flutter SDK** (3.0+ recommended)
* A running IDE (VS Code or Android Studio) with Flutter support.

### 2. Run the Application

1.  **Create a new Flutter project** (if the provided code isn't already inside one):
    ```bash
    flutter create creative_registration_app
    cd creative_registration_app
    ```
2.  **Replace `lib/main.dart`** with the entire provided source code.
3.  **Execute the application** from your terminal:
    ```bash
    flutter run
    ```
    The application will launch on your connected device or emulator.

---

## 📂 Key Code Structure

The entire application is self-contained in `lib/main.dart` and organized logically:

1.  **`MyApp`**: The root widget that sets up the `MaterialApp` and the custom **`ThemeData`**.
2.  **`RegistrationScreen`**: The main layout, responsible for the **gradient background** and positioning the decorative circles.
3.  **`RegistrationForm`**: The stateful core of the application, managing form controllers, handling **validation logic**, and processing the final submission data via `log()`.

### Excerpt: Custom Input Theming

This section shows how a consistent, modern input style is achieved globally:

```dart
// Inside MyApp's ThemeData
inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withAlpha(242), // 95% opacity
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
    ),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
    ),
    // ...
),