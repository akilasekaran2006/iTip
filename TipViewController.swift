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
    
    var customTip:Int = 0
    var nightAppMode:Bool = false
    var splitBill:Bool = false
    var noOfPersons:Int = 0
    
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
        
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale.current
        
        let tapGestureRecognizer = UITapGestureRecognizer (target: self, action:#selector(self.tapBlurButton(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.view .addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getPersistedAppValues()
        if customTip == 0 && !nightAppMode && !splitBill && noOfPersons == 0 {
            self.customizeInitialView()
        }
        self.setNightAppMode(isNightModeOn: nightAppMode)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.bottowView.isHidden = false
        self.plusLabel.alpha = 0
        self.equalsLabel.alpha = 0
        self.tipPercentageLabel.alpha = 0
        self.tipTotalLabel.alpha = 0
        
        UIView .animate(withDuration: 0.25, animations: {
            
            self.topView.frame = CGRect(x: 0, y: -100, width: self.topView.frame.size.width, height: self.topView.frame.size.height)
            self.bottowView.frame = CGRect(x: 0, y: 235, width: self.bottowView.frame.size.width, height: self.bottowView.frame.size.height)
            
            self.plusLabel.alpha = 1
            self.equalsLabel.alpha = 1
            self.tipPercentageLabel.alpha = 1
            self.tipTotalLabel.alpha = 1
        })
        self.calculateTips()
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        self.amountTextField .resignFirstResponder()
        UIView .animate(withDuration: 0.25, animations:{
            self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.size.width, height: self.topView.frame.size.height)
            self.bottowView.frame = CGRect(x: 0, y: 335, width: self.bottowView.frame.size.width, height: self.bottowView.frame.size.height)
        })
        self.calculateTips()
    }
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        
        let percentage = self.segmentControl.titleForSegment(at: self.segmentControl.selectedSegmentIndex)
        self.tipPercentageLabel.text = percentage
        self.calculateTips()
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
        if amountText.isEmpty{
            amountText = "$0.0";
        }
        
        amountText = amountText.replacingOccurrences(of: ",", with: "")
        
        let amount = amountText.substring(from: amountText.index(amountText.startIndex, offsetBy: 1))
        let tips = tipsText.substring(to: tipsText.index(tipsText.endIndex, offsetBy: -1))
        let total = Double(amount)!+(Double(tips)!/100)*Double(amount)!
        self.tipTotalLabel.text = formatter.string(from: NSNumber(value:total))
        
        let defaults = UserDefaults.standard
        defaults.set(Int(tips), forKey: "customTip")
        defaults.synchronize()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "settingsSegue") {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.tip = self.tipPercentageLabel.text!
        }
    }
    
    func persistAppValues() {
    
        let defaults = UserDefaults.standard
        defaults.set(Int(self.amountTextField.text!), forKey: "tipAmount")
        defaults.set(Int(self.tipPercentageLabel.text!), forKey: "customTip")
        defaults.synchronize()
    }
    
    func getPersistedAppValues(){
        
        let defaults = UserDefaults.standard
        customTip = defaults.integer(forKey: "customTip")
        noOfPersons = defaults.integer(forKey: "noOfPersons")
        nightAppMode = defaults.bool(forKey: "nightAppMode")
        splitBill = defaults.bool(forKey: "splitBill")
    }
    
    func customizeInitialView() {
        
        self.amountTextField.borderStyle = .none
        self.amountTextField.textColor = .black
        self.view.backgroundColor = .white
        self.amountTextField.placeholder = formatter.string(from:NSNumber(value: 0.0))
        self.tipTotalLabel.text = formatter.string(from:NSNumber(value: 0.0))
    }
    
    func setNightAppMode(isNightModeOn:Bool) {
        if isNightModeOn {
            
            self.navigationController?.navigationBar.barTintColor = .black
            self.view.backgroundColor = .black
            self.topView.backgroundColor = .black
            self.bottowView.backgroundColor = .black
            self.amountTextField.textColor = .white
            self.tipPercentageLabel.textColor = .white
            self.tipTotalLabel.textColor = .white
            self.plusLabel.textColor = .white
            self.equalsLabel.textColor = .white
            
            if (self.amountTextField.text?.characters.count==0){
                self.amountTextField.attributedPlaceholder = NSAttributedString(string: formatter.string(from:NSNumber(value: 0.0))!,attributes: [NSForegroundColorAttributeName: UIColor.white])
                self.tipTotalLabel.text = formatter.string(from:NSNumber(value: 0.0))
            }
            
            
        }else{
            self.navigationController?.navigationBar.barTintColor = .white
            self.view.backgroundColor = .white
            self.topView.backgroundColor = .white
            self.bottowView.backgroundColor = .white
            self.amountTextField.textColor = .black
            self.tipPercentageLabel.textColor = .black
            self.tipTotalLabel.textColor = .black
            self.plusLabel.textColor = .black
            self.equalsLabel.textColor = .black
            if (self.amountTextField.text?.characters.count==0){
                self.amountTextField.attributedPlaceholder = NSAttributedString(string: formatter.string(from:NSNumber(value: 0.0))!,attributes: [NSForegroundColorAttributeName: UIColor.black])
                self.tipTotalLabel.text = formatter.string(from:NSNumber(value: 0.0))
            }
        }
    }
}














