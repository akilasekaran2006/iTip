//
//  SettingsViewControlller.swift
//  iTipper
//
//  Created by Akila Sekaran on 3/6/17.
//  Copyright © 2017 Akila Sekaran. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    var tip:String?
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipLabel: UILabel!
    
    override func viewDidLoad() {
        self.tipLabel.text = self.tip;
    }
    
}
