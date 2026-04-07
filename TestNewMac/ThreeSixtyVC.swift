//
//  ThreeSixtyVC.swift
//  TestNewMac
//
//  Created by Abhang on 25/02/26.
//

import UIKit
import WebKit

class ThreeSixtyVC: UIViewController {

    @IBOutlet weak var webViewLbl: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadWebView()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func loadWebView(){
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewLbl.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: webViewLbl.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewLbl.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: webViewLbl.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewLbl.trailingAnchor)
        ])
        
        let urlString = """
        https://sketchfab.com/models/da99d6e3e278429fb73f2d45ae678e9e/embed\
        ?autostart=1\
        &ui_infos=0\
        &ui_controls=0\
        &ui_stop=0\
        &ui_watermark=0\
        &ui_watermark_link=0\
        &ui_hint=0\
        &ui_help=0\
        &ui_settings=0\
        &ui_annotations=0\
        &ui_fullscreen=0
        """
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
