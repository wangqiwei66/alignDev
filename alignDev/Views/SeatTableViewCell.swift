//
//  AlertHistoryTableViewCell.swift
//  Telematics
//
//  Created by Andrew.Wang on 19/3/2019.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit

class SeatTableViewCell: UITableViewCell {

    @IBOutlet var leadingCon: NSLayoutConstraint!
    @IBOutlet var type: UILabel!
    @IBOutlet var content: UILabel!
    @IBOutlet var unreadDot: UIImageView!
    var model:SeatsModel? {
        didSet{
            guard let mo = model else {
                return
            }


        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
