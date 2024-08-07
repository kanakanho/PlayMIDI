//
//  NotePlay.swift
//  PlayMIDI
//
//  Created by blue ken on 2024/08/06.
//

import AVFoundation

class MIDINotePlay{
    // ライブラリの初期化
    private let audioEngine = AVAudioEngine()
    private let unitSampler = AVAudioUnitSampler()
    
    // ピアノ音源の適応
    private let soundFontFile: String
    
    // 再生する音の設定
    private final var midiNoteData = MIDINoteData()

    init(soundFontFile: String) {
        self.soundFontFile = soundFontFile
        audioEngine.attach(unitSampler)
        audioEngine.connect(unitSampler, to: audioEngine.mainMixerNode, format: nil)
        try? audioEngine.start()
        loadSoundFont()
    }
    
    func loadSoundFont() {
        guard let url = Bundle.main.url(forResource: soundFontFile, withExtension: "sf2") else { return }
        try? unitSampler.loadSoundBankInstrument(
            at: url, program: 0,
            bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
            bankLSB: UInt8(kAUSampler_DefaultBankLSB)
        )
    }
    
    deinit {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.disconnectNodeOutput(unitSampler)
            audioEngine.detach(unitSampler)
        }
    }
    
    func play(midinote: MIDINote) {
        // 一つ目の引数はMIDIのNote番号
        // withVelocityは音量に関係する値 0 ~ 127
        // onChannelはチャンネルを構成しないなら基本0
        dump(midinote)
        unitSampler.startNote(midinote.number, withVelocity: 80, onChannel: 0)
    }
    
    func stop(midinote: MIDINote) {
        unitSampler.stopNote(midinote.number, onChannel: 0)
    }
    
    func allPlay() {
        // 音を鳴らす時間（秒）
        let noteDuration: TimeInterval = 0.5
        
        let midiNotes = midiNoteData.getAllMidiNotes()
        
        for (index, midinote) in midiNotes.enumerated() {
            let delay = Double(index) * noteDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.play(midinote: midinote)
                
                // 音を鳴らしてから音が消えるまで待つ
                DispatchQueue.main.asyncAfter(deadline: .now() + noteDuration) {
                    self.stop(midinote: midinote)
                }
            }
        }
    }
}
