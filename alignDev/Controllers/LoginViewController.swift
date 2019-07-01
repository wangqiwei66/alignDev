//
//  Registration  ViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/1.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,UIViewHitTestDelegate {
    
    @IBOutlet weak var emailL: UITextField!
    @IBOutlet weak var pwdL: UITextField!
    @IBOutlet weak var LoginBgtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginBgtn.layer.cornerRadius = 10
        emailL.delegate = self
        pwdL.delegate = self
        (self.view as! HitTestView).hitTestDelegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        let regVC = RegistrationViewController(nibName:"RegistrationViewController", bundle:nil)
        navigationController?.pushViewController(regVC, animated: true)
        
    }
    
    @IBAction func LoginClicked(_ sender: Any) {
        guard emailL.text?.isEmailFormat() == true else{
            self.alert(msg: "Please input the right Email.")
            return
        }
        
        guard (pwdL.text?.lengthOfBytes(using: .utf8))! > 8 else {
            self.alert(msg: "password length less than 8 .")
            return
        }
        iGBSProgressHUD.showWaiting(view: self.view, label: "Loging in...")
        HttpOperation.sharedInstance.postLogin(emailL.text!, pwd: pwdL.text!, success: {[weak self] (dic) in
            guard let sself = self else { return }
            
            DispatchQueue.main.async(){
                
                iGBSProgressHUD.stopWaiting()
            }
            
        }){[weak self] (code, msg) in
            guard let sself = self else { return }
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
                sself.alert("Login error", msg: msg, yetTitle: "OK", handleYes: nil, noTitle: nil, handleNo: nil)
                sself.pwdL.text = ""
            }
        }
//        HttpOperation.sharedInstance.login(emailL.text!, pwd: pwdL.text!, success: {[weak self] (dic) in
//            guard let sself = self else { return }
//
//            DispatchQueue.main.async(){
//
//                iGBSProgressHUD.stopWaiting()
//            }
//
//        }) {[weak self] (code, msg) in
//            guard let sself = self else { return }
//            DispatchQueue.main.async(){
//                iGBSProgressHUD.stopWaiting()
//                sself.alert(msg: "Login error, \(msg)")
//                sself.pwdL.text = ""
//            }
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailL.resignFirstResponder()
        pwdL.resignFirstResponder()
        return true
    }

    //MARK:- UIViewHitTestDelegate
    func beforeHitTest( _ point:CGPoint, with event:UIEvent?)->UIView?{
        return nil
    }
    
    func afterHitTest(_ view:UIView?){
        if view == self.view{
            emailL.resignFirstResponder()
            pwdL.resignFirstResponder()
        }
    }
}
