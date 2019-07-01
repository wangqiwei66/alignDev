//
//  UILabelExtensions.swift
//  Telematics
//
//  Created by 汪奇伟 on 2019/4/18.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit

extension UILabel{
    func blickText(_ toString:String){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { (finished) in
            self.text = toString
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            })
        }
    }
}
