//
//  TaskCell.swift
//  Copbot
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SDWebImage

protocol TaskCellDelegate {
    func onEnableTask(indexOfTask: Int, isEnable: Bool)
}

class TaskCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDetailLabel: UILabel!
    @IBOutlet weak var enabelSwitch: UISwitch!
    
    var delegate: TaskCellDelegate!
    
    var indexOfTask: Int!

    var task: [String: Any]! {
        didSet{
            let imageUrl = task["imageUrl"] as! String
            let name = task["name"] as! String
            let category = task["category"] as! String
            let color = task["color"] as! String
            let size = task["size"] as! String

            productImageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
            productNameLabel.text = name
            productDetailLabel.text = "\(category) - \(color) ( \(size) )"
        }
    }
    
    override func awakeFromNib() {
//        productImageView.makeCircularView()
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        delegate.onEnableTask(indexOfTask: indexOfTask, isEnable: enabelSwitch.isOn)
    }
}
