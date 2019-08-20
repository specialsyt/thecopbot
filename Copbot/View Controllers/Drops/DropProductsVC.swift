//
//  DropProductsVC.swift
//  Copbot
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class DropProductsVC: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var drop: JSON!
    var products = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = drop["name"].stringValue
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        if let flowLayout = productsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        
        getProducts()
    }

    func getProducts() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        request(String(format: Contents.Api.dropProducts, drop["slug"].stringValue))
            .validate()
            .responseJSON { (response) in
                hud.hide(animated: true)
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    self.products = json.arrayValue
                    self.productsCollectionView.reloadData()
                    
                case .failure(let error):
                    print("failed: ", error.localizedDescription)
                }
        }
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
}

extension DropProductsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DropProductCell", for: indexPath) as! DropProductCell
        let product = products[indexPath.item]
        cell.product = product
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 10, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addVC = STORYBOARD.instantiateViewController(withIdentifier: "AddTaskVC") as! AddTaskVC
        addVC.selectedProduct = products[indexPath.item]
        navigationController?.pushViewController(addVC, animated: true)
    }
}
