//
//  Play.swift
//  PlayMIDI
//
//  Created by blue ken on 2024/07/31.
//

import Foundation
import AVFoundation

var musicPlayer: MusicPlayer?
var sequence: MusicSequence?


func play(file: String) {
    guard let midiFile = Bundle.main.url(forResource: file, withExtension: "mid") else {
        print("MIDI file not found")
        return
    }
    NewMusicPlayer(&musicPlayer)
    NewMusicSequence(&sequence)
    
    if let musicPlayer = musicPlayer, let sequence = sequence {
        let status = MusicSequenceFileLoad(sequence, midiFile as CFURL, .midiType, MusicSequenceLoadFlags())
        if status != noErr {
            print("Error loading MIDI file: \(status)")
            return
        }
        MusicPlayerSetSequence(musicPlayer, sequence)
        MusicPlayerStart(musicPlayer)
    }
}
