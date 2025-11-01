import React, { useState, useEffect } from 'react';
import { Stack, useRouter, useSegments } from 'expo-router';
import auth, { FirebaseAuthTypes } from '@react-native-firebase/auth';
import { LogBox } from 'react-native';

// This ignores the 'deprecated' warnings from Firebase in your app
LogBox.ignoreLogs([
  "This method is deprecated",
  "SafeAreaView has been deprecated"
]);

/**
 * This custom hook checks the auth state and navigates the user.
 */
function useAuthObserver() {
  const [user, setUser] = useState<FirebaseAuthTypes.User | null>(null);
  const [isReady, setIsReady] = useState(false);
  const router = useRouter();
  const segments = useSegments(); // Gets the current URL segments

  useEffect(() => {
    // The 'onAuthStateChanged' observer fires when the user signs in or out
    const unsubscribe = auth().onAuthStateChanged((currentUser) => {
      console.log('Auth state changed, user:', currentUser ? currentUser.email : 'null');
      setUser(currentUser);
      setIsReady(true); // Now we know the auth state
    });
    
    // Clean up the subscription on unmount
    return () => unsubscribe();
  }, []);

  useEffect(() => {
    if (!isReady) {
      return; // Wait for the auth state to be determined
    }

    const inAuthGroup = segments[0] === '(tabs)';

    // --- This is the core navigation logic ---
    if (user && !inAuthGroup) {
      // User is logged in, redirect them to the (tabs) section.
      console.log('User is logged in, redirecting to /');
      router.replace('/'); 
    } else if (!user && inAuthGroup) {
      // User is NOT logged in and is in the (tabs) section, redirect to login.
      console.log('User is not logged in, redirecting to /login');
      router.replace('/login');
    }
  }, [isReady, user, segments, router]); // Re-run this effect when state changes

  return { isReady };
}

/**
 * This is the Root Layout Component.
 */
export default function RootLayout() {
  const { isReady } = useAuthObserver();

  if (!isReady) {
    // You can show a loading spinner here, but for now, null is fine
    return null; 
  }

  // This Stack defines all the "screens" at the root of your app.
  return (
    <Stack>
      {/* The (tabs) layout is for your main protected app */}
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      {/* The login screen is for unauthenticated users */}
      <Stack.Screen name="login" options={{ title: 'Login', headerShown: false }} />
    </Stack>
  );
}

