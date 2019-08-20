//
//  AppContent.swift
//  Spankrr
//
//  Created by Kangtle on 1/15/18.
//  Copyright © 2018 Kangtle. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
let USERDEFAULTS = UserDefaults.standard
let LOC_MANAGER = CLLocationManager()

//Colors
let BACKGROUND_COLOR_1 = UIColor.white

let RED_COLOR = UIColor.init(rgb: 0xD0021B)
let LIGHT_GRAY = UIColor.init(rgb: 0xF1F2F6)
let LIGHT_GREEN = UIColor.green
let GREEN = UIColor.init(rgb: 0x2EB872)

//APP

let PRODUCT_CATEGORIES = ["Any", "Bags", "Accessories", "Skate", "Pants", "Tops/Sweaters", "Shirts", "Shorts", "Sweatshirts", "Jackets", "Hats", "T-Shirts"]
let PRODUCT_CATEGORIES_API = ["any", "bags", "accessories", "skate", "pants", "tops-sweaters", "shirts", "shorts", "sweatshirts", "jackets", "hats", "t-shirts"]

var PRODUCT_COLORS = [
    "Any", "Amber", "Ash Grey", "Black", "Black Polka Dot", "Blue", "Bright Blue", "Bright Green", "Bright Purple", "Bright Royal", "Brown", "Burgundy", "Burgundy Polka Dot", "Clear", "Coral", "Dark Aqua", "Dark Green", "Dark Pink", "Dark Rose", "Dark Rust", "Dusty Blue", "Dusty Teal", "Flames", "Gold", "Gold 58MM", "Green", "Grey", "Heather Grey", "Herringbone", "Khaki", "Lemon", "Light Blue", "Light Brown", "Light Green", "Light Navy Polka Dot", "Light Olive", "Light Tan", "Magenta", "Mint", "Multi", "Multicolor", "Mustard", "Natural", "Navy", "Neon Orange", "Olive", "Orange", "Panther", "Purple", "Red", "Red 51MM", "Silver", "Slate", "Teal", "Teal", "Terracotta", "Violet", "Washed Black", "Washed Blue", "Washed Olive", "Washed Plum", "White", "White 53MM", "Woodland Camo", "Yellow"]

let PRODUCT_SIZES: [String: [String]] = [
    "Any": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Bags": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Accessories": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Skate": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Pants": ["Any", "Small", "Medium", "Large", "XLarge", "28", "30", "32", "34", "36", "38", "40"],
    "Tops/Sweaters": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Shirts": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Shorts": ["Any", "Small", "Medium", "Large", "XLarge", "28", "30", "32", "34", "36", "38", "40"],
    "Sweatshirts": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Jackets": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Hats": ["Any", "7 1/4", "7 1/4", "7 3/8", "7 1/2", "7 5/8", "7 3/4", "8"],
    "T-Shirts": ["Any", "Small", "Medium", "Large", "XLarge"],
    "Shoes": [
        "Any", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9",
        "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13", "13.5", "14", "14.5"
    ],
]

let COUNTRIES = ["UK", "UK (N. IRELAND)", "AUSTRIA", "BELARUS", "BELGIUM", "BULGARIA", "CROATIA", "CZECH REPUBLIC", "DENMARK", "ESTONIA", "FINLAND", "FRANCE", "GERMANY", "GREECE", "HUNGARY", "ICELAND", "IRELAND", "ITALY", "LATVIA", "LITHUANIA", "LUXEMBOURG", "MONACO", "NETHERLANDS", "NORWAY", "POLAND", "PORTUGAL", "ROMANIA", "RUSSIA", "SLOVAKIA", "SLOVENIA", "SPAIN", "SWEDEN", "SWITZERLAND", "TURKEY", "United States", "Canada"]

let CARD_TYPES = ["Visa", "American Express", "Mastercard", "Solo"]

struct Contents {
    struct Api {
        static let root = "https://api.thecopbot.com/api/"
        static let authorize = "\(root)/user/auth"
        
        static let copbotRoot = "https://copbot-api-beta.sloppy.zone"
        
        static let drops = "\(copbotRoot)/drops/"
        static let dropProducts = "\(copbotRoot)/drops/%@/products"
        static let restocks = "\(copbotRoot)/stock"
        
        static let supremenewyork = "https://www.supremenewyork.com"
        static let mobile_stock = "\(supremenewyork)/mobile_stock.json"
        static let product_detail = "\(supremenewyork)/shop/%d.json"
        static let mobileProduct = "\(supremenewyork)/mobile#products/%d/%d"
    }
}
