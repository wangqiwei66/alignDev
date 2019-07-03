//
//  BookSeatViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/3.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit

class BookSeatViewController: UIViewController {
    
    private var desks = [DeskModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBOutlet weak var seatL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    
    @IBAction func selectClicked(_ sender: Any) {
        
        iGBSProgressHUD.showWaiting(view: self.view, label: "requesting booked seats...")
        HttpOperation.sharedInstance.getDesks(success: {[weak self] (data) in
            guard let sself = self else { return }
            
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
                if let webStr = String(data:data , encoding: .utf8){
                    let seatVC = SeatsViewController(nibName: "SeatsViewController", bundle: nil)
                    seatVC.modalPresentationStyle = .overFullScreen
                    sself.navigationController?.present(seatVC, animated: true, completion: {
                        seatVC.load(webStr)
                    })
                }else{
                    sself.alert(msg:"seats error!")
                }
            }
            
        }){[weak self] (code, msg) in
            guard let sself = self else { return }
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
                sself.alert("Login error", msg: msg, yetTitle: "OK", handleYes: nil, noTitle: nil, handleNo: nil)
            }
        }
    }

    @IBAction func DateClicked(_ sender: Any) {
    }
    
    @IBAction func BookClicked(_ sender: Any) {
    }

}
