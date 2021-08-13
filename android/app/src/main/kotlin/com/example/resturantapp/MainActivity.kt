package com.example.resturantapp

import android.content.Intent
import android.media.MediaPlayer
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    private val channel ="mohamedsaeed"

    @Override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine){
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).setMethodCallHandler { call, result ->
            if (call.method == "playMusic"){
                Intent(this,MyService::class.java).also {intent ->
                startService(intent)
                }

            }else{
                result.notImplemented()
            }
        }
    }


}
