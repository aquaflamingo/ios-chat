//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        
        let title = "FlashChat"
        var charIndex = 0.0
        
        for l in title {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(charIndex), repeats: false) { (t) in
                self.titleLabel.text?.append(l)
            }
            
            charIndex += 0.2
        }
    }
}
