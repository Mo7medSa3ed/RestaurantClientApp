package com.example.resturantapp;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import io.socket.client.Socket;
import io.socket.client.IO;

import androidx.annotation.Nullable;

import java.net.URISyntaxException;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
//     @Override
//  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//  GeneratedPluginRegistrant.registerWith(flutterEngine);
//  }  

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = new Intent(this, MyService.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent);
        } else {
            startService(intent);
        }
    }
}
