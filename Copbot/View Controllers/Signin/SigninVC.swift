//
//  ViewController.swift
//  Copbot
//
//  Created by Admin on 4/22/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class SigninVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var tokenField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    @IBAction func onPressedSignin(_ sender: Any) {
        let email = emailField.text!
        let token = tokenField.text!

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //sample log in code : 42c3bf79f97a9862fc414e1ed5e43132e21ba6c3b24d71740f23c945328ea884
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "email": email,
            "license_key": token,
        ]
        request(Contents.Api.authorize,
                method: .post,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers)
            .validate()
            .responseJSON { (response) in
                hud.hide(animated: true)
                
                self.gotoMainTab()
                
                switch response.result {
                case .success(let value):
                    print("JSON: \(value)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }

    func gotoMainTab() {
        let mainTab = STORYBOARD.instantiateViewController(withIdentifier: "MainTab") as! UITabBarController
        mainTab.selectedIndex = 1
        APPDELEGATE.window?.rootViewController = mainTab
    }
}

