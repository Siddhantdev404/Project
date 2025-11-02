import React from 'react';
import { View, Text, Button, StyleSheet, SafeAreaView } from 'react-native';
import auth from '@react-native-firebase/auth';

export default function HomeScreen() {
  const user = auth().currentUser;

  const handleSignOut = () => {
    auth()
      .signOut()
      .then(() => {
        console.log('User signed out!');
        // Auth observer will handle the redirect to 'login'
      });
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <Text style={styles.title}>Welcome!</Text>
        <Text style={styles.email}>
          {/* This matches the requirement to show display name/email */}
          You are logged in as: {user ? user.email : '...'}
        </Text>
        <View style={styles.buttonContainer}>
          <Button title="Sign Out" onPress={handleSignOut} color="red" />
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  email: {
    fontSize: 16,
    color: 'gray',
    marginBottom: 20,
  },
  buttonContainer: {
    marginTop: 20,
  },
});
