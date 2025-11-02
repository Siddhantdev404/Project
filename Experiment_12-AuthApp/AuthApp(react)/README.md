Experiment 12: Firebase Authentication App (React Native & Expo)

This project is a React Native mobile application built with Expo (and Expo Router) that demonstrates a complete user authentication flow using Firebase Authentication.

It fulfills all the core requirements outlined in expt 12.txt, including:

Email/Password Sign-Up & Sign-In

Google Sign-In

Phone Number (OTP) Sign-In

Password Reset (Forgot Password)

Protected routes ("Auth Guard") to show a "Home" screen only to logged-in users.

Detailed logging and error handling for common auth errors.

This app uses the Firebase SDK method, meaning all UI components are built from scratch, rather than using the pre-built "FirebaseUI" method.

Features Implemented

Email/Password: Full sign-up and sign-in flow.

Google Sign-In: One-tap sign-in with Google.

Phone OTP: A multi-step flow to send a verification code and sign in.

Password Reset: A "Forgot Password" flow that sends a reset email.

Auth Guard: The app uses an "Auth Observer" in the root layout (app/_layout.tsx) to automatically redirect users to the login screen if they are logged out, or to the (tabs) (home) screen if they are logged in.

Custom UI: The login screen is styled to match the provided design, with toggles for "Sign In" vs. "Sign Up" and a separate flow for phone/OTP.

Technology Stack

React Native

Expo (Development Build): This project requires a development build and will not run in the Expo Go app.

Expo Router: Used for all file-based navigation and protected routes.

Firebase Authentication:

@react-native-firebase/app

@react-native-firebase/auth

Google Sign-In:

@react-native-google-signin/google-signin

TypeScript

Complete Setup & Installation Guide

This project requires a very specific and precise configuration to work. Please follow these steps exactly.

0. Prerequisites

You must have Android Studio installed. This is required to get the Android SDK and adb tools that Expo needs to build your app.

Install Android Studio (Standard installation).

After installation, configure your Environment Variables to add the Android SDK to your system's Path. This fixes the adb not found error.

Add ANDROID_HOME as a variable (e.g., C:\Users\YourName\AppData\Local\Android\Sdk).

Add %ANDROID_HOME%\platform-tools to your Path variable.

Restart your computer after editing your Path.

1. Firebase Project Setup

Create a new project in the Firebase Console.

Add an Android app to the project.

Use the package name: com.authapp.app.

In the Authentication > Sign-in method tab, enable the following providers:

Email/Password

Google (select a project support email)

Phone

2. Phone Sign-In Fix (The BILLING_NOT_ENABLED Error)

Firebase requires billing to be enabled to send SMS messages.

In the Firebase Console, find your project's plan (it will say "Spark Plan").

Click "Upgrade" and select the "Blaze (pay as you go)" plan.

Link a billing account. You will not be charged; the Blaze plan includes a free tier of 10,000 phone verifications per month.

(Optional) You can add test phone numbers (like +91 9518548334) in the Phone Auth settings to bypass needing a real SMS.

3. Google Sign-In Fix (The DEVELOPER_ERROR & No ID Token Fix)

This is the most critical part of the setup. It requires fixing your app's "digital passport" (SHA-1) and Google Cloud settings.

Part A: Add the Correct SHA-1 Keys to Firebase

Open your project in a terminal.

Navigate into the android folder: cd android

Run the signing report to get your local debug keys: .\gradlew.bat signingReport

This will print many keys. Copy the two SHA-1 keys for the debug variants:

5E:8F:16:06:2E:A3:CD:2C:4A:0D:54:78:76:BA:A6:F3:8C:AB:F6:25 (from :app:signingReport)

78:7C:E2:00:29:44:8D:09:B6:6D:68:97:C6:00:22:69:C0:C0:8D:1C (from the other tasks)

Go to your Firebase Console -> Project Settings (gear icon) -> Android app.

Click "Add fingerprint" and add the first key.

Click "Add fingerprint" again and add the second key. You should now have at least these two keys listed.

Part B: Download the New Config File

On that same page, after saving the new keys, download a fresh google-services.json file.

Place this file in the root of your AuthApp project, replacing the old one.

Part C: Configure Google Cloud Console

Go to the Google Cloud Console Credentials Page.

At the top, select your project: authapp-82214.

Under "OAuth 2.0 Client IDs," click on the name of the "Web client" (the one ending in ...1j3f...).

Scroll down to "Authorized JavaScript origins" and click "ADD URI".

Add this URI: https://auth.expo.io

Click "ADD URI" again and add this URI: https://authapp-82214.firebaseapp.com

Click "SAVE".

4. How to Run the App (The "Nuke from Orbit" Build)

Now that your configuration is 100% correct, you must build a clean app.

Go to your project's root folder (run cd .. if you are still in the android folder).

Run these commands one by one, using PowerShell:

# 1. Delete the stale android build
Remove-Item -Path android -Recurse -Force

# 2. Delete the stale code libraries
Remove-Item -Path node_modules -Recurse -Force

# 3. Re-install fresh libraries
npm install

# 4. Create a new, clean android build folder
npx expo prebuild

# 5. Build and install the app on your phone
# (Make sure your phone is plugged in with USB Debugging enabled)
npx expo run:android


This will build and launch the app on your phone. All errors should be resolved, and all features (Email, Google, and Phone) will work.

Project Q&A (from expt 12.txt)

1. Explain the diff b/w firebaseui and sdk

FirebaseUI: This is a pre-built set of UI components (like a complete "drop-in" login screen) that handles all the logic for you. It's very fast to implement but hard to customize.

Firebase SDK (This Project): This is the core library. It gives you the functions (e.g., auth().signInWithEmail..., auth().signInWithGoogle...) but provides no UI. You must build all the text boxes, buttons, and error messages yourself. This is more work but gives you 100% control over the look and feel.

2. Why do u need SHA1 for google phones or android?
The SHA-1 key is a "digital passport" or "fingerprint" for your app. Google Sign-In is a high-security feature. To prevent other apps from impersonating your app, Google requires your app to present this unique passport. We must add the SHA-1 to the Firebase Console to put our app on the "guest list," proving it's an authorized user. The DEVELOPER_ERROR is what happens when your app's passport doesn't match the guest list.

3. How does the auth observer control navigation?
The "auth observer" is a real-time listener (auth().onAuthStateChanged(...)) that Firebase provides. We placed this listener in the root layout file (app/_layout.tsx).

When the app starts, the listener checks if a user is logged in.

If the user is null, it forces a redirect to the /login screen.

If the user is not null (meaning they just logged in), it forces a redirect to the main app (/).

When you call auth().signOut(), the observer fires again, sees the user is now null, and automatically redirects you back to /login.

4. What security measures exist against automated sms abuse?
This is a critical security concern. Your expt 12.txt file mentions two:

reCAPTCHA: Firebase automatically uses reCAPTCHA verification (the "I'm not a robot" test, which is often invisible) to ensure the request is coming from a real user and not a bot trying to send thousands of SMS messages.

Billing Plan: The [auth/billing-not] error we saw is a security measure. By requiring a billing plan ("Blaze"), Firebase makes it impossible for an attacker to run up a huge SMS bill on a free, anonymous project. It ensures a real person is accountable for the project's usage.


OUTPUT VIDEO:
https://drive.google.com/drive/folders/1YEdqmSJfZmqpUpWeCAIHfeIYxa6k-Yb2?usp=drive_link