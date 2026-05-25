package com.technosys.ambulancepassenger
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.technosys.ambulancepassenger/custom_notification"
    private val NOTIFICATION_CHANNEL_ID = "ambulancepassenger_notification_channel"
    private val NOTIFICATION_ID = 9001

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showCustomLayoutNotification") {
                val title = call.argument<String>("title") ?: "No Title"
                val body = call.argument<String>("body") ?: "No Body"
                showCustomLayoutNotification(title, body)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun showCustomLayoutNotification(title: String, body: String) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Ambulance Passenger Notifications",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }

        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Create RemoteViews with your custom layout
        val customView = RemoteViews(packageName, R.layout.custom_notification).apply {
            setTextViewText(R.id.notification_title, title)
            setTextViewText(R.id.notification_text, body)
            setImageViewResource(R.id.notification_icon, android.R.drawable.ic_dialog_info)
        }

        val builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info) // required small icon
            .setContent(customView) // set custom view
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

        notificationManager.notify(NOTIFICATION_ID, builder.build())
    }
}
