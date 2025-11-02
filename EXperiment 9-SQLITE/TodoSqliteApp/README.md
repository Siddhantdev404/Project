\📝 Firebase ToDo List (React Native + Expo)
This is a real-time, cloud-backed ToDo list application built with React Native (managed by Expo) and Firebase Firestore for synchronization across devices.

🌟 Features
Cloud Persistence: All data (tasks) is stored in Firebase Firestore, ensuring persistence and synchronization.

Real-time Updates: Uses Firestore's real-time subscriptions to instantly update the UI.

CRUD Operations: Full Create, Read (Listener), Update, and Delete functionality.

Task History: Tracks task completion time using Firebase serverTimestamp() and displays a dedicated history screen.

TypeScript: Built using TypeScript (.tsx and .ts) for robust code quality.

🛠️ Project StructureThe key custom files in your project are:File NameLocationResponsibilityapp/(tabs)/index.tsxNestedMain ToDo List UI and screen switching logic.HistoryScreen.tsxRootComponent for displaying completed task history.firebaseConfig.tsRootInitializes the Firebase SDK with project credentials.firestoreService.tsRootContains all real-time subscriptions and CRUD functions (Firestore interactions).


🚀 Setup and InstallationPrerequisitesNode.js (v18+ recommended)npm or yarnExpo Go app installed on your phone.InstallationInstall Firebase:Bashnpm install firebase
# OR
npx expo install firebase
Firebase Configuration Steps (CRITICAL)Firebase Console: Create a project in the Firebase Console. Enable Firestore Database in test mode.Fill firebaseConfig.ts: Ensure your firebaseConfig.ts file contains your actual credentials.Create Composite Index (REQUIRED):Because your history query uses a filter (where('is_done')) and sorting (orderBy('completed_at')), Firestore requires a Composite Index.When you run the app for the first time, an error message will appear in the console.Click the URL provided in that console error log.This link will take you directly to the Firebase Console to create the required index. Click "Create".Wait 5-10 minutes for the index to finish building before the history feature will work without errors.

▶️ Running and TestingStart the Server:Bashnpx expo start
Connect Mobile Device: Scan the QR code with the Expo Go app.Monitor: Press j in the terminal to open the Chrome Debugger and confirm that data is being read from and written to Firestore.

OUTPUT VIDEO:

https://drive.google.com/drive/folders/1DO2L0bz4jlphWhHCeVGWjx4DyxgCzQCq?usp=drive_link