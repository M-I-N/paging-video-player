//
//  VideosPageViewController.swift
//  PagingVideoPlayer
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class VideosPageViewController: UIPageViewController {
    
    var videos = [Video]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let videoPlayerViewController = VideoPlayerViewController.instantiateFromStoryboard()
        videoPlayerViewController.video = videos.first
        setViewControllers([videoPlayerViewController], direction: .forward, animated: true, completion: nil)
    }
    
}

extension VideosPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentVideoPlayerViewController = viewController as? VideoPlayerViewController,
            let currentVideo = currentVideoPlayerViewController.video {
            let previousVideoPlayerViewController = VideoPlayerViewController.instantiateFromStoryboard()
            if let previousVideo = videos.item(before: currentVideo) {
                previousVideoPlayerViewController.video = previousVideo
            } else {
                previousVideoPlayerViewController.video = videos.last
            }
            return previousVideoPlayerViewController
        } else {
            return nil
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentVideoPlayerViewController = viewController as? VideoPlayerViewController,
            let currentVideo = currentVideoPlayerViewController.video {
            let nextVideoPlayerViewController = VideoPlayerViewController.instantiateFromStoryboard()
            if let nextVideo = videos.item(after: currentVideo) {
                nextVideoPlayerViewController.video = nextVideo
            } else {
                nextVideoPlayerViewController.video = videos.first
            }
            return nextVideoPlayerViewController
        } else {
            return nil
        }
        
    }
    
}
