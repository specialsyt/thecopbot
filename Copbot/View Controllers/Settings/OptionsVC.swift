//
//  OptionsVC.swift
//  Copbot
//
//  Created by Admin on 4/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleSignIn

class OptionsVC: UITableViewController {
    @IBOutlet weak var clothingSizeField: UITextField!
    @IBOutlet weak var shoeSizeField: UITextField!
    @IBOutlet weak var hatSizeField: UITextField!
    @IBOutlet weak var checkoutSwitch: UISwitch!
    @IBOutlet weak var loginGmailButton: UIButton!
    @IBOutlet weak var addToCartDelayField: UITextField!
    @IBOutlet weak var checkoutDelayField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        APPDELEGATE.settingVC = self
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        clothingSizeField.loadDropdownData(data: PRODUCT_SIZES["Jackets"]!)
        shoeSizeField.loadDropdownData(data: PRODUCT_SIZES["Shoes"]!)
        hatSizeField.loadDropdownData(data: PRODUCT_SIZES["Hats"]!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        clothingSizeField.dropDownText = AppData.clothesSize
        shoeSizeField.dropDownText = AppData.shoesSize
        hatSizeField.dropDownText = AppData.hatSize
       
        if AppData.loggedInGmail == "" {
            loginGmailButton.setTitle("Login to your Google Account", for: .normal)
        }else{
            loginGmailButton.setTitle(AppData.loggedInGmail, for: .normal)
        }
        addToCartDelayField.text = String(AppData.addToCartDelay)
        checkoutDelayField.text = String(AppData.checkoutDelay)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppData.clothesSize = clothingSizeField.text!
        AppData.shoesSize = shoeSizeField.text!
        AppData.hatSize = hatSizeField.text!
        AppData.addToCartDelay = Int(addToCartDelayField.text!)!
        AppData.checkoutDelay = Int(checkoutDelayField.text!)!
    }
    
    @IBAction func onPressedLogout(_ sender: Any) {
    }
    
    @IBAction func onPressedLoginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
}

extension OptionsVC: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
    }
}
