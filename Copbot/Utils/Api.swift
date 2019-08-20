//
//  Api.swift
//  Copbot
//
//  Created by Admin on 5/5/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Api {
    static func getJSON(url: String, callback: @escaping ((JSON?, Error?)->())) {
        request(url)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    callback(json, nil)
                case .failure(let error):
                    print("failed: ", error.localizedDescription)
                    callback(nil, error)
                }
        }
    }
    
    static func getProducts( callback: @escaping (([[String:Any]])->()) ) {
        
        var allProducts = [[String:Any]]()
        Api.getJSON(url: Contents.Api.mobile_stock) { (json, error) in
            guard let json = json else {return}
            
            let group = DispatchGroup()
            
            let productCategories = json["products_and_categories"].dictionaryValue
            for (category, productCategories) in productCategories {
                if category == "new" {
                    continue
                }

                let products = productCategories.arrayValue
                for product in products {
                    let productId = product["id"].intValue
                    let productName = product["name"].stringValue
                    group.enter()
                    Api.getJSON(url: String(format: Contents.Api.product_detail, productId)){ (detailJSON, error) in
                        guard let detailJSON = detailJSON else {return}
                        
                        let styles = detailJSON["styles"].arrayValue
                        for style in styles {
                            let styleId = style["id"].intValue
                            let color = style["name"].stringValue
//                            if !PRODUCT_COLORS.contains(color) {
//                                PRODUCT_COLORS.append(color)
//                            }
                            let productImageUrl = style["image_url"].stringValue
                            let sizes = style["sizes"].arrayValue
                            for sizeJSON in sizes {
                                let sizeId = sizeJSON["id"].intValue
                                let size = sizeJSON["name"].stringValue
                                let stockLevel = sizeJSON["stock_level"].intValue
                                let soldOut = (stockLevel == 0)
                                if soldOut {
                                    continue
                                }
                                let product: [String: Any] = [
                                    "category": category,
                                    "id": productId,
                                    "styleId": styleId,
                                    "sizeId": sizeId,
                                    "name": productName.trimmingCharacters(in: .whitespaces),
                                    "imageUrl": productImageUrl,
                                    "color": color,
                                    "size": size,
                                    "url": String(format: Contents.Api.mobileProduct, productId, styleId),
                                    "soldOut": soldOut,
                                ]
                                
                                allProducts.append(product)
                            }
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main, execute: {
                callback(allProducts)
            })
        }
    }
}
