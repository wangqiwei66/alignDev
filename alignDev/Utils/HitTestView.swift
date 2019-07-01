//
//  HitTestView.swift
//  SGMobile
//
//  Created by Nick Yu on 2017/8/23.
//  Copyright © 2017 IBM Corporation. All rights reserved.
//

import UIKit



protocol UIViewHitTestDelegate {
    func beforeHitTest( _ point:CGPoint, with event:UIEvent?)->UIView?;
    func afterHitTest(_ view:UIView?);
}


class HitTestView : UIView{
    
    var hitTestDelegate : UIViewHitTestDelegate?
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?{
        if let view =  self.hitTestDelegate?.beforeHitTest(point, with: event){
            return view
        }
        
        let view =  super.hitTest(point, with:event)
        self.hitTestDelegate?.afterHitTest(view)
        
        return view
    }
}

