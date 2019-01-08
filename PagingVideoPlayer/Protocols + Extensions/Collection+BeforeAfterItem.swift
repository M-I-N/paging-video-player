//
//  Collection+BeforeAfterItem.swift
//  SwipeablePlayerView
//
//  Created by Nayem on 1/8/19.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element
    
    func safeIndex(after index: Index) -> Index? {
        let nextIndex = self.index(after: index)
        return (nextIndex < self.endIndex) ? nextIndex : nil
    }
    
    func index(afterWithWrapAround index: Index) -> Index {
        return self.safeIndex(after: index) ?? self.startIndex
    }
    
    func item(after item: Element) -> Element? {
        return self.index(of: item)
            .flatMap(self.safeIndex(after:))
            .map{ self[$0] }
    }
    
    func item(afterWithWrapAround item: Element) -> Element? {
        return self.index(of: item)
            .map(self.index(afterWithWrapAround:))
            .map{ self[$0] }
    }
}

extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element
    
    func safeIndex(before index: Index) -> Index? {
        let previousIndex = self.index(before: index)
        return (self.startIndex <= previousIndex) ? previousIndex : nil
    }
    
    func index(beforeWithWrapAround index: Index) -> Index {
        return self.safeIndex(before: index) ?? self.index(before: self.endIndex)
    }
    
    func item(before item: Element) -> Element? {
        return self.index(of: item)
            .flatMap(self.safeIndex(before:))
            .map{ self[$0] }
    }
    
    func item(beforeWithWrapAround item: Element) -> Element? {
        return self.index(of: item)
            .map(self.index(beforeWithWrapAround:))
            .map{ self[$0] }
    }
}
