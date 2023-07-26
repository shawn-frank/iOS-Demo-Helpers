//
//  ContentView.swift
//  SimpleWidget
//
//  Created by Shawn Frank on 24/7/2023.
//

import SwiftUI

struct ContentView: View {
    @State var imageURL: URL?
    
    var body: some View {
        VStack {
            AsyncImage(url: imageURL) { phase in
                if case .success(let image) = phase {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
        .onOpenURL(perform: { url in
            print(url.absoluteString)
        })
        .onAppear {
            
            if let remoteURL = URL(string: "https://ice1.somafm.com/groovesalad-128-mp3") {
                print(remoteURL)
                AudioPlayerManager.shared.configurePlayer(withStreamURL: remoteURL.absoluteString, andPlaybackSource: .remote)
            }
            
            Task {
                let url = URL(string: "https://api.jsonbin.io/v3/b/64be53208e4aa6225ec29c5a")!
                
                do {
                    let record: Record = try await WidgetService().fetchData(url: url)
                    DispatchQueue.main.async {
                        imageURL = URL(string: record.image)
                    }
                }
                catch {
                    print("error")
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
