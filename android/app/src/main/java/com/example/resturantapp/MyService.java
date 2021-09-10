package com.example.resturantapp;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.widget.Toast;

import org.json.JSONObject;

import io.socket.client.IO;
import io.socket.client.Socket;
import io.socket.emitter.Emitter;

public class MyService extends Service {
    private String url = "https://resturant-app12.herokuapp.com";
    private java.net.Socket mSocket;

    {
        try {
            mSocket = IO.socket(url);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (!mSocket.connected()){
            mSocket.connect();
        }
    }

    @Override
    public IBinder onBind(Intent intent) {

        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (!mSocket.isConnected()){
            mSocket.connect();
        
        }
        System.out.println( "==================>" +mSocket.isConnected());
        



        mSocket.on("newDish", new Emitter.Listener() {
            @Override
            public void call(Object... args) {
                JSONObject data = (JSONObject) args[0];
                System.out.println(data);
            }
        });



        return START_STICKY;

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (!mSocket.isConnected()){
            mSocket.connect();
        
        }
    }
}