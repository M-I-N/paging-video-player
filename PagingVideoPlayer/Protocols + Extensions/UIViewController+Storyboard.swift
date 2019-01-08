//
//  UIViewController+Storyboard.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable: class {
    
    /// Adds the ability for conforming class to have an associated Storyboard name.
    ///
    /**
     - SeeAlso:
     `StoryboardName` for available names.
    */
    static var storyboardName: String { get }
    
    /// Adds the ability for conforming class that can be instantiated from Storyboard given that the Storyboard ID is same as the class name.
    ///
    /// Default implementation available.
    /// - Returns: A fully initialized class from Storyboard.
    static func instantiateFromStoryboard() -> Self
}

extension StoryboardInstantiable {
    
    static func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper()
    }
    
    private static func instantiateFromStoryboardHelper<T>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
}

// MARK: -

enum StoryboardName: String {
    case main = "Main"
    //...
}
