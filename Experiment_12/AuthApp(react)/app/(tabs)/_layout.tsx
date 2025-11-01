import { Tabs } from 'expo-router';
import React from 'react';
// We need to install icons for this to work
import { Ionicons } from '@expo/vector-icons';

/**
 * This component sets up the tab bar at the bottom of the screen.
 */
export default function TabsLayout() {
  return (
    <Tabs
      screenOptions={({ route }) => ({
        // This function dynamically sets the icon for each tab
        tabBarIcon: ({ focused, color, size }) => {
          let iconName: keyof typeof Ionicons.glyphMap = 'help-circle';

          if (route.name === 'index') {
            // 'index' maps to app/(tabs)/index.tsx
            iconName = focused ? 'home' : 'home-outline';
          } else if (route.name === 'explore') {
            // 'explore' maps to app/(tabs)/explore.tsx
            iconName = focused ? 'compass' : 'compass-outline';
          }

          // Returns the icon component
          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: '#007AFF', // A standard blue color
        tabBarInactiveTintColor: 'gray',
        headerShown: false, // We hide the header for a cleaner look
      })}
    >
      <Tabs.Screen
        name="index" // This is the file app/(tabs)/index.tsx
        options={{
          title: 'Home', // This is the text on the tab
        }}
      />
      <Tabs.Screen
        name="explore" // This is the file app/(tabs)/explore.tsx
        options={{
          title: 'Explore', // This is the text on the tab
        }}
      />
    </Tabs>
  );
}

