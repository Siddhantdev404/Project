📝 React Native ToDo App (SQLite / Firebase)This is a simple ToDo List application built with React Native (Expo) that demonstrates basic CRUD (Create, Read, Update, Delete) operations and screen navigation.The app supports two persistence layers:Local Persistence (using Expo's SQLite module)Cloud Persistence (using Firebase Firestore)

🚀 Getting Started1. PrerequisitesMake sure you have the following installed:Node.js (LTS version)Expo CLI:Bashnpm install -g expo-cli
The Expo Go app installed on your physical device or a running simulator/emulator.2. Project SetupBash# 1. Create a new Expo project
expo init ToDoApp
# Choose the "blank" template when prompted

# 2. Navigate into the project directory
cd ToDoApp
3. File StructureEnsure your project files are set up to match the import paths used in App.js:ToDoApp/
├── App.js                <-- Main application code
├── HistoryScreen.js      <-- Navigation target
├── package.json
└── (If using SQLite)
    └── database/
        └── index.js      <-- SQLite handlers
└── (If using Firebase)
    └── firebaseConfig.js <-- Firebase initialization


⚙️ Configuration 
(Choose Your Persistence Layer)You must configure the required dependencies and files based on whether you want to use SQLite or Firebase.Option A: Local Persistence (SQLite)This version uses the local database on the user's device.Install Dependency:Bashexpo install expo-sqlite
Restore SQLite Handlers: Ensure your database/index.js file contains the initDatabase, getTodos, addTodo, toggleTodoStatus, and deleteTodo functions using the expo-sqlite API. (The original App.js required these functions).Option B: Cloud Persistence (Firebase Firestore)This version uses the cloud to store and sync data in real-time.Install Dependency:Bashnpm install firebase
Firebase Setup:Create a Firebase project in the Firebase Console.Enable Firestore Database.Create a collection named todos.Create a file named firebaseConfig.js in the root directory and paste your configuration:firebaseConfig.js (Required):JavaScriptimport { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

// ⚠️ REPLACE WITH YOUR ACTUAL CONFIGURATION
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID", 
  // ... other configs
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export { db };
Use Updated App.js: Ensure you are using the Firebase-updated App.js code provided in the earlier response, which uses addDoc, onSnapshot, etc.▶️ Running the ApplicationStart the Expo server:Bashnpm start
# or
expo start
Launch the App:A browser window will open with the Expo Developer Tools.Scan the QR code with your Expo Go app on your phone, or press a (Android) or i (iOS) in the terminal to launch the simulator.The application will start, load existing tasks from your chosen persistence layer, and allow you to add, mark as done, or delete tasks.📁 Key FilesFileDescriptionApp.jsThe main application component. Contains all state management, CRUD logic (interfacing with SQLite or Firebase), and UI rendering.HistoryScreen.jsA simple placeholder screen demonstrating navigation.database/index.js(SQLite Only) Contains the wrapper functions for SQLite operations (initDatabase, addTodo, etc.).firebaseConfig.js(Firebase Only) Initializes the Firebase SDK and exports the Firestore database instance.



OUTPUT VIDEO:
https://drive.google.com/drive/folders/13f2pHhrnjrXKN-LPb3zVchsBnRiv3fXD?usp=drive_link