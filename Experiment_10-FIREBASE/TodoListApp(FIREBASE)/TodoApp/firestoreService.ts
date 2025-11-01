// firestoreService.ts

import { db } from './firebaseConfig';
import { 
  collection, 
  query, 
  orderBy, 
  onSnapshot, 
  addDoc, 
  updateDoc, 
  deleteDoc, 
  doc,
  serverTimestamp,
  where
} from 'firebase/firestore';

// --- Interface Definitions ---
export interface Task {
    id: string; // Firebase IDs are strings
    value: string;
    is_done: boolean;
    created_at?: Date; // Timestamps are often Date objects after retrieval
    completed_at?: Date;
}
// -----------------------------

const tasksCollection = collection(db, 'tasks');

/**
 * READ/LISTEN: Sets up a real-time listener for the main ToDo list.
 * This replaces getTodos().
 * @param callback - Function to update the React state with the new task list.
 */
export const subscribeToTasks = (callback: (tasks: Task[]) => void) => {
    const q = query(tasksCollection, orderBy('created_at', 'desc'));

    return onSnapshot(q, (snapshot) => {
        const tasks: Task[] = snapshot.docs.map(doc => {
            const data = doc.data();
            return {
                id: doc.id,
                value: data.value,
                is_done: data.is_done,
                created_at: data.created_at?.toDate(),
                completed_at: data.completed_at?.toDate(),
            };
        });
        callback(tasks);
    });
};

/**
 * READ (History): Sets up a real-time listener for completed tasks.
 * This replaces getHistoryTodos().
 */
export const subscribeToHistory = (callback: (tasks: Task[]) => void) => {
    const q = query(
        tasksCollection,
        where('is_done', '==', true),
        orderBy('completed_at', 'desc')
    );

    return onSnapshot(q, (snapshot) => {
        const history: Task[] = snapshot.docs.map(doc => {
            const data = doc.data();
            return {
                id: doc.id,
                value: data.value,
                is_done: true,
                completed_at: data.completed_at?.toDate(),
            };
        });
        callback(history);
    });
};

/**
 * CREATE: Adds a new task.
 */
export const addTask = (value: string) => {
    return addDoc(tasksCollection, {
        value,
        is_done: false,
        created_at: serverTimestamp(), // Firebase timestamp for creation
        completed_at: null,
    });
};

/**
 * UPDATE: Toggles the 'is_done' status and updates the completion time.
 */
export const toggleTaskStatus = (id: string, newStatus: boolean) => {
    const taskRef = doc(db, 'tasks', id);
    return updateDoc(taskRef, {
        is_done: newStatus,
        // Set completed_at based on status
        completed_at: newStatus ? serverTimestamp() : null,
    });
};

/**
 * DELETE: Deletes a task by ID.
 */
export const deleteTask = (id: string) => {
    const taskRef = doc(db, 'tasks', id);
    return deleteDoc(taskRef);
};