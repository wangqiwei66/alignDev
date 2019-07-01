//
//  AppSettings.swift
//  Telematics
//
//  Licensed Materials - Property of IBM
//  6949 - XXX
//  (C)Copyright IBM Corp. 2015 All Rights Reserved
//  US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//

import UIKit
class AppSettings: NSObject {
    
    private struct Defaults {
        static let intervalSendDataKey = "AppSettings.Defaults.intervalSendDataKey"
        static let firstLaunchKey = "AppSettings.Defaults.firstLaunchKey"
        static let userIdKey = "AppSettings.Defaults.userIdKey"
        static let usernameKey = "AppSettings.Defaults.usernameKey"
        static let useremailKey = "AppSettings.Defaults.useremailKey"
        static let deviceTokenKey = "AppSettings.Defaults.deviceTokenKey"
        static let passwordKey = "AppSettings.Defaults.passwordKey"
        static let hostUrlKey = "AppSettings.Defaults.hostUrlKey"
        static let userPasswordKey = "AppSettings.Defaults.userPasswordKey"
    }
    
    private let defaultHostUrl = "http://apac-ar-test.herokuapp.com"

    var devicePassword:String = "123"
    var organizationId:String?
    
    var authorization:String?
    
    private override init() {
        super.init()
        
        // register the default options
        let defaultOptions: [String: AnyObject] = [
            Defaults.firstLaunchKey: true as AnyObject,
            Defaults.intervalSendDataKey: 15.0 as AnyObject,
            Defaults.userIdKey: NSUUID().uuidString as AnyObject,
            Defaults.hostUrlKey: defaultHostUrl as AnyObject
        ]
        
        UserDefaults.standard.register(defaults: defaultOptions)
        
    }
    class var sharedInstance:AppSettings {
        struct Singleton {
            static let instance = AppSettings()
        }
        
        return Singleton.instance
    }
    
    
    var hostUrl: String {
        return UserDefaults.standard.string(forKey: Defaults.hostUrlKey) ?? defaultHostUrl
    }
    
    var sendDataInterval: Double {
        return UserDefaults.standard.double(forKey: Defaults.intervalSendDataKey)
    }
    
    var userId: String {
        return UserDefaults.standard.string(forKey: Defaults.userIdKey) ?? ""
    }
    var tenant_id: String = ""
    var mobile_phone:String = ""
    var mo_id: String = ""
    
    var userName: String? {
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(newValue, forKey: Defaults.usernameKey)
            userDefaults.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: Defaults.usernameKey)
        }
            }
    
    var userEmail: String? {
        
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(newValue, forKey: Defaults.useremailKey)
            userDefaults.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: Defaults.useremailKey)
        }
    }
    
    var deviceToken: String? {
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(newValue, forKey: Defaults.deviceTokenKey)
            userDefaults.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: Defaults.deviceTokenKey)
        }
    }
    
    var userPassword: String? {
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(newValue, forKey: Defaults.passwordKey)
            userDefaults.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: Defaults.passwordKey)
        }
    }
    
    func runHandlerOnFirstLaunch(firstLaunchHandler: () -> ()) {
        // grab user defaults
        let userDefaults = UserDefaults.standard
        // check if first launch
        if userDefaults.bool(forKey: Defaults.firstLaunchKey) {
            userDefaults.set(false, forKey: Defaults.firstLaunchKey)
            
            firstLaunchHandler()
        }
    }
    
}
