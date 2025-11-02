package com.siddhant.authapp // ⬅️ IMPORTANT: Ensure this is your actual package name

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import com.siddhant.authapp.PhoneAuthActivity // This assumes PhoneAuthActivity is in the same package
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.ApiException
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider
import com.google.android.gms.tasks.Task // Added for explicit task type
import com.google.android.gms.auth.api.signin.GoogleSignInClient

class MainActivity : AppCompatActivity() {

    // 1. Core Variables for Email/Password Auth
    private lateinit var etEmail: EditText
    private lateinit var etPassword: EditText
    private lateinit var btnLogin: Button
    private lateinit var btnSignUp: Button
    private lateinit var btnPhoneAuth: Button // For Phone Auth navigation

    // 2. Firebase and Google Auth Variables
    private lateinit var auth: FirebaseAuth // Essential Firebase Auth Instance
    private lateinit var btnGoogleSignIn: com.google.android.gms.common.SignInButton
    private lateinit var googleSignInClient: GoogleSignInClient

    // (RC_SIGN_IN is not needed with ActivityResultContracts, so we remove it)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // 🌟 1. INITIALIZE FIREBASE 🌟
        auth = FirebaseAuth.getInstance()

        // 🌟 2. INITIALIZE UI ELEMENTS (Connecting XML IDs to Kotlin Variables) 🌟
        etEmail = findViewById(R.id.etEmail)
        etPassword = findViewById(R.id.etPassword)
        btnLogin = findViewById(R.id.btnLogin)
        btnSignUp = findViewById(R.id.btnSignUp)
        btnPhoneAuth = findViewById(R.id.btnPhoneAuth)
        btnGoogleSignIn = findViewById(R.id.btnGoogleSignIn)

        // 🌟 3. CONFIGURE GOOGLE SIGN-IN 🌟
        val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken(getString(R.string.default_web_client_id))
            .requestEmail()
            .build()
        googleSignInClient = GoogleSignIn.getClient(this, gso)

        // ----------------------------------------------------
        // 4. SET UP BUTTON LISTENERS
        // ----------------------------------------------------

        // 4.1 LOG IN (Email/Password)
        btnLogin.setOnClickListener {
            val email = etEmail.text.toString().trim()
            val password = etPassword.text.toString().trim()

            if (email.isEmpty() || password.isEmpty()) {
                Toast.makeText(this, "Please enter both email and password.", Toast.LENGTH_SHORT).show()
            } else {
                auth.signInWithEmailAndPassword(email, password)
                    .addOnCompleteListener(this) { task: Task<AuthResult> -> // Type specified!
                        if (task.isSuccessful) {
                            // 🌟 FIX: CALL THE NAVIGATION HELPER FUNCTION HERE 🌟
                            navigateToHome()

                        } else {
                            Toast.makeText(this, "Authentication Failed: ${task.exception?.message}",
                                Toast.LENGTH_LONG).show()
                        }
                    }
            }
        }

        // 4.2 SIGN UP (Email/Password)
        // In MainActivity.kt, replace the old btnSignUp block with this:
        btnSignUp.setOnClickListener {
            val intent = Intent(this, RegisterActivity::class.java)
            startActivity(intent)
        }
        // 4.3 PHONE AUTH NAVIGATION
        btnPhoneAuth.setOnClickListener {
            val intent = Intent(this, PhoneAuthActivity::class.java)
            startActivity(intent)
        }

        // 4.4 GOOGLE SIGN IN
        btnGoogleSignIn.setOnClickListener {
            signInGoogle()
        }
    } // End of onCreate

    // ----------------------------------------------------
    // GOOGLE SIGN IN FUNCTIONS
    // ----------------------------------------------------
// Add this function anywhere outside the onCreate method in MainActivity.kt
    fun navigateToHome() {
        val intent = Intent(this, HomeActivity::class.java)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        startActivity(intent)
        finish()
    }
    private fun signInGoogle() {
        val signInIntent = googleSignInClient.signInIntent
        googleSignInLauncher.launch(signInIntent)
    }

    private val googleSignInLauncher = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == RESULT_OK) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(result.data)
            try {
                val account = task.getResult(ApiException::class.java)!!
                firebaseAuthWithGoogle(account.idToken!!)
            } catch (e: ApiException) {
                Toast.makeText(this, "Google Sign In failed: ${e.statusCode}", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun firebaseAuthWithGoogle(idToken: String) {
        val credential = GoogleAuthProvider.getCredential(idToken, null)
        auth.signInWithCredential(credential)
            .addOnCompleteListener(this) { task: Task<AuthResult> -> // Type specified!
                if (task.isSuccessful) {
                    // 🌟 FIX: REPLACE Toast with Navigation 🌟
                    navigateToHome()

                } else {
                    Toast.makeText(this, "Firebase Auth failed: ${task.exception?.message}", Toast.LENGTH_LONG).show()
                }
            }
    }
}