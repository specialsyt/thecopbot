//
//  ProfileCell.swift
//  Copbot
//
//  Created by Admin on 3/9/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate {
    func onDefaultSwitch(indexOfProfile: Int, isOn: Bool)
}

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var defaultSwitch: UISwitch!
    
    var delegate: ProfileCellDelegate!

    var indexOfProfile: Int!
    
    var profile: [String: String]! {
        didSet{

            let fullName = profile["full-name"]
            let cardType = profile["card-type"] ?? "credit-card"
            let cardExpMonth = profile["card-exp-month"]
            let cardExpYear = profile["card-exp-year"]

            cardTypeImageView.image = UIImage(named: cardType)
            nameLabel.text = fullName
            cardLabel.text = "Card ending in \(cardExpMonth!)/\(cardExpYear!)"
            
            defaultSwitch.isOn = profile["default"] == "yes"
        }
    }
    
    override func awakeFromNib() {
        //        productImageView.makeCircularView()
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        delegate.onDefaultSwitch(indexOfProfile: indexOfProfile, isOn: defaultSwitch.isOn)
    }
}
