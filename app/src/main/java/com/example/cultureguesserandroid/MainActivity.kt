package com.yourpackage.name

import android.media.Image
import android.os.Bundle
import android.text.Layout
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.core.*
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
//import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.cultureguesserandroid.R
import java.lang.reflect.Modifier

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ContentView()
        }
    }
}

@Composable
fun ContentView() {
    val rotation = rememberInfiniteTransition().animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 5000, easing = LinearEasing)
        )
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFF4CAF50)),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Layout.Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(30.dp),
            modifier = Modifier.padding(16.dp)
        ) {
            Box {
                Image(
                    painter = painterResource(id = R.drawable.globe_01),
                    contentDescription = "Globe",
                    modifier = Modifier.size(300.dp)
                )
                Image(
                    painter = painterResource(id = R.drawable.people_01),
                    contentDescription = "People",
                    modifier = Modifier
                        .size(300.dp)
                        .rotate(rotation.value)
                )
            }

            Text(
                text = "CulturGuessr",
                fontSize = 28.sp,
                color = Color.White,
                textAlign = TextAlign.Center
            )

            Text(
                text = "Test your knowledge of cultures and landmarks around the world!",
                fontSize = 18.sp,
                color = Color.White,
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(horizontal = 40.dp)
            )

            Box(
                modifier = Modifier
                    .clickable { /* TODO: Start quiz logic here */ }
                    .background(Color.Black.copy(alpha = 0.7f), RoundedCornerShape(5.dp))
                    .padding(vertical = 15.dp, horizontal = 30.dp)
            ) {
                Text(
                    text = "Start Quiz",
                    fontSize = 20.sp,
                    color = Color.White
                )
            }
        }
    }
}
