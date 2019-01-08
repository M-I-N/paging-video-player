//
//  NibInitable.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2019 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

/// Provides everything necessary for a view to get associated UINib.
internal protocol NibInitable: class {
    
    /// UINib containing the Interface Builder representation. Default implementation available.
    static var nib: UINib? { get }
    
    
    /// Loads the associated view in the .xib file with owner set to self. Default implementation available.
    ///
    /// - Returns: The UIView that is contained in the .xib file.
    func loadViewFromNib() -> UIView?
    
}

internal extension NibInitable {
    
    /// Uses the UINib named after the object's type name.
    static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: nil) }
    
    func loadViewFromNib() -> UIView? {
        let nib = Self.nib
        return nib?.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
