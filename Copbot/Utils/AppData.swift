//
//  AppUserDefaults.swift
//  Spankrr
//
//  Created by Kangtle on 1/15/18.
//  Copyright © 2018 Kangtle. All rights reserved.
//

import UIKit

class AppData {

    private static let TASKS = "TASKS"
    private static let CLOTHES_SIZE = "CLOTHES_SIZE"
    private static let HAT_SIZE = "HAT_SIZE"
    private static let SHOES_SIZE = "SHOES_SIZE"
    private static let NAVIGATION_TO_CHECKOUT = "NAVIGATION_TO_CHECKOUT"

    private static let FULL_NAME = "FULL_NAME"
    private static let EMAIL = "EMAIL"
    private static let PHONE_NUMBER = "PHONE_NUMBER"
    private static let ADDRESS_1 = "ADDRESS_1"
    private static let ADDRESS_2 = "ADDRESS_2"
    private static let ZIP_CODE = "ZIP_CODE"
    private static let CITY = "CITY"
    private static let COUNTRY = "COUNTRY"
    private static let STATE = "STATE"

    private static let CREDIT_CARD_TYPE = "CREDIT_CARD_TYPE"
    private static let CREDIT_CARD_NUMBER = "CREDIT_CARD_NUMBER"
    private static let CREDIT_CARD_EXPIRE_YEAR = "CREDIT_CARD_EXPIRE_YEAR"
    private static let CREDIT_CARD_EXPIRE_MONTH = "CREDIT_CARD_EXPIRE_MONTH"
    private static let CREDIT_CARD_CVV = "CREDIT_CARD_CVV"

    static var tasks: [[String: Any]] {
        get {
            return USERDEFAULTS.array(forKey: TASKS) as? [[String: Any]] ?? []
        }
        set {
            USERDEFAULTS.set(newValue,forKey: TASKS)
        }
    }

    //Sizes
    static var clothesSize: String {
        get {
            return USERDEFAULTS.string(forKey: CLOTHES_SIZE) ?? "Any"
        }
        set {
            USERDEFAULTS.set(newValue,forKey: CLOTHES_SIZE)
        }
    }
    
    static var shoesSize: String {
        get {
            return USERDEFAULTS.string(forKey: SHOES_SIZE) ?? "Any"
        }
        set {
            USERDEFAULTS.set(newValue,forKey: SHOES_SIZE)
        }
    }

    static var hatSize: String {
        get {
            return USERDEFAULTS.string(forKey: HAT_SIZE) ?? "Any"
        }
        set {
            USERDEFAULTS.set(newValue,forKey: HAT_SIZE)
        }
    }
    
    static var loggedInGmail: String {
        get {
            return USERDEFAULTS.string(forKey: "LOGGED_IN_GMAIL") ?? ""
        }
        set {
            USERDEFAULTS.set(newValue,forKey: "LOGGED_IN_GMAIL")
        }
    }
    
    static var addToCartDelay: Int {
        get {
            return USERDEFAULTS.integer(forKey: "ADD_TO_DELAY")
        }
        set {
            USERDEFAULTS.set(newValue,forKey: "ADD_TO_DELAY")
        }
    }

    static var checkoutDelay: Int {
        get {
            return USERDEFAULTS.integer(forKey: "CHECKOUT_DELAY")
        }
        set {
            USERDEFAULTS.set(newValue,forKey: "CHECKOUT_DELAY")
        }
    }
    
    static var profiles: [[String: String]] {
        get {
            return USERDEFAULTS.array(forKey: "PROFILES") as? [[String: String]] ?? []
        }
        set {
            USERDEFAULTS.set(newValue,forKey: "PROFILES")
        }
    }
    
    static var defaultProfileIndex: Int {
        get {
            return USERDEFAULTS.integer(forKey: "DEFAULT_PROFILE_INDEX")
        }
        set {
            USERDEFAULTS.set(newValue,forKey: "DEFAULT_PROFILE_INDEX")
        }
    }
}
