//
//  StyleKit.swift
//  Telematics
//
//  Created by Wesley Sui on 1/11/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class StyleKit: NSObject {

    //MARK: Localized String
    struct localizedString {
        static let mainButtonStartTitle: String = NSLocalizedString("main:button_start_title", comment: "")
        static let mainButtonEndTitle: String = NSLocalizedString("main:button_end_title", comment: "")
        
        static let tripBarButtonRealtimeTitle: String = NSLocalizedString("tripbar:button_real_time_title", comment: "")
        static let tripBarButtonHistoryTitle: String = NSLocalizedString("tripbar:button_history_title", comment: "")
        
        static let tripStartTime: String = NSLocalizedString("trip_detail:start_time", comment: "")
        static let tripEndTime: String = NSLocalizedString("trip_detail:end_time", comment: "")
        static let tripOverallScore: String = NSLocalizedString("trip_detail:overall_score", comment: "")
    }
    
    //MARK: Color
    struct Color {
        static let tintColor  = UIColor(red: 92/255, green: 106/255, blue: 108/255, alpha: 1)
        static let backgroundColor = UIColor(red: 70/255, green: 80/255, blue: 80/255, alpha: 1)
        static let darkYellow = UIColor(red: 202/255, green: 221/255, blue: 2/255, alpha: 1)
        static let lightYellow = UIColor(red: 236/255, green: 249/255, blue: 82/255, alpha: 1)
    }
    
    //MARK: Font
    struct Font {
    }
}
