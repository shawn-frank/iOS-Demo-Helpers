//
//  ContentView.swift
//  PlayerTest
//
//  Created by Shawn Frank on 26/7/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Play local") {
                if let soundURLString = Bundle.main.path(forResource: "sample",
                                                         ofType: "mp3") {
                    AudioPlayerManager.shared.configurePlayer(withStreamURL: soundURLString, andPlaybackSource: .local)
                }
            }
            .padding()
            
            Button("Play remote") {
                if let remoteURL = URL(string: "https://ice1.somafm.com/groovesalad-128-mp3") {
                    AudioPlayerManager.shared.configurePlayer(withStreamURL: remoteURL.absoluteString, andPlaybackSource: .remote)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
