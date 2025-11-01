// HistoryScreen.tsx

import React, { useState, useEffect, useCallback } from 'react';
import { StyleSheet, View, Text, FlatList, SafeAreaView, Button, Alert } from 'react-native';
import { getHistoryTodos } from './database'; // Import from the new TS file

// NOTE: You must include the Task interface here for component typing
interface Task {
    id: number;
    value: string;
    is_done: boolean;
    created_at?: string;
    completed_at?: string;
}

/**
 * Helper function to format the ISO date string into a readable format.
 */
const formatDate = (isoString: string | undefined): string => {
  if (!isoString) return 'N/A';
  const date = new Date(isoString);
  return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
};

// Define props interface for the component
interface HistoryScreenProps {
    onBack: () => void;
}

export default function HistoryScreen({ onBack }: HistoryScreenProps) {
  const [history, setHistory] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);

  // --- Data Loading ---
  const loadHistory = useCallback(async () => {
    setLoading(true);
    try {
      const completedTasks = await getHistoryTodos();
      setHistory(completedTasks);
    } catch (error) {
      console.error('Failed to load history:', error);
      Alert.alert('Error', 'Could not load history data.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadHistory();
  }, [loadHistory]);

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
          keyExtractor={(item) => item.id.toString()}
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