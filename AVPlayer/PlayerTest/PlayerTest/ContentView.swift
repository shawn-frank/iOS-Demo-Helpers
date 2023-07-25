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
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            if let soundURLString = Bundle.main.path(forResource: "sample",
                                                     ofType: "mp3") {
                AudioPlayerManager.shared.configurePlayer(withStreamURL: soundURLString, andPlaybackSource: .local)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
