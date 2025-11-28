//
//  ViewController.swift
//  TestNewMac
//
//  Created by Abhang Mane @Goldmedal on 20/06/24.
//  CHANGE A

import UIKit
import MTSlideToOpen
import MGSwipeTableCell

class ViewController: UIViewController, MTSlideToOpenDelegate,UITableViewDelegate, MGSwipeTableCellDelegate {
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpen.MTSlideToOpenView) {
        completeOrder()
    }
    
   
    @IBOutlet var mainView: UIView!
    var usesTallCells = false
    
    public let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()


    @IBOutlet weak var sliderVw: MTSlideToOpenView!
    @IBOutlet weak var testTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "\(UIDevice.current.name)"
        sliderSetup()
    }

    func sliderSetup(){
        testTableView.register(UINib(nibName: "TestTableCell", bundle: nil), forCellReuseIdentifier: "TestTableCell")
        sliderVw.delegate = self
        sliderVw.sliderBackgroundColor = .white
        sliderVw.slidingColor  = UIColor(named: "ColorRed")!
        sliderVw.textLabel.text = "Swipe to Place Order"
        sliderVw.textColor = UIColor(named: "ColorRed")!
        sliderVw.thumnailImageView.image = UIImage(named: "SlideStart")
        sliderVw.thumnailImageView.contentMode = .scaleToFill
        sliderVw.sliderCornerRadius = 20
        sliderVw.showSliderText = true
        sliderVw.sliderHolderView.layer.shadowColor = CGColor(red: 186, green: 186, blue: 186, alpha: 1)
        sliderVw.sliderHolderView.layer.shadowRadius = 1
        sliderVw.sliderHolderView.layer.shadowOpacity = 1
    }

    func completeOrder(){
        sliderVw.thumnailImageView.addSubview(activityIndicator)
        sliderVw.thumnailImageView.image = UIImage(named: "eclipse_empty")
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: sliderVw.thumnailImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sliderVw.thumnailImageView.centerYAnchor)
            ])
        activityIndicator.startAnimating()
        sliderVw.labelText = "Placing Order..."
        mainView.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            activityIndicator.stopAnimating()
            sliderVw.labelText = "Order Placed"
            sliderVw.thumnailImageView.image = UIImage(named: "SlideEnd")
            mainView.isUserInteractionEnabled = true
        }
    }
    @IBAction func resetSliderPressed(_ sender: UIButton) {
        sender.setTitle("Reset Slider", for: .normal)
        sender.translatesAutoresizingMaskIntoConstraints = false
        sender.addTarget(self, action: #selector(resetSlider), for: .touchUpInside)
         
    }
    
    @objc func resetSlider() {
        sliderVw.resetStateWithAnimation(true)
        sliderVw.labelText = "Swipe to Place Order"
        sliderVw.thumnailImageView.image = UIImage(named: "SlideStart")
    }

}


extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reuseIdentifier = "TestTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MGSwipeTableCell
        
        cell.delegate = self

        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor(named: "ColorRed")!),
                             MGSwipeButton(title: "Edit",backgroundColor: UIColor(named: "ColorBlue")!)]
        cell.rightSwipeSettings.transition = .drag
        cell.rightSwipeSettings.topMargin = 10
        cell.rightSwipeSettings.bottomMargin = 10

        return cell
    }
    
    
}
