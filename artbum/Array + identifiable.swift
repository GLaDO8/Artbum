//
//  Array + identifiable.swift
//  artbum
//
//  Created by shreyas gupta on 10/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable{
    func indexOfFirstItemFound(of element: Element) -> Int?{
        for index in 0..<self.count{
            if self[index].id == element.id {
                return index
            }
        }
        return nil
    }
}
