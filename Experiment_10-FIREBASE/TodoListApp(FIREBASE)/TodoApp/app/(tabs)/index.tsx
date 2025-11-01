import React, { useState, useEffect, useCallback } from 'react';
import { 
  StyleSheet, 
  View, 
  Text, 
  TextInput, 
  Button, 
  FlatList, 
  TouchableOpacity,
  SafeAreaView,
  Alert 
} from 'react-native';
import { StatusBar } from 'expo-status-bar';

// --- CORRECTED PATHS ---
// Imports from the Firebase service file (adjust path if firestoreService.ts is not in the root)
import { 
  subscribeToTasks, 
  addTask, 
  toggleTaskStatus, 
  deleteTask,
  Task // Import the type from the service file
} from '../../firestoreService';

import HistoryScreen from '../../HistoryScreen'; // Corrected path from earlier
// -----------------------

// The Task interface is imported from firestoreService, so we don't need to define it here.

export default function App() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [newTaskText, setNewTaskText] = useState('');
  const [screen, setScreen] = useState<'list' | 'history'>('list'); 
  const [loading, setLoading] = useState(true); // Added loading state for initial load

  // --- Real-Time Subscription (READ) ---
  useEffect(() => {
    if (screen !== 'list') return;
    
    setLoading(true);

    // Use the real-time subscription provided by Firestore
    const unsubscribe = subscribeToTasks((newTasks) => {
        setTasks(newTasks);
        setLoading(false);
    });

    // Cleanup function: Unsubscribe when the component unmounts or screen changes
    return () => unsubscribe();
  }, [screen]); 

  // --- Handlers (CRUD Operations) ---

  const handleAddTask = async () => {
    if (newTaskText.trim() === '') return;
    
    try {
      // CREATE: The service adds the task, and the listener updates the state automatically.
      await addTask(newTaskText.trim()); 
      setNewTaskText('');
    } catch (error) {
      console.error('Error adding task:', error);
      Alert.alert('Error', 'Could not add task to Firebase.');
    }
  };
  
  const handleDelete = async (id: string) => {
    try {
      // DELETE: The service deletes the document, and the listener updates the state.
      await deleteTask(id);
    } catch (error) {
      console.error('Error deleting task:', error);
      Alert.alert('Error', 'Could not delete task from Firebase.');
    }
  };
  
  const handleToggleStatus = async (id: string, currentStatus: boolean) => {
    const newStatus = !currentStatus;
    try {
      // UPDATE: The service updates the status, and the listener updates the state.
      await toggleTaskStatus(id, newStatus);
    } catch (error) {
      console.error('Error toggling status:', error);
      Alert.alert('Error', 'Could not update task status.');
    }
  };

  // --- UI Component for a single Task Item ---
  const TaskItem = ({ item }: { item: Task }) => (
    <View style={styles.taskItem}>
      <TouchableOpacity 
        onPress={() => handleToggleStatus(item.id, item.is_done)} 
        style={styles.textContainer}
      >
        <Text style={[styles.taskText, item.is_done && styles.doneText]}>
          {item.value}
        </Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={() => handleDelete(item.id)} style={styles.deleteButton}>
        <Text style={styles.deleteButtonText}>X</Text>
      </TouchableOpacity>
    </View>
  );
  // ------------------------------------------

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <Text style={styles.header}>Connecting to Firebase...</Text>
      </View>
    );
  }

  // Handle screen switching logic
  if (screen === 'history') {
    return <HistoryScreen onBack={() => setScreen('list')} />;
  }

  // --- Main ToDo List View ---
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <View style={styles.headerRow}>
          <Text style={styles.header}>Firebase ToDo List</Text>
          <Button title="View History" onPress={() => setScreen('history')} />
        </View>

        {/* Input Section */}
        <View style={styles.inputContainer}>
          <TextInput
            style={styles.input}
            placeholder="New task..."
            value={newTaskText}
            onChangeText={setNewTaskText}
            onSubmitEditing={handleAddTask} 
          />
          <Button title="Add" onPress={handleAddTask} />
        </View>

        {/* ToDo List */}
        <FlatList
          data={tasks}
          keyExtractor={(item) => item.id} // Firebase IDs are strings
          renderItem={TaskItem}
          style={styles.list}
          ListEmptyComponent={<Text style={styles.emptyText}>No tasks! Add one to begin.</Text>}
        />

        <StatusBar style="auto" />
      </View>
    </SafeAreaView>
  );
}

// --- Styles (Same as previous versions) ---
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
  inputContainer: { flexDirection: 'row', marginBottom: 20, alignItems: 'center' },
  input: { flex: 1, borderWidth: 1, borderColor: '#ccc', padding: 10, marginRight: 10, borderRadius: 8 },
  list: { flex: 1 },
  taskItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 15,
    marginVertical: 5,
    backgroundColor: '#ecf0f1',
    borderRadius: 8,
    borderLeftWidth: 5,
    borderLeftColor: '#3498db',
    elevation: 2,
  },
  textContainer: { flex: 1, marginRight: 10 },
  taskText: { fontSize: 16, color: '#2c3e50' },
  doneText: { textDecorationLine: 'line-through', color: '#7f8c8d' },
  deleteButton: { backgroundColor: '#e74c3c', paddingHorizontal: 10, paddingVertical: 5, borderRadius: 5 },
  deleteButtonText: { color: 'white', fontWeight: 'bold' },
  emptyText: { textAlign: 'center', marginTop: 50, color: '#95a5a6', fontSize: 16 },
});