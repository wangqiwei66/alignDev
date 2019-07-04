//
//  SeatDetailViewController.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/4.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import UIKit

class SeatDetailViewController: UIViewController {

    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var emailL: UILabel!
    @IBOutlet weak var deskL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    
    var model:SeatsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mo = model{
            if let label = mo.desk?.label{
                deskL.text = label
            }
            
            if let name = mo.user?.email{
                nameL.text = name
                emailL.text = name
            }
            
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone.local
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            if let fromDate = formatter.date(from: mo.bookedFrom),let endDate = formatter.date(from: mo.bookedTo){
                dateL.text = "\(fromDate) To \(endDate)"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.tintColor = .white
    }

    
}
