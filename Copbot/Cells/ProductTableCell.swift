//
//  ProductTableCell.swift
//  Copbot
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductTableCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDetailLabel: UILabel!
    
    var product: JSON! {
        didSet{
            productImageView.sd_setImage(with: URL(string: product["imageUrl"].stringValue), completed: nil)
            
            productNameLabel.text = product["name"].stringValue
            productDetailLabel.text = product["category"].stringValue
        }
    }
    
    override func awakeFromNib() {
//        productImageView.makeCircularView()
    }
}
