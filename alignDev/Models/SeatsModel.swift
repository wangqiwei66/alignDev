//
//  PushMsgModel.swift
//  Telematics
//
//  Created by Andrew.Wang on 26/3/2019.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit

class UserModel:NSObject{
    var authenticationToken = ""
    var createdAt = ""
    var email = ""
    var updatedAt = ""
    var ID = 0

    init(_ data:NSDictionary){
        if let authenticationToken = data["authenticationToken"] as? String{
            self.authenticationToken = authenticationToken
        }
        
        if let created_at = data["created_at"] as? String{
            self.createdAt = created_at
        }
        
        if let email = data["email"] as? String{
            self.email = email
        }
        
        if let ID = data["id"] as? Int{
            self.ID = ID
        }
        
        if let updated_at = data["updated_at"] as? String{
            self.updatedAt = updated_at
        }
    }
}

class DeskModel:NSObject {
    var ID = 0
    var label = ""
    var location = ""
    var updatedAt = ""
    var createdAt = ""

    init(_ data:NSDictionary){
        if let updatedAt = data["updated_at"] as? String{
            self.updatedAt = updatedAt
        }
        
        if let created_at = data["created_at"] as? String{
            self.createdAt = created_at
        }
        
        if let location = data["location"] as? String{
            self.location = location
        }
        
        if let label = data["label"] as? String{
            self.label = label
        }
        
        if let ID = data["id"] as? Int{
            self.ID = ID
        }
        
        if let updated_at = data["updated_at"] as? String{
            self.updatedAt = updated_at
        }
    }
}

class SeatsModel:NSObject {
    var ID = 0
    var deskID = 0
    var userID = 0
    var bookedAt = ""
    var bookedFrom = ""
    var bookedTo = ""
    var createdAt = ""
    var desk:DeskModel?
    var user:UserModel?
    
    init(_ data:NSDictionary){
        if let deskID = data["desk_id"] as? Int{
            self.deskID = deskID
        }
        
        if let userID = data["user_id"] as? Int{
            self.userID = userID
        }
        
        if let bookedAt = data["booked_at"] as? String{
            self.bookedAt = bookedAt
        }
        
        if let bookedFrom = data["booked_from"] as? String{
            self.bookedFrom = bookedFrom
        }
        if let bookedTo = data["booked_to"] as? String{
            self.bookedTo = bookedTo
        }
        
        if let ID = data["id"] as? Int{
            self.ID = ID
        }
        
        if let createdAt = data["created_at"] as? String{
            self.createdAt = createdAt
        }
        
        if let desk = data["desk"] as? NSDictionary{
            self.desk = DeskModel(desk)
        }
        
        if let user = data["desk"] as? NSDictionary{
            self.user = UserModel(user)
        }

    }
}


