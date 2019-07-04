//
//  AlertHistoryTableViewCell.swift
//  Telematics
//
//  Created by Andrew.Wang on 19/3/2019.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit

class SeatTableViewCell: UITableViewCell {

    @IBOutlet weak var desk: UILabel!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet var dateL: UILabel!
    
    var model:SeatsModel? {
        didSet{
            guard let mo = model else {
                return
            }
            
            if let label = mo.desk?.label{
                desk.text = label
            }
            
            if let name = mo.user?.email{
                nameL.text = name
            }

            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone.local
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            if let fromDate = formatter.date(from: mo.bookedFrom),let endDate = formatter.date(from: mo.bookedTo){
                dateL.text = "\(fromDate) To \(endDate)"
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
