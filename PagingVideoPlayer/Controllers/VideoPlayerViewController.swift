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
    
    // TODO:- Declare a Bool that will track if view disappeared or not, actually
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayerView.allowAutoPlay = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO:- If view disappeared actually then again provide the video
        if let video = video {
            videoPlayerView.video = video
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // TODO:- Track if view disappeared or not, actually
        videoPlayerView.video = nil
    }
    
}

extension VideoPlayerViewController: StoryboardInstantiable {
    
    static var storyboardName: String {
        return StoryboardName.main.rawValue
    }
    
}
