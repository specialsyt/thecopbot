//
//  DropProductCell.swift
//  Copbot
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class DropProductCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var product: JSON! {
        didSet{
            productImageView.sd_setImage(with: URL(string: product["imageUrl"].stringValue), completed: nil)

            productNameLabel.text = product["name"].stringValue
            productPriceLabel.text = product["price"].stringValue
        }
    }
    
    override func awakeFromNib() {
//        productImageView.makeCircularView()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
