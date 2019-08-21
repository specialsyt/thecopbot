//
//  SearchProductsVC.swift
//  Copbot
//
//  Created by Admin on 5/14/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class SearchProductsVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var elapsedLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedTasks: [Int]!
    
    var countdownTimer: Timer!
    var searchTimer: Timer!
    var elapsedTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){timer in
            self.elapsedTime += 1
            let min = Int(self.elapsedTime / 60)
            let sec = Int(self.elapsedTime % 60)
            let elapsedStr = "\(String(format: "%02d", min)) : \(String(format: "%02d", sec))"
            self.elapsedLabel.text = elapsedStr
        }
        countdownTimer.fire()
    }

    override func viewWillAppear(_ animated: Bool) {
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){timer in
            print("timer", self.elapsedTime)
            Api.getProducts { (products) in
                print("getProducts", self.elapsedTime)
                
                Alamofire.request(Contents.Api.pookyUS, method: .post, headers: nil).responseString {
                    response in
                    switch response.result {
                    case .success:
                        print(response)
                        
                        break
                    case .failure(let error):
                        
                        print(error)
                    }
                }

                var matchedProducts = [[String: Any]]()
                for taskIndex in self.selectedTasks{
                    let task = AppData.tasks[taskIndex]
                    
                    let taskName = task["name"] as! String
                    let taskColor = task["color"] as! String
                    let taskSize = task["size"] as! String
                    
                    var filteredProducts = products.filter({ (product) -> Bool in
                        let productName = product["name"] as! String
                        let productSize = product["size"] as! String
                        let productColor = product["color"] as! String
                        let matchScore = productName.distance(between: taskName)
                        var isMatch = matchScore > 0.8
                        if taskSize != "Any" {
                            isMatch = isMatch && (productSize == taskSize)
                        }
                        if taskColor != "Any" {
                            isMatch = isMatch && (productColor == taskColor)
                        }
                        return isMatch
                    })
                    
                    filteredProducts.sort(by: { (product0, product1) -> Bool in
                        let product0Name = product0["name"] as! String
                        let product1Name = product1["name"] as! String
                        let match0Score = product0Name.distance(between: taskName)
                        let match1Score = product1Name.distance(between: taskName)
                        return match0Score > match1Score
                    })
                    
                    if let product = filteredProducts.first {
                        self.selectedTasks.remove(at: self.selectedTasks.index(of: taskIndex)!)
                        matchedProducts.append(product)
                    }
                }
                if matchedProducts.count > 0{
                    print("matchedProducts", self.elapsedTime)
                    let webVC = STORYBOARD.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                    webVC.products = matchedProducts
                    self.navigationController?.pushViewController(webVC, animated: true)
                    timer.invalidate()
                }
            }
        }
        searchTimer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchTimer.invalidate()
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }

}
