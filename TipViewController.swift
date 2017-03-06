//
//  TipViewController.swift
//  iTipper
//
//  Created by Akila Sekaran on 3/3/17.
//  Copyright © 2017 Akila Sekaran. All rights reserved.
//

import Foundation
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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bottowView: UIView!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var equalsLabel: UILabel!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var tipTotalLabel: UILabel!
 
    private var formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer (target: self, action:#selector(self.tapBlurButton(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view .addGestureRecognizer(tapGestureRecognizer)
        self.amountTextField.backgroundColor = .clear
        self.amountTextField.borderStyle = .none
        self.amountTextField.textColor = .black
        self.segmentControl.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.segmentControl.isHidden = false
        self.segmentControl.alpha = 0
        
        self.bottowView.isHidden = false
        self.plusLabel.alpha = 0
        self.equalsLabel.alpha = 0
        self.tipPercentageLabel.alpha = 0
        self.tipTotalLabel.alpha = 0
        
        UIView .animate(withDuration: 1.25, animations:{
            self.topView.frame = CGRect(x: 0, y: -100, width: self.topView.frame.size.width, height: self.topView.frame.size.height)
            self.bottowView.frame = CGRect(x: 0, y: 235, width: self.bottowView.frame.size.width, height: self.bottowView.frame.size.height)
            self.segmentControl.alpha = 1
            self.plusLabel.alpha = 1
            self.equalsLabel.alpha = 1
            self.tipPercentageLabel.alpha = 1
            self.tipTotalLabel.alpha = 1
        })
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.amountTextField .resignFirstResponder()
        UIView .animate(withDuration: 1.25, animations:{
            self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.size.width, height: self.topView.frame.size.height)
            self.bottowView.frame = CGRect(x: 0, y: 335, width: self.bottowView.frame.size.width, height: self.bottowView.frame.size.height)
            self.segmentControl.alpha = 0;
            self.segmentControl.isHidden = true
        })
        self.calculateTips()
    }
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        self.tipPercentageLabel.text = self.segmentControl.titleForSegment(at: self.segmentControl.selectedSegmentIndex)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Construct the text that will be in the field if this change is accepted
        let oldText = textField.text! as String
        var newText = (oldText as NSString).replacingCharacters(in: range, with: string)
        var newTextString = String(newText)
        
        let digits = NSCharacterSet.decimalDigits
        var digitText = ""
        for c in (newTextString?.unicodeScalars)! {
            if digits.contains(c) {
                digitText.append(String(c))
            }
        }
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale.current
        let numberFromField = (NSString(string: digitText).doubleValue)/100
        newText = formatter.string(from: NSNumber(value:numberFromField))!
        
        textField.text = newText
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.calculateTips()
        return true
    }
    
    
    func calculateTips(){
        var amountText = self.amountTextField.text!
        let tipsText = self.tipPercentageLabel.text!
        
        amountText = amountText.replacingOccurrences(of: ",", with: "")
        
        let amount = amountText.substring(from: amountText.index(amountText.startIndex, offsetBy: 1))
        let tips = tipsText.substring(to: tipsText.index(tipsText.endIndex, offsetBy: -1))
        let total = Double(amount)!+(Double(tips)!/100)*Double(amount)!
        self.tipTotalLabel.text = formatter.string(from: NSNumber(value:total))
    }
}














