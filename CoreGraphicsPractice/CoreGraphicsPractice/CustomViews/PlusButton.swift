//
//  PlusButton.swift
//  CoreGraphicsPractice
//
//  Created by Deniz Mersinlioğlu on 22.10.2019.
//  Copyright © 2019 DevelopmentHouse. All rights reserved.
//

import UIKit

@IBDesignable
class PlusButton: UIButton{
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        path.fill()
    }
}
