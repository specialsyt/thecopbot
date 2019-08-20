//
//  RestocksVC.swift
//  Copbot
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class RestocksVC: UIViewController {

    @IBOutlet weak var restocksTableView: UITableView!
    
    var restocks = [[String:Any]]()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.restocksTableView.addSubview(self.refreshControl)

        restocksTableView.delegate = self
        restocksTableView.dataSource = self
        restocksTableView.rowHeight = UITableViewAutomaticDimension
        restocksTableView.estimatedRowHeight = 140
        getRestocks()
    }

    func getRestocks() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Api.getProducts { (products) in
            self.restocks = products
            hud.hide(animated: true)
            self.restocksTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        Api.getProducts { (products) in
            self.restocks = products
            self.restocksTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}


extension RestocksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restockCell = tableView.dequeueReusableCell(withIdentifier: "RestockCell", for: indexPath) as! RestockCell
        let restock = restocks[indexPath.row]
        restockCell.restock = restock
        return restockCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Helper.confirmMessage(target: self, title: "Restock Checkout", message: "You are attempting to checkout a restocked product. Are you sure?") {
            let restock = self.restocks[indexPath.row]
            let webVC = STORYBOARD.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            webVC.products = [restock]
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
}
