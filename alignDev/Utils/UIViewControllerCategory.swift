//
//  UIViewControllerCategory.swift
//  iGBSMobile
//
//  Created by Andrew.Wang on 15/6/17.
//  Copyright © 2017 IBM Corporation. All rights reserved.
//

import Foundation

extension UIViewController{
    
    func alert(_ title:String? = nil , msg:String? , yetTitle yesStr:String? = nil , handleYes yesHandler:((_ action:UIAlertAction) ->Void)? = nil , noTitle noStr:String? = nil , handleNo noHandler:((_ action:UIAlertAction) ->Void)? = nil){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        if yesStr == nil && noStr == nil {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }else{
            if let yes = yesStr {
                alert.addAction(UIAlertAction(title: yes, style: .destructive, handler: yesHandler))
            }
            if let no = noStr {
                alert.addAction(UIAlertAction(title: no, style: .cancel, handler: noHandler))
            }
        }
        
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true)
        }
        
    }
    
    
    var x:CGFloat {
        return self.view.frame.origin.x
    }
    
    var y:CGFloat {
        return self.view.frame.origin.y
    }
    
    var width:CGFloat {
        return self.view.frame.size.width
    }
    
    var height:CGFloat {
        return self.view.frame.size.height
    }
    
    var frame:CGRect {
        return self.view.frame
    }
    
    var bounds:CGRect {
        return self.view.bounds
    }
    
    func anchorPoint(_ point:CGPoint ,forView view:UIView){
        let oldOri = view.frame.origin
        view.layer.anchorPoint = point
        let newOri = view.frame.origin
        let transition = CGPoint(x: (newOri.x - oldOri.x), y: (newOri.y - oldOri.y))
        view.center = CGPoint(x: (view.center.x - transition.x), y: (view.center.y - transition.y))
    }
    
    func isPhone()->Bool{
        return (UIDevice.current.userInterfaceIdiom == .phone)
    }
    
    func isTop()->Bool{
        if let nav = self.navigationController, let topVC = nav.topViewController, topVC.isKind(of: type(of: self)) {
            return true
        }else {
            return false
        }
    }
}
