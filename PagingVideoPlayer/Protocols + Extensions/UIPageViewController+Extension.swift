//
//  UIPageViewController+Extension.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

extension UIPageViewController {
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        setViewControllers([nextViewController], direction: .forward, animated: animated) { [unowned self] (completed) in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentViewController], transitionCompleted: completed)
        }
    }
    
    func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        setViewControllers([previousViewController], direction: .reverse, animated: animated) { [unowned self] (completed) in
            self.delegate?.pageViewController?(self, didFinishAnimating: true, previousViewControllers: [currentViewController], transitionCompleted: completed)
        }
    }
    
}
