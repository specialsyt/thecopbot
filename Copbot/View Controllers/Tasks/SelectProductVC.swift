//
//  SelectDropVC.swift
//  Copbot
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class SelectProductVC: UITableViewController {

    var onSelectProduct: ((JSON)->(Void))!
    
    var products = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        getProducts()
    }
    
    func getProducts() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        request(String(format: Contents.Api.dropProducts, "latest"))
            .validate()
            .responseJSON { (response) in
                hud.hide(animated: true)
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    self.products = json.arrayValue
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("failed: ", error.localizedDescription)
                }
        }
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableCell", for: indexPath) as! ProductTableCell
        
        let product = products[indexPath.row]
        cell.product = product
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectProduct(products[indexPath.row])
        performSegueToReturnBack()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
