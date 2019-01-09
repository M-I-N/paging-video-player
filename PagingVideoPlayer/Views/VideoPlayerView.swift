//
//  VideoPlayerView.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var safePinchRecognizerView: UIView!
    
    private let videoPlayer = VideoPlayer()
    @objc private let avPlayer = AVPlayer()
    private var playbackModeObservationToken: NSKeyValueObservation?
    private var playerItemStatusObservationToken: NSKeyValueObservation?
    
    var allowAutoPlay: Bool = false
    
    // MARK: - Properties: User initiated player view zooming
    var needsStretchingBlock: ((Bool) -> Void)?
    private var viewingMode = ViewingMode.original {
        didSet {
            switch viewingMode {
            case .original:
                videoPlayer.playerLayer.videoGravity = .resizeAspect
            case .zoomedToFill:
                videoPlayer.playerLayer.videoGravity = .resizeAspectFill
            }
        }
    }
    private var landscapeViewingModePreference = ViewingMode.original
    // MARK: -
    
    var video: Video? {
        didSet {
            if let video = video {
                let asset = AVURLAsset(url: video.sourceURL)
                let item = AVPlayerItem(asset: asset)
                
                // add AVPlayerItem observer
                playerItemStatusObservationToken = item.observe(\.status) { [weak self] (playerItem, _) in
                    if let self = self {
                        switch playerItem.status {
                        case .unknown:
                            break
                        case .readyToPlay:
                            if self.allowAutoPlay {
                                self.avPlayer.play()
                            }
                            break
                        case .failed:
                            break
                        }
                    }
                }
                
                avPlayer.replaceCurrentItem(with: item)
                thumbnailImageView.downloaded(from: video.thumbnailImageName, contentMode: .scaleAspectFill)
            } else {
                avPlayer.replaceCurrentItem(with: nil)
            }
        }
    }
    
    
    /// Can resume playback, this function should be removed altogether
    private func resumePlay() {
        if allowAutoPlay {
            if avPlayer.currentItem?.status == .readyToPlay {
                avPlayer.play()
            }
        }
    }
    
    /// Can pause playback, this function should be removed altogether
    private func pause() {
        avPlayer.pause()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let nibView = loadViewFromNib() else { return }
        
        nibView.frame = bounds
        addSubview(nibView)
        
        // add pinch gesture recognizer to the safe pinch recognizer view of the nib view
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchOnsafePinchRecognizerView(sender:)))
        safePinchRecognizerView.addGestureRecognizer(pinchGestureRecognizer)
        
        videoPlayer.player = avPlayer
        
        // add AVPlayer observer
        playbackModeObservationToken = avPlayer.observe(\.timeControlStatus) { [unowned self] (player, _) in
            switch player.timeControlStatus {
            case .paused:
                self.playPauseButton.isSelected = false
                // self.thumbnailImageView.isHidden = false  // doesn't work well with pinch in to zoom player feature
                // loading end
                self.activityIndicator.stopAnimating()
            case .playing:
                self.playPauseButton.isSelected = true
                self.thumbnailImageView.isHidden = true
                // loading end
                self.activityIndicator.stopAnimating()
            case .waitingToPlayAtSpecifiedRate:
                self.playPauseButton.isSelected = true
                self.thumbnailImageView.isHidden = true
                // loading start
                self.activityIndicator.startAnimating()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayer.frame = bounds
        videoPlayer.backgroundColor = .black
        addSubview(videoPlayer)
        sendSubviewToBack(videoPlayer)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func didRotate() {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            viewingMode = .original
        } else {
            viewingMode = landscapeViewingModePreference
        }
    }
    
}

// MARK: - Protocol Conformances
extension VideoPlayerView: NibInitable { }


// MARK: - AVPlayer Specifics
private extension VideoPlayerView {
    @objc private func playerItemDidPlayToEndTime() {
        avPlayer.seek(to: .zero)
    }
}


// MARK: - Button Actions
private extension VideoPlayerView {
    @IBAction private func playPauseButtonDidTap(_ sender: UIButton) {
        switch sender.isSelected {
        case true:
            // playing state, need to pause
            avPlayer.pause()
        case false:
            // paused state, need to play again
            avPlayer.play()
        }
    }
}

// MARK: - Player View Zooming Behavior implementation
private extension VideoPlayerView {
    @objc private func handlePinchOnsafePinchRecognizerView(sender: UIPinchGestureRecognizer) {
        /*
         *
        If consumer (the one which added VideoPlayerView as it's subview) actually passed the needsStretchingBlock (meaning, the consumer is capable of providing stretchable area for the VideoPlayerView) only then update the viewing mode. Otherwise don't, because it would make user experience bad.
        */
        if let needsStretchingBlock = needsStretchingBlock {
            if UIApplication.shared.statusBarOrientation.isLandscape {
                let isZoomInTried = sender.scale > 1
                needsStretchingBlock(isZoomInTried)
                if isZoomInTried {
                    viewingMode = .zoomedToFill
                } else {
                    viewingMode = .original
                }
                landscapeViewingModePreference = viewingMode
            }
        }
    }
    
    private enum ViewingMode {
        case original
        case zoomedToFill
    }
}

// MARK: - Internal Class
private class VideoPlayer: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer! {
        set {
            playerLayer.player = newValue
        }
        get {
            return playerLayer.player
        }
    }
    
}
