import AVFoundation
import AVKit
import MediaPlayer

public extension Notification.Name {
    static let playerHasStartedInitializing = Notification.Name("playerHasStartedInitializing")
    static let playerIsReadyToPlay = Notification.Name("playerIsReadyToPlay")
    
}

enum PlaybackSource {
    case local
    case remote
}

class AudioPlayer: NSObject {
    private(set) var asset: AVAsset?
    
    private(set) var playerItem: AVPlayerItem?
    
    private(set) var player: AVPlayer?
    
    private var streamURLString: String?
    
    /// Object required to store context when observing AVPlayerItem's status notifications
    fileprivate var playerItemContext = 0
    
    /// Object required to store context when observing AVPlayer's time control status and duration notifications
    fileprivate var playerContext = 1
    
    private var playbackSource: PlaybackSource = .local
    
    init(withURLString urlString: String, playbackSource: PlaybackSource) {
        super.init()
        self.playbackSource = playbackSource
        streamURLString = urlString
        configurePlayer()
    }
    
    private func configurePlayer() {
        if playbackSource == .local {
            configurePlayerWithLocalURL()
        }
        else {
            configurePlayerWithRemoteURL()
        }
    }
    
    private func configurePlayerWithLocalURL() {
        guard let streamURLString = streamURLString else {
            return
        }
        
        let streamURL = URL(filePath: streamURLString)
        asset = AVAsset(url: streamURL)
        playerItem = AVPlayerItem(asset: asset!)
        player = AVPlayer(playerItem: playerItem)
        addObservers()
        player?.play()
    }
    
    private func configurePlayerWithRemoteURL() {
        guard let streamURLString = streamURLString,
              let streamURL = URL(string: streamURLString)  else {
            return
        }
        
        asset = AVAsset(url: streamURL)
        playerItem = AVPlayerItem(asset: asset!)
        player = AVPlayer(playerItem: playerItem)
        addObservers()
        player?.play()
    }
    
    private func addObservers() {
        /// Subscribe this class as an observer of the AVPlayerItem's status property
        playerItem?.addObserver(self,
                                forKeyPath: #keyPath(AVPlayerItem.status),
                                options: [.old, .new],
                                context: &playerItemContext)
        
        /// Subscribe this class as an observer of the AVPlayer's time control state property
        player?.addObserver(self,
                            forKeyPath: #keyPath(AVPlayer.timeControlStatus),
                            options: [.old, .new],
                            context: &playerContext)
        
        /// Subscribe this class as an observer of the AVPlayerItem's duration property
        player?.addObserver(self,
                            forKeyPath: #keyPath(AVPlayerItem.duration),
                            options: [.old, .new],
                            context: &playerContext)
    }
    
    func play() {
        player?.play()
    }
}

// Player Observer
extension AudioPlayer
{
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard context == &playerItemContext || context == &playerContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            
            return
        }
        
        /// Check if the notification is related to the AVPlayerItem's status change
        if keyPath == #keyPath(AVPlayerItem.status){
            let status: AVPlayerItem.Status
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            }
            else {
                status = .unknown
            }
            
            if status == .readyToPlay {
                NotificationCenter.default.post(name: .playerIsReadyToPlay, object: nil, userInfo: nil)
            }
        }
    }
}


