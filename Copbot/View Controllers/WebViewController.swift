//
//  WebViewController.swift
//  Copbot
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD
import Alamofire
import SwiftyJSON

class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!

    var currentIndexOfProduct = 0

    var products: [[String: Any]]!
    var hud: MBProgressHUD!

    let getWebContentScript = "document.documentElement.outerHTML"

    var selectSizeScriptFormat = """
        document.querySelector("select#size-options.select-widget").value = '%d'
        document.querySelector("span#size-options-link").innerHTML = '%@'
    """
    
    var selectSizeScript = ""

    let addToCartScript = """
        document.querySelector("span#cart-update span.cart-button").click()
    """
    
    let checkInCartScript = """
        document.querySelector("p#in-cart").style.display != "none"
    """

    let canCheckOutScript = """
        document.querySelector("header div#cart-link").style.display != "none"
    """

    let checkSoldoutScript = """
        document.querySelector("span#cart-update span.sold-out") != null
    """

    let checkoutScript = """
        document.querySelector("a#checkout-now").click()
    """

    let processPaymentScript = """
        var submitButton = document.querySelector('button#submit_button') || document.querySelector('input#submit_button')
        if(submitButton) submitButton.click()
    """

    var setBillingAndCardScript: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if RELEASE
            self.navigationItem.rightBarButtonItem = nil
        #endif
        
        let profile = AppData.profiles.first(where: {$0["default"] == "yes"}) ?? [:]
        let fullname = profile["full-name"] ?? ""
        let email = profile["email"] ?? ""
        let phoneNumber = profile["phone-number"] ?? ""
        let address1 = profile["address1"] ?? ""
        let address2 = profile["address2"] ?? ""
        let address3 = profile["address3"] ?? ""
        let postcode = profile["postcode"] ?? ""
        let city = profile["city"] ?? ""
        let state = profile["state"] ?? ""
        let country = profile["country"] ?? ""
        let cardType = profile["card-type"] ?? ""
        let cardNumber = profile["card-number"] ?? ""
        let cardExpireMonth = profile["card-exp-month"] ?? ""
        let cardExpireYear = profile["card-exp-year"] ?? ""
        let cardCVV = profile["card-cvv"] ?? ""
        
        setBillingAndCardScript = """
            var nameField = document.querySelector('input#order_billing_name')
            if(nameField) nameField.value = '\(fullname)'
        
            var emailField = document.querySelector('input#order_email')
            if(emailField) emailField.value = '\(email)'

            var phoneNumberField = document.querySelector('input#order_tel')
            if(phoneNumberField) phoneNumberField.value = '\(phoneNumber)'
        
            var address1Field = document.querySelector('input#order_billing_address')
            if(address1Field) address1Field.value = '\(address1)'
        
            var address2Field = document.querySelector('input#order_billing_address_2')
            if(address2Field) address2Field.value = '\(address2)'
        
            var address3Field = document.querySelector('input#order_billing_address_3')
            if(address3Field) address3Field.value = '\(address3)'
        
            var cityField = document.querySelector('input#order_billing_city')
            if(cityField) cityField.value = '\(city)'

            var zipCodeField = document.querySelector('input#obz') || document.querySelector('input#order_billing_zip')
            if(zipCodeField) zipCodeField.value = '\(postcode)'

            var countrySelect = document.querySelector('select#order_billing_country')
            if(countrySelect){
                var countrySelectContainer = countrySelect.parentElement.parentElement
                var countryUL = countrySelectContainer.querySelector('.selectric-items ul')
                if(countryUL){
                    for(var child of countryUL.childNodes){
                        if(child.innerHTML == '\(country)') child.click()
                    }
                }else{
                    for(var option of countrySelect.options){
                        if(option.text == '\(country)') option.selected = true
                    }
                }
            }
        
            var stateSelect = document.querySelector('select#order_billing_state')
            if(stateSelect){
                var stateSelectContainer = stateSelect.parentElement.parentElement
                var stateUL = stateSelectContainer.querySelector('.selectric-items ul')
                if(stateUL){
                    for(var child of stateUL.childNodes){
                        if(child.innerHTML == '\(state)') child.click()
                    }
                }else{
                    for(var option of stateSelect.options){
                        if(option.text == '\(state)') option.selected = true
                    }
                }
            }

            var cardTypeSelect = document.querySelector('select#credit_card_type')
            if(cardTypeSelect){
                var cardTypeContainer = cardTypeSelect.parentElement.parentElement
                var cardTypeUL = cardTypeContainer.querySelector('.selectric-items ul')
                if(cardTypeUL){
                    for(var child of cardTypeUL.childNodes){
                        if(child.innerHTML == '\(cardType)') child.click()
                    }
                }else{
                    for(var option of cardTypeSelect.options){
                        if(option.text == '\(cardType)') option.selected = true
                    }
                }
            }
        
            var cardField = document.querySelector('input#credit_card_n')
            if(cardField) cardField.value = '\(cardNumber)'

            var expDateSelects = document.querySelectorAll('.credit-card-exp-fields-cell .selectric-items ul')
            if(expDateSelects.length > 0){
                var months = expDateSelects[0].childNodes
                var years = expDateSelects[1].childNodes
                for(var child of months){
                    if(child.innerHTML == '\(cardExpireMonth)') child.click()
                }
                for(var child of years){
                    if(child.innerHTML == '\(cardExpireYear)') child.click()
                }
            }else{
                var expMonthSelect = document.querySelector('select#credit_card_month')
                if(expMonthSelect) expMonthSelect.value = '\(cardExpireMonth)'

                var expYearSelect = document.querySelector('select#credit_card_year')
                if(expYearSelect) expYearSelect.value = '\(cardExpireYear)'
            }
            var cvvField = document.querySelector('input#cav') || document.querySelector('input#credit_card_cvv')
            if(cvvField) cvvField.value = '\(cardCVV)'
        
            var termsCheckbox = document.querySelector('input#order_terms')
            if(termsCheckbox) termsCheckbox.parentElement.click()
        """
        
        nextProduct()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss"
            let timeStr = dateFormatter.string(from: Date())
            self.navigationItem.title = timeStr
        }
    }
    
    @IBAction func onPressedGet(_ sender: Any) {
        print("current url", webView.url?.absoluteString ?? "")
        webView.evaluateJavaScript(getWebContentScript) { (result, error) in
            print(result as! String)
        }
    }
    
    @IBAction func onPressBack(_ sender: Any) {
        self.performSegueToReturnBack()
    }
    
    func selectSize(callback: @escaping (() -> ())) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            self.webView.evaluateJavaScript(self.selectSizeScript){ (result, error) in
                if let error = error {
                    print("selectSizeScript", error.localizedDescription)
                }else{
                    timer.invalidate()
                    callback()
                }
            }
        }
    }
    
    func addToCart(callback: @escaping ((Bool) -> ())) {
        var clicked = false
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            if(clicked){
                self.webView.evaluateJavaScript(self.checkSoldoutScript, completionHandler: { (result, error) in
                    let soldout = result as! Bool
                    if soldout {
                        callback(false)
                        timer.invalidate()
                    }
                })
                self.webView.evaluateJavaScript(self.checkInCartScript, completionHandler: { (result, error) in
                    let result  =  result as! Bool
                    if result {
                        callback(true)
                        timer.invalidate()
                    }
                })
            }else{
                self.webView.evaluateJavaScript(self.addToCartScript){ (result, error) in
                    if let error = error {
                        print("addToCartScript", error.localizedDescription)
                    }else{
                        clicked = true
                    }
                }
            }
        }
    }
    
    func checkout(callback: @escaping (() -> ())) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            self.webView.evaluateJavaScript(self.canCheckOutScript, completionHandler: { (result, error) in
                let result  =  result as! Bool
                if result {
                    self.webView.evaluateJavaScript(self.checkoutScript){ (result, error) in
                        if let error = error {
                            print("addToCartScript", error.localizedDescription)
                        }else{
                            timer.invalidate()
                            callback()
                        }
                    }
                }
            })
        }
    }
    
    func setBillingAndCard (callback: @escaping (() -> ())) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            self.webView.evaluateJavaScript(self.setBillingAndCardScript){ (result, error) in
                if let error = error {
                    print("setBillingAndCardScript", error.localizedDescription)
                }else{
                    timer.invalidate()
                    callback()
                }
            }
        }
    }
    
    func processPayment(callback: @escaping (() -> ())) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(AppData.checkoutDelay), repeats: false) { (timer) in
            self.webView.evaluateJavaScript(self.processPaymentScript){ (result, error) in
                if let error = error {
                    print("processPaymentScript", error.localizedDescription)
                }else{
                    print("success processPaymentScript")
                    callback()
                }
            }
        }
    }
    
    func webViewLoad(url: String, callback: @escaping (() -> ())) {
        webView.load(URLRequest(url: URL(string: url)!))
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            if !self.webView.isLoading {
                timer.invalidate()
                after(delay: 0.5) {
                    callback()
                }
            }
        }
    }
    
    func nextProduct() {
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let product = products[currentIndexOfProduct]
        let url = product["url"] as! String
        webViewLoad(url: url) {
            print("didFinish", self.webView.url?.absoluteString ?? "")
            self.hud.hide(animated: true)
            let product = self.products[self.currentIndexOfProduct]
            let sizeId = product["sizeId"] as! Int
            let size = product["size"] as! String
            self.selectSizeScript = String(format: self.selectSizeScriptFormat, sizeId, size)
            
            self.selectSize {
                self.addToCart { inCart in
                    if self.products.count - 1 > self.currentIndexOfProduct {
                        self.currentIndexOfProduct += 1
                        self.nextProduct()
                    }else{
                        self.checkout {
                            print("checkout successfully")
                            self.setBillingAndCard {
                                print("setBillingAndCard successfully")
                                self.processPayment {
                                    print("processPayment successfully")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hud.hide(animated: true)
        print("didFail")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("didReceiveServerRedirectForProvisionalNavigation")
    }
}
