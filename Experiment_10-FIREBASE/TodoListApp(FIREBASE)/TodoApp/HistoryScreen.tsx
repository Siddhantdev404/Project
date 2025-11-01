import React, { useState, useEffect, useCallback } from 'react';
import { StyleSheet, View, Text, FlatList, SafeAreaView, Button, Alert } from 'react-native';

// --- CORRECTED PATHS ---
// Adjust path if firestoreService.ts is not in the root
import { subscribeToHistory, Task } from './firestoreService'; // <-- CORRECTED: Use './'

/**
 * Helper function to format the timestamp (which can be a Date or null/undefined).
 */
const formatDate = (date: Date | undefined): string => {
  if (!date) return 'N/A';
  // Check if it's a valid Date object before formatting
  if (date instanceof Date && !isNaN(date.getTime())) {
    return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
  return 'Processing...'; // When Firebase serverTimestamp is still pending
};

// Define props interface for the component
interface HistoryScreenProps {
    onBack: () => void;
}

export default function HistoryScreen({ onBack }: HistoryScreenProps) {
  const [history, setHistory] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);

  // --- Real-Time Subscription (READ History) ---
  useEffect(() => {
    // History data is fetched via a real-time subscription
    const unsubscribe = subscribeToHistory((newHistory: React.SetStateAction<Task[]>) => {
        setHistory(newHistory);
        setLoading(false);
    });

    // Cleanup function: Unsubscribe when the component unmounts
    return () => unsubscribe();
  }, []);

  // --- UI Components ---
  
  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <Text style={styles.header}>Loading History...</Text>
      </View>
    );
  }

  const HistoryItem = ({ item }: { item: Task }) => (
    <View style={styles.historyItem}>
      <Text style={styles.historyText}>{item.value}</Text>
      {/* completed_at is now a Date object or undefined */}
      <Text style={styles.dateText}>Completed: {formatDate(item.completed_at)}</Text>
    </View>
  );

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <View style={styles.headerRow}>
          <Text style={styles.header}>Task History</Text>
          <Button title="Back to List" onPress={onBack} />
        </View>
        
        <FlatList
          data={history}
          keyExtractor={(item) => item.id} // Firebase IDs are strings
          renderItem={({ item }) => <HistoryItem item={item} />}
          style={styles.list}
          ListEmptyComponent={<Text style={styles.emptyText}>No completed tasks found in history.</Text>}
        />
      </View>
    </SafeAreaView>
  );
}

// --- Styles ---
const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: '#fff' },
  container: { flex: 1, paddingTop: 20, paddingHorizontal: 20 },
  loadingContainer: { flex: 1, justifyContent: 'center', alignItems: 'center' },
  headerRow: { 
    flexDirection: 'row', 
    justifyContent: 'space-between', 
    alignItems: 'center',
    marginBottom: 20 
  },
  header: { fontSize: 24, fontWeight: 'bold', color: '#2c3e50' },
  list: { flex: 1, marginTop: 15 },
  historyItem: {
    padding: 15,
    marginVertical: 5,
    backgroundColor: '#e8f6f3',
    borderRadius: 8,
    borderLeftWidth: 5,
    borderLeftColor: '#2ecc71',
    elevation: 2,
  },
  historyText: { fontSize: 16, color: '#2c3e50', marginBottom: 5 },
  dateText: { fontSize: 12, color: '#7f8c8d' },
  emptyText: { textAlign: 'center', marginTop: 50, color: '#95a5a6' },
});