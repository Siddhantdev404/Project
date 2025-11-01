// firebaseConfig.ts

import { initializeApp, FirebaseApp } from 'firebase/app';
import { getFirestore, Firestore } from 'firebase/firestore';

// Your actual Firebase project configuration
const firebaseConfig = {
    // API key from your project
    apiKey: "AIzaSyC9orfylDVgRqOBFG9l1qecpAglqzBNATU",
    
    // Auth domain and Project ID
    authDomain: "todolist-d4b81.firebaseapp.com",
    projectId: "todolist-d4b81",
    
    // Storage bucket and Sender ID
    storageBucket: "todolist-d4b81.firebasestorage.app",
    messagingSenderId: "730071110719",
    
    // App ID
    appId: "1:730071110719:web:620349a73f3f6c90f9948a",
    
    // measurementId is optional and not needed for basic Firestore access
    // measurementId: "G-RZX7YR6BXS" 
};

// Initialize Firebase App
const app: FirebaseApp = initializeApp(firebaseConfig);

// Initialize Firestore Database service (required for your ToDo app)
const db: Firestore = getFirestore(app);

// Export the database instance for use in firestoreService.ts
export { db };