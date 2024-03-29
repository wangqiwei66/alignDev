//
//  StringCategory.swift
//  alignDev
//
//  Created by 汪奇伟 on 2019/7/1.
//  Copyright © 2019 汪奇伟. All rights reserved.
//

import Foundation
extension String{
    func isEmailFormat()->Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,emailRegex)
        return predicate.evaluate(with:self)
    }
    
    func toDate()->Date?{
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.local//TimeZone(identifier: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter.date(from: self)
        return date
    }
    
}
