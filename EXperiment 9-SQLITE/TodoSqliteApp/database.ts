// database.ts

import * as SQLite from 'expo-sqlite';

// --- Interface Definitions ---
interface Task {
    id: number;
    value: string;
    is_done: boolean;
    created_at?: string;
    completed_at?: string;
}

interface TaskDB {
    id: number;
    value: string;
    is_done: 0 | 1;
    created_at: string | null;
    completed_at: string | null;
}
// -----------------------------

// FIX: Declare 'db' as a globally available variable and initialize it asynchronously
let db: SQLite.SQLiteDatabase | null = null;

/**
 * FIX: Function to asynchronously open and return the database instance.
 * All subsequent functions will call this first.
 */
export const getDB = async (): Promise<SQLite.SQLiteDatabase> => {
    if (db) return db;
    
    try {
        // Use the modern asynchronous opening method
        db = await SQLite.openDatabaseAsync('todos.db');
        return db;
    } catch (error) {
        console.error('Error opening database:', error);
        throw error;
    }
}

/**
 * FIX: Initializes the database by creating the 'todos' table.
 * Uses the modern db.execAsync() instead of transactions.
 */
export const initDatabase = async (): Promise<void> => {
    const db = await getDB();
    await db.execAsync(`
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY NOT NULL, 
        value TEXT NOT NULL, 
        is_done INTEGER NOT NULL DEFAULT 0,
        created_at TEXT, 
        completed_at TEXT
      );
    `);
    console.log('Todo table initialized successfully');
};


/**
 * FIX: Retrieves all todo items using modern db.getAllAsync().
 */
export const getTodos = async (): Promise<Task[]> => {
    const db = await getDB();

    // Use getAllAsync to fetch all rows directly
    const todoList: TaskDB[] = await db.getAllAsync<TaskDB>(
        'SELECT * FROM todos ORDER BY id DESC'
    );
    
    return todoList.map(item => ({
        id: item.id,
        value: item.value,
        is_done: item.is_done === 1,
        created_at: item.created_at || undefined,
        completed_at: item.completed_at || undefined,
    }));
};

/**
 * FIX: Retrieves only completed tasks for history view.
 */
export const getHistoryTodos = async (): Promise<Task[]> => {
    const db = await getDB();

    const historyList: TaskDB[] = await db.getAllAsync<TaskDB>(
        'SELECT * FROM todos WHERE is_done = 1 ORDER BY completed_at DESC'
    );
    
    return historyList.map(item => ({
        id: item.id,
        value: item.value,
        is_done: true,
        completed_at: item.completed_at || undefined,
    }));
};

/**
 * FIX: Adds a new todo item using modern db.runAsync().
 */
export const addTodo = async (value: string): Promise<number> => {
    const db = await getDB();
    const now = new Date().toISOString();
    
    const result = await db.runAsync(
        'INSERT INTO todos (value, created_at) values (?, ?)',
        [value, now]
    );
    
    return result.lastInsertRowId;
};

/**
 * FIX: Toggles the 'is_done' status using modern db.runAsync().
 */
export const toggleTodoStatus = async (id: number, newStatus: boolean): Promise<number> => {
    const db = await getDB();
    const status = newStatus ? 1 : 0;
    const completed_at = newStatus ? new Date().toISOString() : null;
    
    const result = await db.runAsync(
        `UPDATE todos SET is_done = ?, completed_at = ? WHERE id = ?`,
        [status, completed_at, id] as (number | string | null)[]
    );
    
    return result.changes;
};

/**
 * FIX: Deletes a todo item using modern db.runAsync().
 */
export const deleteTodo = async (id: number): Promise<number> => {
    const db = await getDB();
    
    const result = await db.runAsync(
        'DELETE FROM todos WHERE id = ?',
        [id]
    );
    
    return result.changes;
};