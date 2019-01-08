//
//  ViewController.swift
//  PagingVideoPlayer
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let videos = Video.allVideos()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imagesPVC = segue.destination as? VideosPageViewController {
            imagesPVC.videos = videos
        }
    }
    
    @objc private func viewDidRotate() {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @available(iOS 11.0, *)
    override var prefersHomeIndicatorAutoHidden: Bool {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            return true
        } else {
            return super.prefersHomeIndicatorAutoHidden
        }
    }

}

