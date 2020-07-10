//
//  Array + Only.swift
//  artbum
//
//  Created by shreyas gupta on 10/07/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import Foundation

extension Array{
    var only: Element?{
        return self.count == 1 ? self.first : nil
    }
}
