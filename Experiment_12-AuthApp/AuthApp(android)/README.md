🔐 AuthApp: Android Firebase Authentication Template
This is a comprehensive Android application built using Kotlin and Firebase that demonstrates three core user authentication methods in a modern, modular design.

✨ Features
Email/Password Authentication: Secure Sign Up and Log In functionality.

Google Sign-In: One-tap sign-in using Google accounts (OAuth).

Phone Number Verification: Secure sign-in using SMS verification (OTP).

Secure Navigation: Dedicated screens for Login and Registration, with secure redirection to the main HomeActivity upon successful authentication.

Logout Functionality: Full session management allowing users to securely sign out.

⚙️ Prerequisites
To run and modify this app, you need:

Android Studio (Latest Stable Version).

A Firebase Project: A dedicated project set up in the Google Firebase Console.

Google Services Plugin: Applied in your project's build.gradle files.

Java Development Kit (JDK) 11 or higher.

🚀 Setup and Installation
Follow these steps to link the app to your own Firebase backend.

1. Configure Firebase Authentication
In your Firebase Console for this project, you must enable the following sign-in methods under Authentication → Sign-in method:

Email/Password: Enable.

Google: Enable and ensure you select a Support email.

Phone: Enable. (For testing, add a Test phone number and a Test verification code in the same tab).

2. Add SHA-1 Fingerprint
For Google Sign-In and Phone Number authentication to work on your local device/emulator, you must register your debug certificate's SHA-1 key:

In Android Studio, open the Gradle pane (on the right).

Navigate to AuthApp → Tasks → android → signingReport.

Copy the SHA1 key displayed in the Run window.

Paste this SHA-1 key into your Firebase Console → Project Settings → Your Apps → Add fingerprint.

3. Link google-services.json
After configuring the SHA-1 key in Firebase, download the latest google-services.json configuration file from the Project Settings page.

Place this file directly into the app/ module directory of your Android Studio project.

4. Build the Project
Open the project in Android Studio.

Go to Build → Clean Project.

Go to Build → Rebuild Project.

The app is now configured and ready to run on an emulator or physical device.

💻 Project Structure Highlights
File/Activity	Purpose	Key Functionality
MainActivity.kt	Login/Welcome Screen	Handles Email Log In and Google Sign-In. Routes to RegisterActivity and PhoneAuthActivity.
RegisterActivity.kt	Account Creation	Handles Email Sign Up and navigation to HomeActivity upon success.
PhoneAuthActivity.kt	Phone/OTP Verification	Manages the complex Firebase SMS code flow using callbacks.
HomeActivity.kt	Main App Screen	Displays logged-in user info and handles Logout (session termination).
AndroidManifest.xml	Configuration	Registers all Activities and sets the launch screen.

Export to Sheets

🐞 Troubleshooting
If you encounter issues during testing:

Symptom	Cause	Solution
App Crashes on Click	Activity not declared in the manifest.	Verify all activities (RegisterActivity, PhoneAuthActivity, HomeActivity) are listed in AndroidManifest.xml.
"Authentication Failed"	Incorrect Firebase config or missing user.	1. Ensure you have successfully signed up for a user first. 2. Verify the SHA-1 fingerprint and re-download google-services.json.
Google Sign-In fails	Incorrect SHA-1 key is registered in Firebase.	Follow Step 2 to re-verify and update the SHA-1 key and download the latest google-services.json.
Phone Sign-in fails	Quota exceeded or test numbers not configured.	Use the Test Phone Numbers and codes set up in the Firebase Console.


OUTPUT VIDEO:
https://drive.google.com/drive/folders/1jowIonfF3u2jXGK-tNEXDy4mlIcvDVCS?usp=drive_link