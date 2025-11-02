package com.siddhant.authapp // ⬅️ IMPORTANT: Match your package name

import android.content.Intent // For navigation (when we do Step 7)
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.FirebaseException
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.PhoneAuthCredential
import com.google.firebase.auth.PhoneAuthOptions
import com.google.firebase.auth.PhoneAuthProvider
import java.util.concurrent.TimeUnit

class PhoneAuthActivity : AppCompatActivity() {

    // UI Elements
    private lateinit var etPhoneNumber: EditText
    private lateinit var etVerificationCode: EditText
    private lateinit var btnSendCode: Button
    private lateinit var btnVerifyCode: Button

    // Firebase Auth Variables
    private lateinit var auth: FirebaseAuth
    private lateinit var callbacks: PhoneAuthProvider.OnVerificationStateChangedCallbacks
    private var verificationId: String? = null
    private var resendToken: PhoneAuthProvider.ForceResendingToken? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_phone_auth)

        // Initialize UI elements
        etPhoneNumber = findViewById(R.id.etPhoneNumber)
        etVerificationCode = findViewById(R.id.etVerificationCode)
        btnSendCode = findViewById(R.id.btnSendCode)
        btnVerifyCode = findViewById(R.id.btnVerifyCode)

        // Initialize Firebase Auth
        auth = FirebaseAuth.getInstance()

        // Setup the callback functions for the phone verification process
        setupCallbacks()

        // Set Listeners
        btnSendCode.setOnClickListener {
            startPhoneNumberVerification()
        }

        btnVerifyCode.setOnClickListener {
            verifyPhoneNumberWithCode()
        }
    }

    private fun setupCallbacks() {
        callbacks = object : PhoneAuthProvider.OnVerificationStateChangedCallbacks() {

            override fun onVerificationCompleted(credential: PhoneAuthCredential) {
                // Auto verification success
                Log.d("PhoneAuth", "onVerificationCompleted: $credential")
                signInWithPhoneAuthCredential(credential)
            }

            override fun onVerificationFailed(e: FirebaseException) {
                // Verification failed
                Log.w("PhoneAuth", "onVerificationFailed", e)
                Toast.makeText(this@PhoneAuthActivity, "Verification Failed: ${e.message}", Toast.LENGTH_LONG).show()
            }

            override fun onCodeSent(
                verificationId: String,
                token: PhoneAuthProvider.ForceResendingToken
            ) {
                // Code sent successfully.
                Log.d("PhoneAuth", "onCodeSent: $verificationId")
                this@PhoneAuthActivity.verificationId = verificationId
                resendToken = token

                Toast.makeText(this@PhoneAuthActivity, "Verification code sent!", Toast.LENGTH_SHORT).show()

                // Show the code input fields
                etVerificationCode.visibility = View.VISIBLE
                btnVerifyCode.visibility = View.VISIBLE
                btnSendCode.text = "RESEND CODE"
            }
        }
    }

    private fun startPhoneNumberVerification() {
        val phoneNumber = etPhoneNumber.text.toString().trim()

        if (phoneNumber.isEmpty() || !phoneNumber.startsWith("+")) {
            Toast.makeText(this, "Enter a valid phone number, including country code (e.g., +1 555-123-4567).", Toast.LENGTH_LONG).show()
            return
        }

        // Start the verification process
        val options = PhoneAuthOptions.newBuilder(auth)
            .setPhoneNumber(phoneNumber)
            .setTimeout(60L, TimeUnit.SECONDS)
            .setActivity(this)
            .setCallbacks(callbacks)
            .build()

        PhoneAuthProvider.verifyPhoneNumber(options)
    }

    private fun verifyPhoneNumberWithCode() {
        val code = etVerificationCode.text.toString().trim()

        if (code.isEmpty() || verificationId == null) {
            Toast.makeText(this, "Please enter the 6-digit code.", Toast.LENGTH_SHORT).show()
            return
        }

        val credential = PhoneAuthProvider.getCredential(verificationId!!, code)
        signInWithPhoneAuthCredential(credential)
    }

    private fun signInWithPhoneAuthCredential(credential: PhoneAuthCredential) {
        auth.signInWithCredential(credential)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    Toast.makeText(this, "Phone Login Successful!", Toast.LENGTH_LONG).show()

                    // 🌟 ADD THE NAVIGATION CODE HERE 🌟
                    val intent = Intent(this, HomeActivity::class.java)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                    startActivity(intent)
                    finish() // Closes the PhoneAuthActivity

                } else {
                    // ... failure logic
                }
            }
    }
}