//
//  BookSeatViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/3.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit

class BookSeatViewController: UIViewController,UIActionSheetDelegate {
    
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var pickerYCons: NSLayoutConstraint!
    @IBOutlet weak var deskL: UILabel!
    @IBOutlet weak var datePickerView: UIView!
    private var desks = [DeskModel]()
    private var startDate = ""
    private var endDate = ""
    
    private var startD = ""
    private var endD = ""
    private var deskID = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.minimumDate = Date()
        datepicker.maximumDate = Date(timeIntervalSinceNow: 60*60*72)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBOutlet weak var seatL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    
    @IBAction func selectClicked(_ sender: Any) {
        if desks.isEmpty {
            iGBSProgressHUD.showWaiting(view: self.view, label: "requesting desks...")
            HttpOperation.sharedInstance.getDesks(success: {[weak self] (data) in
                guard let sself = self else { return }
                
                DispatchQueue.main.async(){
                    iGBSProgressHUD.stopWaiting()
                    sself.desks.removeAll()
                    for item in data{
                        let seat = DeskModel(item as! NSDictionary)
                        sself.desks.append(seat)
                    }
                    
                    sself.actionDesk()
                }
            }){[weak self] (code, msg) in
                guard let sself = self else { return }
                DispatchQueue.main.async(){
                    iGBSProgressHUD.stopWaiting()
                    sself.alert("desk error", msg: "get desk failed")
                }
            }
        }else{
            self.actionDesk()
        }
    }

    @IBAction func DateClicked(_ sender: Any) {
        if startDate.isEmpty == false && endDate.isEmpty == false{
            startDate = ""
            endDate = ""
        }
        
        pickerYCons.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
     }
    
    @IBAction func BookClicked(_ sender: Any) {
        print("ID:\(deskID),start:\(startD), end:\(endD)")
        if deskID == 0 {
            alert(msg: "please select desk.")
            return
        }
        
        if startD.isEmpty || endD.isEmpty {
            alert(msg:"please select booking date")
            return
        }
        
        iGBSProgressHUD.showWaiting(view: self.view, label: "booking desk...")

        HttpOperation.sharedInstance.book(desk: String(deskID), start: startD, end: endD, success: {[weak self] (dic) in
            guard let sself = self else { return }
            
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
            }
            _ = SeatsModel(dic)

            sself.alert(msg: "Book Success!")
            sself.navigationController?.popViewController(animated: true)
        }){[weak self] (code, msg) in
            guard let sself = self else { return }
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
                sself.alert("Login error", msg: msg, yetTitle: "OK", handleYes: nil, noTitle: nil, handleNo: nil)
            }
        }
        
        
    }


    private func actionDesk(){
        let actionSheet = UIActionSheet(title: "Select Desk", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        for desk in self.desks {
            actionSheet.addButton(withTitle: desk.label)
        }
        actionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        if buttonIndex > 0{
            deskL.text = desks[buttonIndex-1].label
            deskID = desks[buttonIndex-1].ID
        }
    }

    @IBAction func dateOKClicked(_ sender: Any) {
        self.dateCancelClicked(sender)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        let date = datepicker.date
        let dateText = formatter.string(from: date)
        
        formatter.timeZone = TimeZone.init(identifier: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateParam = formatter.string(from: date)
        if startDate.isEmpty {
            startDate = dateText
            startD = dateParam
            dateL.text = startDate
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.DateClicked(UIButton())
            }
        }else{
            endDate = dateText
            endD = dateParam
            dateL.text = "\(dateL.text!) to \(dateText)"
        }
    }
    
    @IBAction func dateCancelClicked(_ sender: Any) {
        pickerYCons.constant = -300
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    

}
