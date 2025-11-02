package com.siddhant.authapp

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth

class HomeActivity : AppCompatActivity() {

    private lateinit var auth: FirebaseAuth
    private lateinit var btnLogout: Button
    private lateinit var tvUserInfo: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)

        auth = FirebaseAuth.getInstance()
        btnLogout = findViewById(R.id.btnLogout)
        tvUserInfo = findViewById(R.id.tvUserInfo)

        // Display User Info
        val user = auth.currentUser
        if (user != null) {
            tvUserInfo.text = "Logged in as:\n${user.email ?: user.phoneNumber ?: "Unknown User"}\nUID: ${user.uid}"
        }

        // Logout Listener
        btnLogout.setOnClickListener {
            auth.signOut()
            // Navigate back to the login screen (MainActivity)
            val intent = Intent(this, MainActivity::class.java)
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            startActivity(intent)
            finish()
        }
    }

    // Check if user is logged out when HomeActivity is opened (prevents unauthorized access)
    override fun onStart() {
        super.onStart()
        if (auth.currentUser == null) {
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
            finish()
        }
    }
}