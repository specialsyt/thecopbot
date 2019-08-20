//
//  DropsVC.swift
//  Copbot
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class DropsVC: UIViewController {

    @IBOutlet weak var dropsTableView: UITableView!
    
    var drops = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dropsTableView.delegate = self
        dropsTableView.dataSource = self
        
        getDrops()
    }

    func getDrops() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)

        request(Contents.Api.drops)
        .validate()
        .responseJSON { (response) in
            hud.hide(animated: true)

            switch response.result {
            case .success(let value):

                let json = JSON(value)
                print("JSON: \(json)")

                self.drops = json.arrayValue
                self.dropsTableView.reloadData()

            case .failure(let error):
                print("failed: ", error.localizedDescription)
            }
        }
    }
}

extension DropsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropCell", for: indexPath)
        let drop = drops[indexPath.row]
        cell.textLabel?.text = drop["name"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productsVC = STORYBOARD.instantiateViewController(withIdentifier: "DropProductsVC") as! DropProductsVC
        productsVC.drop = drops[indexPath.row]
        self.navigationController?.pushViewController(productsVC, animated: true)
    }
}
