//
//  Registration  ViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/1.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var emailL: UITextField!
    @IBOutlet weak var pwdL: UITextField!
    @IBOutlet weak var cpwdL: UITextField!
    @IBOutlet weak var RegisterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RegisterBtn.layer.cornerRadius = 10

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func RegisterClicked(_ sender: Any) {
        if false == validateIP(){
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
}
