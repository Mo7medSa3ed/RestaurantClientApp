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
    private String url = "https://restaurant-api-xj7i.onrender.com";
    private Socket mSocket;
    int notificationId=1; 


    {
        try {
            mSocket = IO.socket(url);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void showNotification(String title,String desc,String id,String type) {
        NotificationManager notificationManager;
        NotificationChannel notificationChannel;
        Notification.Builder builder;
        String channelId = "i.apps.notifications";
        String description = "Test notification";
        Intent notificationIntent = new Intent(this, MainActivity.class);
        notificationIntent.putExtra("id", id);
        notificationIntent.putExtra("type", type);
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
                    .setVisibility(Notification.VISIBILITY_PUBLIC)
                    .setContentText(desc)
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
                    .setContentText(desc)
                    .setContentIntent(contentIntent)
                    .setContentTitle(title);
        }
        notificationId=notificationId+1;
        notificationManager.notify(notificationId, builder.build());
    }

    @Override
    public void onCreate() {
        // startForeground();
        super.onCreate();
        if (!mSocket.connected()) {
            mSocket.connect();
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Not yet implemented");
    } // Intent intent = new Intent(this, MyService.class);
        // Intent broadcastIntent = new Intent();
        // broadcastIntent.setAction("restartservice");
        // broadcastIntent.setClass(this, Restarter.class);
        // this.sendBroadcast(broadcastIntent);

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (!mSocket.connected()) {
            mSocket.connect();
        }
        mSocket.on("newDish", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject data = new JSONObject(args[0].toString());
                    showNotification("admin add new Dish",data.getString("name"), data.getString("_id"),"dish");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

        mSocket.on("updateDish", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject data = new JSONObject(args[0].toString());
                    showNotification("admin update Dish",data.getString("name"), data.getString("_id"),"dish");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

        mSocket.on("deleteDish", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject data = new JSONObject(args[0].toString());
                    showNotification("admin delete "+data.getString("name"),"", data.getString("_id"),"delete");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });


        mSocket.on("newCategory", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject data = new JSONObject(args[0].toString());
                    showNotification("admin add new category",data.getString("name"), data.getString("_id"),"category");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
        
        mSocket.on("updateCategory", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject data = new JSONObject(args[0].toString());
                    showNotification("admin update category",data.getString("name"), data.getString("_id"),"category");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
        
        mSocket.on("deleteCategory", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject data = new JSONObject(args[0].toString());
                    showNotification("admin removed "+data.getString("name"),"", data.getString("_id"),"delete");

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

        mSocket.on("orderConfirmedByDelivery", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                try {
                    JSONObject data = new JSONObject(args[0].toString()).getJSONObject("updatedOrder");
                    if(data.getString("state").equals("confirmed")){

                    showNotification("Delivery Confirmed your Order","you can now track your order", data.getString("_id"),"orderConfirmed");
                    }else{

                    
                    showNotification("your order is canceled","", data.getString("_id"),"order");
                    }

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

    
}