//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 21/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    
    var tag = TagModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var backgroundImageName:String = ""
        switch kAppDelegate.appCode {
        case "art":
            backgroundImageName = "art_launch_image"
        case "wine":
            backgroundImageName = "wine_launch_image"
        case "show":
            backgroundImageName = "show_launch_image"
        case .none:
            backgroundImageName = "show_launch_image"
        case .some(_):
            backgroundImageName = "show_launch_image"
        }
        
        backgroundImageView.image = UIImage(named: backgroundImageName)
        
        // Applying the blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        // Make the button invisible and move off the screen
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
        
        // Move up the closee button
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: -400)
        closeButton.transform = moveUpTransform
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        for index in 0...4 {
            UIView.animate(withDuration: 0.4, delay: (0.1 + 0.05 * Double(index)), options: [], animations: {
                self.rateButtons[index].alpha = 1.0
                self.rateButtons[index].transform = .identity
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 0.4) {
            self.closeButton.transform = .identity
        }
        
        
    }

}
