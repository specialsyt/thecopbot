//
//  EditProfileVC.swift
//  Copbot
//
//  Created by Admin on 3/9/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var address1Field: UITextField!
    @IBOutlet weak var address2Field: UITextField!
    @IBOutlet weak var address3Field: UITextField!
    @IBOutlet weak var postcodeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var cardTypeField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardExpireMonthField: UITextField!
    @IBOutlet weak var cardExpireYearField: UITextField!
    @IBOutlet weak var cardCVVField: UITextField!
    
    var editingIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardNumberField.setAsCardNumberField()

        countryField.loadDropdownData(data: COUNTRIES)
        cardTypeField.loadDropdownData(data: CARD_TYPES)

        let months = (1...12).map{String(format: "%02d", $0)}
        cardExpireMonthField.loadDropdownData(data: months)
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        let years = (0...10).map{"\(year + $0)"}
        cardExpireYearField.loadDropdownData(data: years)

        if editingIndex >= 0 {
            let editingProfile = AppData.profiles[editingIndex]
            fullnameField.text = editingProfile["full-name"]
            emailField.text = editingProfile["email"]
            phoneNumberField.text = editingProfile["phone-number"]
            address1Field.text = editingProfile["address1"]
            address2Field.text = editingProfile["address2"]
            address3Field.text = editingProfile["address3"]
            postcodeField.text = editingProfile["postcode"]
            cityField.text = editingProfile["city"]
            stateField.text = editingProfile["state"]
            countryField.dropDownText = editingProfile["country"]!
            cardTypeField.dropDownText = editingProfile["card-type"]!
            cardNumberField.text = editingProfile["card-number"]
            cardExpireMonthField.dropDownText = editingProfile["card-exp-month"]!
            cardExpireYearField.dropDownText = editingProfile["card-exp-year"]!
            cardCVVField.text = editingProfile["card-cvv"]
        }
    }
    
    @IBAction func onPressSave(_ sender: Any) {
        
        var profile = editingIndex >= 0 ? AppData.profiles[editingIndex] : [String: String]()
        
        profile["full-name"] = fullnameField.text
        profile["email"] = emailField.text
        profile["phone-number"] = phoneNumberField.text
        profile["address1"] = address1Field.text
        profile["address2"] = address2Field.text
        profile["address3"] = address3Field.text
        profile["postcode"] = postcodeField.text
        profile["city"] = cityField.text
        profile["state"] = stateField.text
        profile["country"] = countryField.text
        profile["card-type"] = cardTypeField.text
        profile["card-number"] = cardNumberField.text
        profile["card-exp-month"] = cardExpireMonthField.text
        profile["card-exp-year"] = cardExpireYearField.text
        profile["card-cvv"] = cardCVVField.text

        if editingIndex >= 0 {
            AppData.profiles[editingIndex] = profile
        }else{
            profile["default"] = "no"
            AppData.profiles.append(profile)
        }
        
        self.performSegueToReturnBack()
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
}
