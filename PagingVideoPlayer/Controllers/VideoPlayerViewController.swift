//
//  VideoPlayerViewController.swift
//  PagingVideoPlayer
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class VideoPlayerViewController: UIViewController {
    
    var video: Video?

    @IBOutlet private weak var videoPlayerView: VideoPlayerView!
    
    @IBOutlet private var videoPlayerViewNormalSizedConstraints: [NSLayoutConstraint]!
    @IBOutlet private var videoPlayerViewStretchedSizedConstraints: [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayerView.allowAutoPlay = true
        videoPlayerView.needsStretchingBlock = { [unowned self] shouldStretch in
            if shouldStretch {
                self.videoPlayerViewStretchedSizedConstraints.forEach { $0.priority = .defaultHigh }
                self.videoPlayerViewNormalSizedConstraints.forEach { $0.priority = .defaultLow }
            } else {
                self.videoPlayerViewStretchedSizedConstraints.forEach { $0.priority = .defaultLow }
                self.videoPlayerViewNormalSizedConstraints.forEach { $0.priority = .defaultHigh }
            }
            // as the constraints update doesn't really need to be animated, layoutIfNeeded() doesn't need to be called at all
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let video = video {
            videoPlayerView.video = video
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        videoPlayerView.video = nil
    }
    
}

extension VideoPlayerViewController: StoryboardInstantiable {
    
    static var storyboardName: String {
        return StoryboardName.main.rawValue
    }
    
}
