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
    
    func postLogin(_ email:String, pwd:String ,success: @escaping ((NSDictionary) -> Void), failure: @escaping ((Int, String) -> Void) ){
        //9.112.229.66
        let url = hostUrl + "/users/sign_in.json"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "user[key]=\(email)&use[password]=\(pwd)"
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
    
    func login(_ email:String, pwd:String ,success: @escaping ((NSDictionary) -> Void), failure: @escaping ((Int, String) -> Void) ){
        let url = hostUrl + "/users/sign_in.json"
        let paraDictionary = ["user[key]":email,"use[password]":pwd]
        print("login: \(url)")
        print("login body: \(paraDictionary.description)")
        HttpUtils.sendRequest(url: url, httpMethod: .POST, queryParameters: nil, headerFields: headers, bodyData: paraDictionary as NSDictionary, success: {(data) -> Void in
            if let dictionary : NSDictionary = try!JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                if let respCode = dictionary["respCode"] as? Int, respCode != 0 {
                    print("login error, respCode: \(respCode)")
                    failure(respCode,dictionary["respMsg"] as! String)
                    return
                }
                if let dic = dictionary["data"] as? NSDictionary{
                    success(dic)
                }
            }
        }) { (code, message) -> Void in
            failure(code,message)
        }
    }
}
