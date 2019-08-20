//
//  SupremeSiteVC.swift
//  Copbot
//
//  Created by Admin on 5/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class SupremeSiteVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var hud: MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = "https://www.supremenewyork.com/mobile"
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url)!))
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss"
            let timeStr = dateFormatter.string(from: Date())
            self.navigationItem.title = timeStr
        }.fire()
    }

    @IBAction func onRefresh(_ sender: Any) {
        webView.reload()
    }
}

extension SupremeSiteVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        hud.hide(animated: true)
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
