//
//  PlayMIDIApp.swift
//  PlayMIDI
//
//  Created by blue ken on 2024/07/31.
//

import SwiftUI

@main
struct PlayMIDIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
