//
//  ContentView.swift
//  PlayMIDI
//
//  Created by blue ken on 2024/07/31.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var player: Play = Play(midiFile: "audio",soundFontFile: "soundfont")
    @State private var notePlayer: MIDINotePlay = MIDINotePlay(soundFontFile: "soundfont")
    
    @State private var selectedMIDI: UInt8 = 0
    @State private var midiNoteData = MIDINoteData()
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack {
            HStack{
                Spacer(minLength: 10)
                
                VStack{
                    Text("MIDI音源の再生")
                    Image(systemName: "waveform.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .onTapGesture {
                            player.play()
                        }
                }
                Spacer(minLength: 10)
                
                VStack{
                    Text("MIDIデータを作って音を鳴らす")
                    Image(systemName: "speaker.wave.2.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .onTapGesture {
                            if(!midiNoteData.existsMidiData(number: selectedMIDI)){
                                print("キーが存在しません")
                                return
                            }
                            notePlayer.play(midinote: midiNoteData.getMidiDataFromNumber(number: selectedMIDI))
                        }
                }
                Spacer(minLength: 10)
            }
            
            Picker("鳴らすMIDIデータの選択", selection: $selectedMIDI) {
                ForEach(midiNoteData.getAllMidiNotes(), id: \.number) { note in
                    Text(note.name).tag(note.number)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                .font(.title)
                .frame(width: 360)
                .padding(24)
                .glassBackgroundEffect()
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
