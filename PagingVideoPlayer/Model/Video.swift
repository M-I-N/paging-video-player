//
//  Video.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

struct Video: Equatable {
    
    let sourceURL: URL
    let thumbnailImageName: String
    
    static func allVideos() -> [Video] {
        
        let videoURLs = [ URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
                          URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"),
                          URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4") ].compactMap { $0 }
        let videoThumbnailImages = [ "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg",
                                     "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg",
                                     "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg" ]
        
        let videos = zip(videoURLs, videoThumbnailImages).map { Video(sourceURL: $0.0, thumbnailImageName: $0.1) }
        
        return videos
    }
    
}
