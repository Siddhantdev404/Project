Flutter Firebase Auth App (Experiment 12)

This is a Flutter application built to fulfill the requirements of Experiment 12. It demonstrates a complete user authentication flow using Firebase Authentication, including multiple sign-in providers and a protected home screen.

Features

[x] Email & Password Sign Up: Create new users with email and password.

[x] Email & Password Sign In: Log in existing users.

[x] Google Sign-In: Authenticate using a Google account (configured for both Android and Web).

[x] Phone Number (OTP) Sign-In: Authenticate using a phone number and a one-time password (configured for Android).

[x] Password Reset: A "Forgot Password" flow that sends a reset email.

[x] Protected Route: A core AuthWrapper widget that shows the login page if the user is signed out and the HomeScreen if they are signed in.

[x] Detailed Error Handling: Shows user-friendly snackbar messages for common errors (e.g., "user-not-found", "wrong-password", "invalid-otp").

Screens

Login / Sign Up Screen: A single screen that toggles between Login and Sign Up forms.

Phone Sign-In Screen: A two-step process:

Enter phone number to receive OTP.

Enter 6-digit OTP to verify.

Forgot Password Screen: A simple screen to request a password reset email.

Home Screen: A protected dashboard page that shows the user's email, display name (from Google), or phone number.

Tech Stack

Flutter

Firebase Authentication

firebase_core

firebase_auth

google_sign_in

Complete Firebase Setup Guide (From Scratch)

These are all the steps required to get this project running.

Step 1: Create Firebase Project

Go to the Firebase Console and create a new project (e.g., authapp-82214).

Step 2: Install FlutterFire CLI

If you haven't already, install the Firebase CLI tools:

dart pub global activate flutterfire_cli


Step 3: Configure Your App

From the root of this project folder, run:

flutterfire configure


Select your Firebase project.

Select all platforms (Android, iOS, Web, etc.).

This command will automatically:

Generate lib/firebase_options.dart.

Download the google-services.json file into the android/app/ folder.

Step 4: Enable Authentication Providers

In the Firebase Console, go to Build > Authentication.

Click the Sign-in method tab.

Enable the following three providers:

Email/Password

Google (set your project's support email)

Phone

Step 5: Configure Android (for Google & Phone Sign-In)

This is the most important step for making Google and Phone auth work on your Android device.

You must add your computer's SHA-1 debug key to Firebase.

Open a terminal and navigate into the android folder of your project:

cd android


Run the signing report command:

On Windows: .\gradlew signingReport

On Mac/Linux: ./gradlew signingReport

Find the debug variant and copy its SHA1 key. (It looks like 78:7C:E2:...).

In the Firebase Console, go to Project Settings (click the gear icon ⚙️).

Scroll down to "Your apps" and click on your Android app (com.example.auth_app).

Click "Add fingerprint" and paste your SHA-1 key.

Step 6: Configure Web (for Google Sign-In)

The flutterfire configure command often forgets to add the Web Client ID.

Go to the Google Cloud Console: console.cloud.google.com

Make sure your authapp-82214 project is selected at the top.

Go to APIs & Services > Credentials.

Under the "OAuth 2.0 Client IDs" section, click on the name of your "Web client".

Copy the "Client ID" (it ends in .apps.googleusercontent.com).

Open your lib/firebase_options.dart file.

Paste this ID into the web section, adding the clientId: property:

static const FirebaseOptions web = FirebaseOptions(
  apiKey: '...',
  appId: '...',
  messagingSenderId: '...',
  projectId: '...',
  authDomain: '...',
  storageBucket: '...',
  measurementId: '...',
  // --- ADD THIS LINE ---
  clientId: 'YOUR-ID-FROM-GOOGLE-CLOUD.apps.googleusercontent.com',
);


How to Run the App

Get Packages:

flutter pub get


Run on Android (Recommended):

Make sure your phone is plugged in or an emulator is running.

  flutter run


Run on Web:

  flutter run -d chrome


Note: If you see a red error, do a Hard Reload (Ctrl+Shift+R) to clear the browser's cache.

How to Test Phone Auth (For Free)

Firebase requires a "Blaze" (Pay-as-you-go) plan to send real SMS messages. To test for free, you must use a test phone number.

In the Firebase Console > Authentication > Sign-in method > Phone.

Scroll down to "Phone numbers for testing".

Click "Add phone number".

Phone number: +919518548334 (or any test number you want)

Verification code: 123456 (or any 6-digit code)

Now, in the app, enter +919518548334. When it asks for the OTP, enter 123456. You will be logged in successfully.



OUTPUT VIDEO:
https://drive.google.com/drive/folders/1uMhC_55DXqTxdp_vBI6qLGW31WA6hNo2?usp=drive_link