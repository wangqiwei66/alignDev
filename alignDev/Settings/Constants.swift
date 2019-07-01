//
//  iGBSConstants.swift
//  iGBSMobile
//
//  Created by ZhangJin on 28/6/2017.
//  Copyright © 2017 IBM Corporation. All rights reserved.
//

import Foundation

let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"]

let DEVICE_UUID = UIDevice.current.identifierForVendor?.uuidString

let isPhoneDevice = (UI_USER_INTERFACE_IDIOM() == .phone)

let isPhoneX = isPhoneDevice && (UIScreen.main.currentMode?.size == CGSize(width:1125, height:2436) || UIScreen.main.currentMode?.size == CGSize(width:750, height:1624))


var FUll_VIEW_WIDTH:CGFloat  {
    return UIScreen.main.bounds.size.width
}

var FUll_VIEW_HEIGHT:CGFloat  {
    return UIScreen.main.bounds.size.height
}

let IPHONEX_OFFSET_Y:CGFloat = isPhoneX ? 24 : 0





