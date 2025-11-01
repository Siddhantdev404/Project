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

// --- Type Definition for ToDo Item ---
// Ensure consistency across database and component state
interface Task {
    id: number;
    value: string;
    is_done: boolean;
    created_at?: string;
    completed_at?: string;
}
// --------------------------------------

// CORRECTED PATHS: Navigating up two directories to reach the root files
import { 
  initDatabase, 
  getTodos, 
  addTodo, 
  toggleTodoStatus, 
  deleteTodo 
} from '../../database'; 
import HistoryScreen from '../../HistoryScreen'; 

export default function App() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [newTaskText, setNewTaskText] = useState('');
  const [loading, setLoading] = useState(true); 
  const [screen, setScreen] = useState<'list' | 'history'>('list'); 

  // --- Data Loading Effect (READ operation) ---
  const loadData = useCallback(async () => {
    try {
      initDatabase(); 
      // getTodos returns an array of Task objects
      const storedTasks = await getTodos() as Task[]; 
      setTasks(storedTasks);
    } catch (error) {
      console.error('Failed to load tasks:', error);
      Alert.alert('Database Error', 'Could not load persistent data.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    // Only load data when viewing the list screen
    if (screen === 'list') {
      loadData();
    }
  }, [screen, loadData]); 
  // ---------------------------------------------


  // --- Handlers (CRUD Operations) ---

  const handleAddTask = async () => {
    if (newTaskText.trim() === '') return;

    try {
      // CREATE: Save to DB
      const insertId = await addTodo(newTaskText.trim());
      
      // 2. Update the state array (UI)
      const newTask: Task = { 
          id: insertId, 
          value: newTaskText.trim(), 
          is_done: false,
          created_at: new Date().toISOString() // Assuming the DB correctly set this
      };
      setTasks(prevTasks => [newTask, ...prevTasks]);
      setNewTaskText('');
    } catch (error) {
      console.error('Failed to add task:', error);
      Alert.alert('Error', 'Could not add task.');
    }
  };

  const handleDelete = async (id: number) => {
    try {
      // DELETE: Remove from DB
      await deleteTodo(id);
      
      // Update the state array (UI)
      setTasks(prevTasks => prevTasks.filter(task => task.id !== id));
    } catch (error) {
      console.error('Failed to delete task:', error);
      Alert.alert('Error', 'Could not delete task.');
    }
  };

  const handleToggleStatus = async (id: number, currentStatus: boolean) => {
    const newStatus = !currentStatus;
    try {
      // UPDATE: Change status in DB
      await toggleTodoStatus(id, newStatus);
      
      // Update the status in the state array (UI)
      setTasks(prevTasks => 
        prevTasks.map(task =>
          task.id === id ? { ...task, is_done: newStatus, completed_at: newStatus ? new Date().toISOString() : undefined } : task
        )
      );
    } catch (error) {
      console.error('Failed to toggle status:', error);
      Alert.alert('Error', 'Could not update task status.');
    }
  };

  // --- UI Component for a single ToDo Item ---
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
        <Text style={styles.header}>Loading ToDos...</Text>
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
          <Text style={styles.header}>SQLite ToDo List</Text>
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
          keyExtractor={(item) => item.id.toString()}
          renderItem={TaskItem}
          style={styles.list}
          ListEmptyComponent={<Text style={styles.emptyText}>No tasks! Add one to begin.</Text>}
        />

        <StatusBar style="auto" />
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