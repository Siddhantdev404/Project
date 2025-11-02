import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  Alert,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import auth, { FirebaseAuthTypes } from '@react-native-firebase/auth';
import { GoogleSignin } from '@react-native-google-signin/google-signin';
import { Ionicons } from '@expo/vector-icons'; // For icons

// --- Constants for colors ---
const COLORS = {
  primary: '#007AFF', // A nice blue for primary actions
  secondary: '#4CAF50', // Green for phone
  white: '#FFFFFF',
  black: '#000000',
  lightGray: '#F3F4F6',
  mediumGray: '#DDDDDD',
  darkGray: '#666666',
};

export default function LoginScreen() {
  // --- STATE ---
  const [isLoginMode, setIsLoginMode] = useState(true); // Toggle for Sign In / Sign Up
  const [isPhoneMode, setIsPhoneMode] = useState(false); // Toggle for Phone UI
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [confirm, setConfirm] = useState<FirebaseAuthTypes.ConfirmationResult | null>(null);
  const [code, setCode] = useState('');
  const [isLoading, setIsLoading] = useState(false); // For loading indicators

  // --- FIREBASE LOGIC ---

  useEffect(() => {
    GoogleSignin.configure({
      webClientId: '589015313996-1j3f6spm1tagdptvf8gv9lq9omao94s4.apps.googleusercontent.com',
      scopes: ['profile', 'email', 'openid'],
    });
  }, []);

  const onGoogleButtonPress = async () => {
    setIsLoading(true);
    try {
      // 1. Check for Play Services
      await GoogleSignin.hasPlayServices({ showPlayServicesUpdateDialog: true });
      
      // 2. Sign in on the device
      await GoogleSignin.signIn();
      
      // 3. GET THE TOKENS (THIS WAS THE MISSING STEP)
      const { idToken } = await GoogleSignin.getTokens();
      
      if (!idToken) throw new Error('Google Sign-In failed: No ID Token received.');
      
      // 4. Create a Firebase credential with the ID token
      const googleCredential = auth.GoogleAuthProvider.credential(idToken);
      
      // 5. Sign-in the user with the credential
      await auth().signInWithCredential(googleCredential);

    } catch (error: any) {
      Alert.alert('Error', error.message);
      console.error(error);
    }
    setIsLoading(false);
  };

  const handleSignUp = () => {
    if (email.length === 0 || password.length === 0) {
      Alert.alert('Error', 'Please enter both email and password.');
      return;
    }
    setIsLoading(true);
    auth()
      .createUserWithEmailAndPassword(email, password)
      .catch((error: any) => {
        if (error.code === 'auth/email-already-in-use') Alert.alert('Error', 'That email address is already in use!');
        else if (error.code === 'auth/invalid-email') Alert.alert('Error', 'That email address is invalid!');
        else if (error.code === 'auth/weak-password') Alert.alert('Error', 'Password is too weak (min 6 chars).');
        else Alert.alert('Error', error.message);
        console.error(error);
      })
      .finally(() => setIsLoading(false));
  };

  const handleSignIn = () => {
    if (email.length === 0 || password.length === 0) {
      Alert.alert('Error', 'Please enter both email and password.');
      return;
    }
    setIsLoading(true);
    auth()
      .signInWithEmailAndPassword(email, password)
      .catch((error: any) => {
        if (error.code === 'auth/user-not-found' || error.code === 'auth/wrong-password' || error.code === 'auth/invalid-credential') Alert.alert('Error', 'Invalid email or password.');
        else if (error.code === 'auth/invalid-email') Alert.alert('Error', 'That email address is invalid!');
        else Alert.alert('Error', error.message);
        console.error(error);
      })
      .finally(() => setIsLoading(false));
  };

  const handlePasswordReset = () => {
    if (email.length === 0) {
      Alert.alert('Error', 'Please enter your email address to reset your password.');
      return;
    }
    setIsLoading(true);
    auth()
      .sendPasswordResetEmail(email)
      .then(() => Alert.alert('Check Your Email', 'A password reset link has been sent.'))
      .catch((error: any) => {
        if (error.code === 'auth/user-not-found') Alert.alert('Error', 'No user found with that email address.');
        else if (error.code === 'auth/invalid-email') Alert.alert('Error', 'That email address is invalid!');
        else Alert.alert('Error', error.message);
        console.error(error);
      })
      .finally(() => setIsLoading(false));
  };

  const signInWithPhoneNumber = async () => {
    if (phoneNumber.length === 0) {
      Alert.alert('Error', 'Please enter a phone number.');
      return;
    }
    let formattedPhoneNumber = phoneNumber.trim();
    // This logic handles 10-digit, 12-digit (91...), and full +91 numbers
    if (!formattedPhoneNumber.startsWith('+')) {
      if (formattedPhoneNumber.length === 10) formattedPhoneNumber = `+91${formattedPhoneNumber}`;
      else if (formattedPhoneNumber.length === 12 && formattedPhoneNumber.startsWith('91')) formattedPhoneNumber = `+${formattedPhoneNumber}`;
    }
    
    setIsLoading(true);
    try {
      console.log('Sending code to:', formattedPhoneNumber);
      const confirmation = await auth().signInWithPhoneNumber(formattedPhoneNumber);
      setConfirm(confirmation); 
      Alert.alert('Code Sent', `A verification code has been sent to ${formattedPhoneNumber}`);
    } catch (error: any) {
      if (error.code === 'auth/billing-not') Alert.alert('Error', 'Phone Sign-In is not enabled. Please upgrade to the Blaze plan in your Firebase Console.');
      else Alert.alert('Error', `Failed to send code. Please check the number or format.\n(${error.message})`);
      console.error(error);
    }
    setIsLoading(false);
  };

  const confirmCode = async () => {
    if (code.length === 0) {
      Alert.alert('Error', 'Please enter the verification code.');
      return;
    }
    setIsLoading(true);
    try {
      await confirm?.confirm(code);
      // We don't need to reset state here, the auth observer will handle the redirect
    } catch (error: any) {
      Alert.alert('Error', 'Invalid verification code.');
      console.error(error);
    }
    setIsLoading(false);
  };

  // --- RENDER FUNCTION ---

  if (confirm) {
    return (
      <SafeAreaView style={styles.container}>
        <ScrollView contentContainerStyle={styles.scrollContainer}>
          <Text style={styles.title}>Enter Code</Text>
          <Text style={styles.subtitle}>Check your SMS messages for a 6-digit code.</Text>
          <TextInput
            style={styles.input}
            placeholder="6-digit code"
            onChangeText={setCode}
            value={code}
            keyboardType="number-pad"
            maxLength={6}
          />
          <TouchableOpacity style={styles.primaryButton} onPress={confirmCode} disabled={isLoading}>
            {isLoading ? <ActivityIndicator color={COLORS.white} /> : <Text style={styles.buttonText}>Confirm Code</Text>}
          </TouchableOpacity>
          <TouchableOpacity 
            style={styles.secondaryButton} 
            onPress={() => {
              setConfirm(null); 
              setIsPhoneMode(true); 
            }} 
            disabled={isLoading}
          >
            <Text style={styles.secondaryButtonText}>Back</Text>
          </TouchableOpacity>
        </ScrollView>
      </SafeAreaView>
    );
  }

  if (isPhoneMode) {
    return (
      <SafeAreaView style={styles.container}>
        <ScrollView contentContainerStyle={styles.scrollContainer}>
          <Text style={styles.title}>Sign In with Phone</Text>
          <Text style={styles.subtitle}>Enter your phone number to receive a code.</Text>
          <TextInput
            style={styles.input}
            placeholder="Phone Number (e.g., 9518548334)"
            onChangeText={setPhoneNumber}
            value={phoneNumber}
            keyboardType="phone-pad"
          />
          <TouchableOpacity style={styles.primaryButton} onPress={signInWithPhoneNumber} disabled={isLoading}>
            {isLoading ? <ActivityIndicator color={COLORS.white} /> : <Text style={styles.buttonText}>Send Code</Text>}
          </TouchableOpacity>
          <TouchableOpacity 
            style={styles.secondaryButton} 
            onPress={() => {
              setIsPhoneMode(false); 
              setIsLoginMode(true); 
            }} 
            disabled={isLoading}
          >
            <Text style={styles.secondaryButtonText}>Cancel</Text>
          </TouchableOpacity>
        </ScrollView>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <Text style={styles.title}>{isLoginMode ? 'Welcome Back!' : 'Create Account'}</Text>
        <Text style={styles.subtitle}>{isLoginMode ? 'Sign in to continue' : 'Sign up to get started'}</Text>

        {isLoginMode && (
          <>
            <TouchableOpacity style={styles.googleButton} onPress={onGoogleButtonPress} disabled={isLoading}>
              <Ionicons name="logo-google" size={20} color={COLORS.black} />
              <Text style={styles.socialButtonText}>Sign In with Google</Text>
            </TouchableOpacity>
            
            <TouchableOpacity 
              style={styles.phoneButton} 
              onPress={() => setIsPhoneMode(true)} 
              disabled={isLoading}
            >
              <Ionicons name="call-outline" size={20} color={COLORS.white} />
              <Text style={styles.buttonText}>Sign In with Phone</Text>
            </TouchableOpacity>

            <Text style={styles.separator}>OR</Text>
          </>
        )}
        
        <>
          <TextInput
            style={styles.input}
            placeholder="Email"
            onChangeText={setEmail}
            value={email}
            autoCapitalize="none"
            keyboardType="email-address"
          />
          <TextInput
            style={styles.input}
            placeholder="Password"
            onChangeText={setPassword}
            value={password}
            secureTextEntry // This is what makes the dots
          />
        </>
        
        {isLoginMode && (
          <TouchableOpacity onPress={handlePasswordReset}>
            <Text style={styles.linkText}>Forgot Password?</Text>
          </TouchableOpacity>
        )}
        
        <TouchableOpacity 
          style={styles.primaryButton} 
          onPress={isLoginMode ? handleSignIn : handleSignUp} 
          disabled={isLoading}
        >
          {isLoading ? (
            <ActivityIndicator color={COLORS.white} />
          ) : (
            <Text style={styles.buttonText}>{isLoginMode ? 'Sign In' : 'Sign Up'}</Text>
          )}
        </TouchableOpacity>

        <View style={styles.bottomToggle}>
          <Text style={styles.bottomToggleText}>
            {isLoginMode ? "Don't have an account?" : "Already have an account?"}
          </Text>
          <TouchableOpacity onPress={() => setIsLoginMode(!isLoginMode)}>
            <Text style={styles.bottomToggleLink}>{isLoginMode ? 'Sign Up' : 'Sign In'}</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

// --- STYLESHEET ---
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
  },
  scrollContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: 24,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: COLORS.black,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    color: COLORS.darkGray,
    textAlign: 'center',
    marginBottom: 32,
  },
  input: {
    height: 50,
    borderColor: COLORS.mediumGray,
    borderWidth: 1,
    borderRadius: 10,
    paddingHorizontal: 15,
    fontSize: 16,
    marginBottom: 16,
    backgroundColor: COLORS.white,
    color: COLORS.black, // <-- THIS IS THE FIX FOR THE INVISIBLE TEXT
  },
  primaryButton: {
    backgroundColor: COLORS.primary,
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 10,
    height: 50,
  },
  buttonText: {
    color: COLORS.white,
    fontSize: 16,
    fontWeight: 'bold',
  },
  secondaryButton: {
    backgroundColor: COLORS.lightGray,
    padding: 15,
    borderRadius: 10,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 10,
    height: 50,
  },
  secondaryButtonText: {
    color: COLORS.black,
    fontSize: 16,
    fontWeight: 'bold',
  },
  googleButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.white,
    padding: 15,
    borderRadius: 10,
    borderColor: COLORS.mediumGray,
    borderWidth: 1,
    height: 50,
    marginBottom: 16,
  },
  socialButtonText: {
    color: COLORS.black,
    fontSize: 16,
    fontWeight: 'bold',
    marginLeft: 10,
  },
  phoneButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: COLORS.secondary,
    padding: 15,
    borderRadius: 10,
    height: 50,
    marginBottom: 16,
  },
  linkText: {
    color: COLORS.primary,
    textAlign: 'right',
    marginBottom: 20,
    fontWeight: 'bold',
  },
  separator: {
    color: COLORS.darkGray,
    textAlign: 'center',
    marginVertical: 16,
  },
  bottomToggle: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 24,
  },
  bottomToggleText: {
    color: COLORS.darkGray,
    fontSize: 14,
  },
  bottomToggleLink: {
    color: COLORS.primary,
    fontSize: 14,
    fontWeight: 'bold',
    marginLeft: 4,
  },
});

