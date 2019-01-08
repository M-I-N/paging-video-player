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
    
    private let videoPlayer = VideoPlayer()
    @objc private let avPlayer = AVPlayer()
    private var playbackModeObservationToken: NSKeyValueObservation?
    private var playerItemStatusObservationToken: NSKeyValueObservation?
    
    var allowAutoPlay: Bool = false
    
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
        videoPlayer.player = avPlayer
        
        // add AVPlayer observer
        playbackModeObservationToken = avPlayer.observe(\.timeControlStatus) { [unowned self] (player, _) in
            switch player.timeControlStatus {
            case .paused:
                self.playPauseButton.isSelected = false
                self.thumbnailImageView.isHidden = false
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
    }
    
}

// MARK: - Protocol Conformances
extension VideoPlayerView: NibInitable { }


// MARK: - AVPlayer Specifics
extension VideoPlayerView {
    @objc private func playerItemDidPlayToEndTime() {
        avPlayer.seek(to: .zero)
    }
}


// MARK: - Button Actions
extension VideoPlayerView {
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

// MARK: - Internal Class
private class VideoPlayer: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private var playerLayer: AVPlayerLayer {
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
