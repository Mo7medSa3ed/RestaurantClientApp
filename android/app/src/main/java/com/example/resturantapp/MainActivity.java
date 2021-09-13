package com.example.resturantapp;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.socket.client.Socket;
import io.socket.client.IO;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.net.URISyntaxException;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "notification").setMethodCallHandler(
                ((call, result) -> {
                    String data = null;
                    if (call.method.equals("getNotification")) {
                        if (getIntent().getExtras().getString("data") != null) {
                            data = getIntent().getExtras().getString("id");
                            type = getIntent().getExtras().getString("type");
                        }
                    }
                    result.success(type+'/'+data);
                })
        );
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        getIntent().getExtras().getString("data")!=null


        // Intent intent = new Intent(this, MyService.class);
        // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        //     startForegroundService(intent);
        // } else {
        //     startService(intent);
        // }
    }

    @Override
    protected void onDestroy() {
        Intent broadcastIntent = new Intent();
        broadcastIntent.setAction("restartservice");
        broadcastIntent.setClass(this, Restarter.class);
        this.sendBroadcast(broadcastIntent);
        super.onDestroy();
    }
}
