//
//  Registration  ViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/1.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate,UIViewHitTestDelegate {

    @IBOutlet weak var emailL: UITextField!
    @IBOutlet weak var pwdL: UITextField!
    @IBOutlet weak var cpwdL: UITextField!
    @IBOutlet weak var RegisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RegisterBtn.layer.cornerRadius = 10
        emailL.delegate = self
        pwdL.delegate = self
        cpwdL.delegate = self
        (self.view as! HitTestView).hitTestDelegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func RegisterClicked(_ sender: Any) {
        guard emailL.text?.isEmailFormat() == true else{
            self.alert(msg: "Please input the right Email.")
            return
        }
        
        guard (pwdL.text?.lengthOfBytes(using: .utf8))! >= 8 else {
            self.alert(msg: "password length less than 8 .")
            return
        }
        
        guard pwdL.text == cpwdL.text else {
            self.alert(msg: "confirm password don't consist.")
            return
        }
        
        iGBSProgressHUD.showWaiting(view: self.view, label: "Signing up ...")
        HttpOperation.sharedInstance.register(emailL.text!, pwd: pwdL.text!, success: {[weak self] (dic) in
            guard let sself = self else { return }
            
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
            }
            
            if let token = dic["authentication_token"] as? String{
                AppSettings.sharedInstance.deviceToken = token
            }
            
            if let mail = dic["email"] as? String{
                AppSettings.sharedInstance.userEmail = mail
            }
            
            if let ID = dic["id"] as? Int{
                AppSettings.sharedInstance.userId = ID
            }
            sself.alert(msg: "Sign up Success!")
        }){[weak self] (code, msg) in
            guard let sself = self else { return }
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
                sself.alert("Login error", msg: msg, yetTitle: "OK", handleYes: nil, noTitle: nil, handleNo: nil)
                sself.pwdL.text = ""
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailL.resignFirstResponder()
        return true
    }
    
    private func validateIP()->Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,emailRegex)
        return predicate.evaluate(with: emailL.text)
    }

    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UIViewHitTestDelegate
    func beforeHitTest( _ point:CGPoint, with event:UIEvent?)->UIView?{
        return nil
    }
    
    func afterHitTest(_ view:UIView?){
        if view == self.view{
            emailL.resignFirstResponder()
            pwdL.resignFirstResponder()
            cpwdL.resignFirstResponder()
        }
    }
}
