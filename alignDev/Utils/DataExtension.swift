//
//  DataExtension.swift
//  Telematics
//
//  Created by Andrew.Wang on 5/12/2018.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}
