//
//  ViewController.swift
//  iTip
//
//  Created by Akila Sekaran on 3/1/17.
//  Copyright © 2017 Akila Sekaran. All rights reserved.
//

import UIKit

class TipViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer (target: self, action:#selector(self.tapBlurButton(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view .addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        UIView .animateWithDuration(0.25, animations:{
            self.topView.frame = CGRectMake(0, -100, self.topView.frame.size.width, self.topView.frame.size.height)
            })
    }
    
    func tapBlurButton(sender: UITapGestureRecognizer) {
        self.amountTextField .resignFirstResponder()
        UIView .animateWithDuration(0.25, animations:{
            self.topView.frame = CGRectMake(0, 0, self.topView.frame.size.width, self.topView.frame.size.height)
        })
    }

}

