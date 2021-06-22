package com.example.localnotif

import android.content.Context
import android.media.AudioManager
import android.media.SoundPool
import android.os.Build

class SoundPoolManager constructor(context: Context){
    private var playing: Boolean = false
    private var loaded: Boolean = false
    private var playingCalled: Boolean = false
    private var volume: Float
    private var soundPool: SoundPool? = null
    private var ringingSoundId: Int?
    private var ringingStreamId: Int? = null

    init {
        val audioManager: AudioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val actualVolume: Float = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC).toFloat()
        val maxVolume: Float = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC).toFloat()
        volume = actualVolume / maxVolume

        val maxStream: Int = 1
        soundPool = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            SoundPool.Builder().setMaxStreams(maxStream).build()
        } else {
            SoundPool(maxStream, AudioManager.STREAM_MUSIC, 0)
        }

        soundPool?.setOnLoadCompleteListener { soundPool, i, i2 ->
            loaded = true
            if (playingCalled) {
                playRinging()
                playingCalled = false
            }
        }

        ringingSoundId = soundPool?.load(context, R.raw.sound, 1)
    }

    fun playRinging() {
        if (loaded && !playing){
            if (ringingSoundId != null)
            ringingStreamId = soundPool?.play(ringingSoundId?: 1, volume, volume, 1, -1, 1f)
            playing = true
        } else {
            playingCalled = true
        }
    }

    fun stopRinging() {
        if (playing) {
            soundPool?.stop(ringingStreamId?:1)
            playing = false
        }
    }

    companion object {
        private var initialize: SoundPoolManager? = null
        fun getInitialize(context: Context): SoundPoolManager? {
            if (initialize == null) {
                initialize = SoundPoolManager(context)
            }
            return initialize
        }
    }
}