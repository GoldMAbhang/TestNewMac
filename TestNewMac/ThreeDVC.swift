//
//  ThreeDVC.swift
//  TestNewMac
//
//  Created by Abhang on 24/02/26.
//

import UIKit

class ThreeDVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func threeDViewBtnPressed(_ sender: UIButton) {
        let sb = UIStoryboard(name: "ThreeDPopUp", bundle: nil)
        let popup = sb.instantiateInitialViewController() as? ThreeDPopUpController
        popup?.modalPresentationStyle = .overFullScreen
        self.present(popup!, animated: true)
    }
    
    @IBAction func threeSixtyWebViewPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainStoryBoard = storyBoard.instantiateViewController(withIdentifier: "ThreeSixtyVC") as! ThreeSixtyVC
        self.navigationController!.pushViewController(mainStoryBoard, animated: true)
    }
}
