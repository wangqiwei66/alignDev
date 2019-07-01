//
//  iGBSProgressHUD.swift
//  iGBSMobile
//
//  Created by Andrew.Wang on 13/6/17.
//  Copyright © 2017 IBM Corporation. All rights reserved.
//

import UIKit
import Foundation

class iGBSProgressHUD: NSObject {
    static var progressHUD:MBProgressHUD?
    static var cancelBlock: (()->Void)?
    
    class func show(msg:String , on view:UIView ,delay :TimeInterval = 3.0){
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = .text
            hud.label.text = msg
            hud.offset = CGPoint(x: 0, y: MBProgressMaxOffset)
            hud.hide(animated: true, afterDelay: delay)
        }
    }
    
    class func showWaiting(view:UIView? , label:String? = nil ,cancel: (()->Void)? = nil){
        guard (view != nil) else {
            return
        }
        
        stopWaiting()
        
        DispatchQueue.main.async {
            progressHUD = MBProgressHUD.showAdded(to: view!, animated: true)
//            progressHUD?.backgroundView.isHidden = true
//            progressHUD?.backgroundView.backgroundColor = UIColor.black
//            progressHUD?.backgroundView.alpha = 0.3
            if label != nil {
                progressHUD?.label.text = label
            }
            if cancel != nil{
                self.cancelBlock = cancel
                progressHUD?.button.setTitle("Cancel", for: .normal)
                progressHUD?.button.addTarget(self, action: #selector(cancelCLicked), for: .touchUpInside)
            }
        }
    }
    
    @objc class func cancelCLicked(){
        debugPrint("cancel block")
        cancelBlock?()
    }
    
    class func stopWaiting(){
        
        guard (progressHUD != nil) else {
            return
        }
        
        DispatchQueue.main.async {
            progressHUD?.hide(animated: true)
            progressHUD = nil
        }
        
    }
}
