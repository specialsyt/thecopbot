//
//  AddTaskVC.swift
//  Copbot
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddTaskVC: UITableViewController {

    @IBOutlet weak var productNamelabel: UILabel!
    @IBOutlet weak var productCategoryField: UITextField!
    @IBOutlet weak var productColorField: UITextField!
    @IBOutlet weak var productSizeField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var selectedProduct: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        productColorField.loadDropdownData(data: PRODUCT_COLORS)
        
        loadProduct()
    }
    
    func loadProduct() {
        if selectedProduct == nil { return }
 
        let productName = selectedProduct["name"].stringValue
        self.productNamelabel.text = productName

        let categoryAPI = selectedProduct["category"].stringValue
        var productCategory = "Any"
        if let categoryIndex = PRODUCT_CATEGORIES_API.index(of: categoryAPI) {
            productCategory = PRODUCT_CATEGORIES[categoryIndex]
        }
        self.productCategoryField.text = productCategory
        self.productSizeField.loadDropdownData(data: PRODUCT_SIZES[productCategory]!)
        self.tableView.reloadData()
    }

    @IBAction func onSave(_ sender: Any) {
        let imageUrl = selectedProduct["imageUrl"].stringValue
        let name = selectedProduct["name"].stringValue
        let category = productCategoryField.text!
        let color = productColorField.text!
        let size = productSizeField.text!

        let task = [
            "imageUrl": imageUrl,
            "name": name.trimmingCharacters(in: .whitespaces),
            "category": category,
            "color": color,
            "size": size,
        ]
        
        AppData.tasks.append(task)
        performSegueToReturnBack()
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let selectProductVC = STORYBOARD.instantiateViewController(withIdentifier: "SelectProductVC") as! SelectProductVC
            selectProductVC.onSelectProduct = { product in
                self.selectedProduct = product
                self.loadProduct()
            }
            self.navigationController?.pushViewController(selectProductVC, animated: true)
            return
        }
    }
    
}
