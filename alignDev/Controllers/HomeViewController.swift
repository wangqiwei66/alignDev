//
//  HomeViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/2.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    private let CELL_INDENTIFIER:String = "SeatTableViewCell"

    @IBOutlet weak var greetningL: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noLabel: UILabel!
    private var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        greetningL.text = "Hi ,  \(AppSettings.sharedInstance.userEmail ?? "Hi")"
        tableView.register(UINib(nibName:CELL_INDENTIFIER, bundle:nil), forCellReuseIdentifier: CELL_INDENTIFIER)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestData()
    }
    
    private func requestData(){
        iGBSProgressHUD.showWaiting(view: self.view, label: "requesting booked seats...")
        HttpOperation.sharedInstance.getBooklist(success: {[weak self] (dic) in
            guard let sself = self else { return }
            
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()

            }
            
        }){[weak self] (code, msg) in
            guard let sself = self else { return }
            DispatchQueue.main.async(){
                iGBSProgressHUD.stopWaiting()
                sself.alert("Login error", msg: msg, yetTitle: "OK", handleYes: nil, noTitle: nil, handleNo: nil)
            }
        }
    }

    //MARK:- TableViewDelegate/DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let empty = data.isEmpty
        noLabel.isHidden = !empty
        tableView.isHidden = empty
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INDENTIFIER, for: indexPath) as! SeatTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
