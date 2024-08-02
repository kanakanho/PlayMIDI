//
//  Play.swift
//  PlayMIDI
//
//  Created by blue ken on 2024/07/31.
//

import AVFoundation

class Play {
    private let midiFile: String
    private let soundFontFile: String
    private var midiPlayer: AVMIDIPlayer?
    
    init(midiFile: String,soundFontFile: String) {
        self.midiFile = midiFile
        self.soundFontFile = soundFontFile
        
        // Ensure MIDI file URL is valid
        guard let midiFileURL = Bundle.main.url(forResource: midiFile, withExtension: "mid") else {
            print("MIDIファイルが見つかりません")
            fatalError("MIDIファイルが見つかりません")
        }
        
        // Ensure SoundFont file URL is valid
        guard let soundFontFileURL = Bundle.main.url(forResource: soundFontFile, withExtension: "sf2") else {
            print("SoundFontファイルが見つかりません")
            fatalError("SoundFontファイルが見つかりません")
        }
        
        do {
            midiPlayer = try AVMIDIPlayer(contentsOf: midiFileURL, soundBankURL: soundFontFileURL)
        } catch {
            print("AVMIDIPlayerの初期化エラー: \(error.localizedDescription)")
            return
        }
    }
    
    func play() {
        midiPlayer?.prepareToPlay()
        
        if let midiPlayer = midiPlayer, !midiPlayer.isPlaying {
            midiPlayer.play()
        }
    }
}
