//
//  HttpOperation.swift
//  Telematics
//
//  Created by Andrew.Wang on 21/11/2018.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation
class HttpOperation: NSObject {
    
    var hostUrl:String{
        get{
            return AppSettings.sharedInstance.hostUrl
        }
    }
    
    static let sharedInstance:HttpOperation = HttpOperation()
    var headers = [
        "content-type": "application/json",
        "accept": "application/json"
    ]
    
    private override init() {
        super.init()
    }
    
    func login(_ email:String, pwd:String ,success: @escaping ((NSDictionary) -> Void), failure: @escaping ((Int, String) -> Void) ){
        //9.112.229.66
        let url = hostUrl + "/users/sign_in.json"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "user[email]=\(email)&user[password]=\(pwd)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                failure(-1,error.debugDescription)
                return
            }
            
            if data != nil, let dictionary : NSDictionary = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                print("data:\(dictionary)")
                if let err = dictionary["error"]{
                    var msg = "login failed"
                    if let msgStr = err as? String{
                        msg = msgStr
                    }
                    failure(-1,msg)
                    return
                }
                
                success(dictionary)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                //                failure(httpStatus.statusCode,httpStatus.)
                return
            }
        }
        task.resume()
    }
    
    func register(_ email:String, pwd:String ,success: @escaping ((NSDictionary) -> Void), failure: @escaping ((Int, String) -> Void) ){
        //9.112.229.66
        let url = hostUrl + "/users.json"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "user[email]=\(email)&user[password]=\(pwd)&user[password_confirmation]=\(pwd)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                failure(-1,error.debugDescription)
                return
            }
            
            if data != nil, let dictionary : NSDictionary = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                print("data:\(dictionary)")
                if let err = dictionary["error"] as? String{
                    failure(-1,err)
                    return
                }
                
                success(dictionary)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
        }
        task.resume()
    }
    func getBooklist(success: @escaping ((NSArray) -> Void), failure: @escaping ((Int, String) -> Void) ){
        //9.112.229.66
        let url = hostUrl + "/bookings.json"
        var request = URLRequest(url: URL(string: url)!)
        print("getBooklist ,url:\(url)")
        request.addValue("AppSettings.sharedInstance.userEmail!", forHTTPHeaderField: "X-User-Email")
        request.addValue("AppSettings.sharedInstance.deviceToken!", forHTTPHeaderField: "X-User-Token")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                failure(-1,error.debugDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                failure(-1,String(describing: response))
                return
            }
            
            //            let str = String.init(data: data!, encoding: .utf8)
            //            print("dataStr:\(str)")
            if data != nil, let array : NSArray = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray{
                print("data:\(array)")
                let myArray = array.filter({ (item) -> Bool in
                    let dic = item as! NSDictionary
                    return dic["user_id"] as? Int == AppSettings.sharedInstance.userId!
                })
                success(myArray as NSArray)
                return
            }
            
            
        }
        task.resume()
    }
    
    func getDesks(success: @escaping ((NSArray) -> Void), failure: @escaping ((Int, String) -> Void) ){
        //9.112.229.66
        let url = hostUrl + "/desks.json"
        var request = URLRequest(url: URL(string: url)!)
        print("getDesks ,url:\(url)")
        request.addValue("AppSettings.sharedInstance.userEmail!", forHTTPHeaderField: "X-User-Email")
        request.addValue("AppSettings.sharedInstance.deviceToken!", forHTTPHeaderField: "X-User-Token")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                failure(-1,error.debugDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                failure(-1,String(describing: response))
                return
            }
            
            if data != nil, let seats : NSArray = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray{
                print("seats:\(seats)")
                //            let str = String.init(data: data!, encoding: .utf8)
                //            print("dataStr:\(str)")
                success(seats)
                return
            }
        }
        task.resume()
    }
    
    func book(desk:String,start:String,end:String,success: @escaping ((NSDictionary) -> Void), failure: @escaping ((Int, String) -> Void) ){
        //9.112.229.66
        let url = hostUrl + "/bookings.json"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(identifier: "GMT")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let now = formatter.string(from: Date())
        let postString = "booking[desk_id]=\(desk)&booking[booked_at]=\(now)&booking[booked_from]=\(start)&booking[booked_to]=\(end)"
        request.httpBody = postString.data(using: .utf8)
        request.addValue("AppSettings.sharedInstance.userEmail!", forHTTPHeaderField: "X-User-Email")
        request.addValue("AppSettings.sharedInstance.deviceToken!", forHTTPHeaderField: "X-User-Token")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                failure(-1,error.debugDescription)
                return
            }
            
            if data != nil, let dictionary : NSDictionary = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                print("data:\(dictionary)")
                if let err = dictionary["error"] as? String{
                    failure(-1,err)
                    return
                }
                
                success(dictionary)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
        }
        task.resume()
    }
    
}
