//
//  MIDINoteNumber.swift
//  PlayMIDI
//
//  Created by blue ken on 2024/08/06.
//

struct MIDINote {
    var number: UInt8
    var name: String
}

class MIDINoteData{
    private final let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    
    private var midiNotes: [MIDINote]
    
    init() {
        var notes = [MIDINote]()
        
        for i in 0...127 {
            let octave = (i / 12) - 1
            let name = noteNames[i % 12]
            let noteName = "\(name)\(octave)"
            notes.append(MIDINote(number: UInt8(i), name: noteName))
        }
        
        self.midiNotes = notes
    }
    
    func existsMidiData(number: UInt8) -> Bool {
        return midiNotes.contains { $0.number == number }
    }
    
    func getMidiDataFromNumber(number: UInt8) -> MIDINote {
        if let note = midiNotes.first(where: { $0.number == number }) {
            return note
        }
        return midiNotes[0]
    }

    func getAllMidiNotes() -> [MIDINote] {
        return midiNotes
    }
}
