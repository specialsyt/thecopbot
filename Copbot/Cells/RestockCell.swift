//
//  RestockCell.swift
//  Copbot
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestockCell: UITableViewCell {
    @IBOutlet weak var restockImageView: UIImageView!
    @IBOutlet weak var restockTitleLabel: UILabel!
    @IBOutlet weak var restockDetailLabel: UILabel!
    
    var restock: [String: Any]! {
        didSet {
            let imageUrl = restock["imageUrl"] as! String
            let title = restock["name"] as! String
            let color = restock["color"] as! String
            let size = restock["size"] as! String
            let category = restock["category"] as! String
            let soldOut = restock["soldOut"] as! Bool
            let realImageUrl = "https:\(imageUrl)"

            restockImageView.sd_setImage(with: URL(string: realImageUrl)!, completed: nil)
            restockTitleLabel.text = title
            if soldOut {
                restockDetailLabel.text = "\(category) (\(color)/\(size)) - Sold Out"
            }else{
                restockDetailLabel.text = "\(category) (\(color)/\(size))"
            }
        }
    }
    
    override func awakeFromNib() {
//        restockImageView.makeCircularView()
    }
}
