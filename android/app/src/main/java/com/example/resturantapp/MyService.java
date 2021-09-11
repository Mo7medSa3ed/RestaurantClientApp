package com.example.resturantapp;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.app.Notification;
import android.os.Build;
import android.os.IBinder;

import androidx.core.app.NotificationCompat;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Random;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class MyService extends Service {
    private String url = "https://resturant-app12.herokuapp.com";
    private Socket mSocket;


    {
        try {
            mSocket = IO.socket(url);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void showNotification(String title, String data) {
        NotificationManager notificationManager;
        NotificationChannel notificationChannel;
        Notification.Builder builder;
        String channelId = "i.apps.notifications";
        String description = "Test notification";
        Intent notificationIntent = new Intent(this, MainActivity.class);
        notificationIntent.putExtra("data", data);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PendingIntent contentIntent = PendingIntent.getActivity(this, 0, notificationIntent,
                PendingIntent.FLAG_ONE_SHOT);

        notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationChannel = new NotificationChannel(channelId, description, NotificationManager.IMPORTANCE_HIGH);
            notificationChannel.enableLights(true);
            notificationChannel.enableVibration(true);
            notificationManager.createNotificationChannel(notificationChannel);

            builder = new Notification.Builder(this, channelId)
                    .setAutoCancel(true)
                    .setTicker("mmmmmm")
                    .setVisibility(Notification.VISIBILITY_PUBLIC)
                    .setContentText("Hi mohamed Saeed")
                    .setSmallIcon(R.drawable.ic_launcher)
                    .setPriority(Notification.PRIORITY_MAX)
                    .setDefaults(NotificationCompat.DEFAULT_ALL)
                    .setContentIntent(contentIntent)
                    .setContentTitle(title);
        } else {

            builder = new Notification.Builder(this)
                    .setAutoCancel(true)
                    .setPriority(Notification.PRIORITY_MAX)
                    .setSmallIcon(R.drawable.ic_launcher)
                    .setDefaults(NotificationCompat.DEFAULT_ALL)
                    .setContentText("Hi mohamed Saeed")
                    .setTicker("mmmmmm")
                    .setContentIntent(contentIntent)
                    .setContentTitle(title);
        }
        notificationManager.notify(new Random().nextInt(), builder.build());
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (!mSocket.connected()) {
            mSocket.connect();
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (!mSocket.connected()) {
            mSocket.connect();
        }


        mSocket.on("newCategory", new Emitter.Listener() {
            @Override
            public void call(Object... args) {

                try {
                    JSONObject data = new JSONObject(args[0].toString());
                    showNotification(data.getString("name"), args[0].toString());
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });

        return START_STICKY;

    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Intent broadcastIntent = new Intent();
        broadcastIntent.setAction("restartservice");
        broadcastIntent.setClass(this, Restarter.class);
        this.sendBroadcast(broadcastIntent);

        super.onTaskRemoved(rootIntent);
    }

    @Override
    public void onDestroy() {

        super.onDestroy();
    }
}