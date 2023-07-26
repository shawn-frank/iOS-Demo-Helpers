//
//  RRPlayerManager.swift
//  ReliableRadio
//
//  Created by Shawn Frank on 15/05/2021.
//
//  The RRPlayerManager class is a singleton which was created to coordinate between the RRPlayer
//  and all other modules that needs to react to RRPlayer's playback. This was created
//  as a singleton so that only one instance could be created and referenced all throughout the
//  application. It's main responsibilities are:
//  1. Playback in background mode
//  2. Handle external controls from CommandCenter, Lock Screen, CarPlay
//  3. Handle temporary interruptions like Siri
//  4. Retrieve RRPlayer's playback metrics

import Foundation
import AVFoundation
import MediaPlayer

class AudioPlayerManager
{
    static let shared = AudioPlayerManager()
    
    private(set) var audioPlayer: AudioPlayer?
    
    private init() {
        /// Set up the app's audio capabilities to continue even in the background
        configureForBackground()
        
        /// Start observing the controls of external displays
        manageExternalDisplayEvents()
        
        /// Subscribe to the necessary notifications
        configureNotifications()
    }
    
    private func configureNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerIsReadyToPlay(_:)),
                                               name: .playerIsReadyToPlay,
                                               object: nil)
    }
    
    /// Configure the app's audio capabilities to extend to when the app is in the background
    /// Refer to: https://stackoverflow.com/a/57195623/1619193
    private func configureForBackground()
    {
        do {
            /// Configure the audio playback mode and options
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                            mode: AVAudioSession.Mode.default,
                                                            options: [.mixWithOthers, .allowAirPlay, .defaultToSpeaker])
            
            /// Configure this app to notify other's it has deactivated so they can take over the audio if required
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch
        {
            print(error)
        }
    }
    
    // REF: https://stackoverflow.com/a/58407365/1619193
    /// Observe events from controls of external displays like Lock Screen, Command Center and CarPlay
    func manageExternalDisplayEvents()
    {
        /// Start listening to events from external displays
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        /// Play button handler
        MPRemoteCommandCenter.shared().playCommand.addTarget { event in
            /// Handle play button tap from external displays
            /// return .noActionableNowPlayingItem if needed
            
            /// Play command was managed successfully
            self.audioPlayer?.player?.play()
            return .success
        }
        
        /// Stop button handler
        MPRemoteCommandCenter.shared().stopCommand.addTarget { [weak self] event in
            self?.audioPlayer?.player?.pause()
            return .success
        }
        
        /// Pause button handler
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { [weak self] event in
            self?.audioPlayer?.player?.pause()
            return .success
        }
        
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget { [weak self] event in
            if self?.audioPlayer?.player?.timeControlStatus == .playing {
                self?.audioPlayer?.player?.pause()
            }
            else {
                // Reinit player if needed
                self?.audioPlayer?.player?.play()
            }
            
            /// Play / Pause command was managed successfully
            return .success
        }
    }
    
    func configurePlayer(withStreamURL streamURL: String, andPlaybackSource playbackSource: PlaybackSource) {
        NotificationCenter.default.post(name: .playerHasStartedInitializing, object: nil)
        audioPlayer = AudioPlayer(withURLString: streamURL, playbackSource: playbackSource)
    }
}

// MARK: RRPlayer Observers

extension AudioPlayerManager {
    /// Observer function that gets called when AVPlayer is ready to play audio
    @objc
    private func playerIsReadyToPlay(_ notification: Notification) {
        print("is ready to play")
        updateNowPlayingView()
    }
    
    func updateNowPlayingView()
    {
      let image = UIImage(named: "now_playing_image") ?? UIImage()
      
      let artwork = MPMediaItemArtwork(boundsSize: image.size) { size in
        
        /// Once MPMediaItemArtwork object has been created, return it to the original thread that invoked this closure
          return image.imageWith(newSize: size)
      }
      
      /// Configure the external displays with the song name, artist, live stream flag, artwork and current AVPlayer rate
      MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "Audio title",
                                                         MPMediaItemPropertyArtist: "Artist",
                                                         // MPNowPlayingInfoPropertyIsLiveStream: true, - only for live streams
                                                         MPMediaItemPropertyArtwork: artwork]
    }
}

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return image.withRenderingMode(self.renderingMode)
    }
}
