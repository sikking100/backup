package com.example.localnotif

import android.annotation.SuppressLint
import android.content.Context
import android.content.Context.VIBRATOR_SERVICE
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator

class Vibrators constructor(context: Context) {
    private lateinit var vibrator: Vibrator
    init {
        vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
    }

    fun vibrating() {
        if (Build.VERSION.SDK_INT >= 26) {
            vibrator.vibrate(VibrationEffect.createOneShot(200, VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            vibrator.vibrate(500)
        }
    }

    fun stopVibrating() {
        vibrator.cancel();
    }

    companion object {
        private var intialize: Vibrators? = null
        fun getInitialize(context: Context): Vibrators? {
            if (intialize == null) {
                intialize = Vibrators(context)
            }
            return intialize
        }
    }
}