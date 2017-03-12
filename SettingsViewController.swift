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
    var customTip:Int = 0
    var nightAppMode:Bool = false
    var splitBillOn:Bool = false
    var noOfPersons:Int = 0
    
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var splitBill: UISwitch!
    @IBOutlet weak var customTipValue: UILabel!
    @IBOutlet weak var stepperValue: UILabel!
    @IBOutlet weak var stepperView: UIStepper!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    @IBOutlet weak var customTipStaticLabel: UILabel!
    @IBOutlet weak var modeStaticLabel: UILabel!
    @IBOutlet weak var splitStaticLabel: UILabel!
    @IBOutlet weak var numberStaticLabel: UILabel!
    
    override func viewDidLoad() {
        self.tipLabel.text = self.tip;
        self.view.backgroundColor = .white
        self.modeSwitch.setOn(false, animated: false)
        self.customTipValue.backgroundColor = .clear
        self.stepperValue.backgroundColor = .clear
        self.stepperView.backgroundColor = .clear
        self.customTipStaticLabel.backgroundColor = .clear
        self.modeStaticLabel.backgroundColor = .clear
        self.splitStaticLabel.backgroundColor = .clear
        self.numberStaticLabel.backgroundColor = .clear
        self.emailButton.backgroundColor = .clear
        self.textButton.backgroundColor = .clear
        self.textButton.setTitleColor(.black, for: .normal)
        self.emailButton.setTitleColor(.black, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       self.saveValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getPersistedAppValues()
        self.tipSlider.setValue(Float(customTip), animated: false)
        self.customTipValue.text = String(format: "%d%%", customTip)
        self.modeSwitch.setOn(nightAppMode, animated: false)
        self.stepperValue.text = String(format:"%d",noOfPersons)
        self.splitBill.setOn(splitBillOn, animated: false)
        self.invertMode()
    }
    
    @IBAction func sliderAdjusted(_ sender: Any) {
        customTip = Int(self.tipSlider.value)
        self.customTipValue.text = String(format:"%d%%",customTip)
        let defaults = UserDefaults.standard
        defaults.set(Int(self.customTipValue.text!), forKey: "customTip")
        defaults.synchronize()
    }
    
    
    @IBAction func modeSwitchTapped(_ sender: Any) {
        
        nightAppMode = self.modeSwitch.isOn
        self.invertMode()
    }
    
    
    
    
    @IBAction func splitBillTapped(_ sender: Any) {
        if self.splitBill.isOn {
            self.stepperView.isUserInteractionEnabled = true
        }else{
            self.stepperValue.text = "1"
            self.stepperView.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func stepperModified(_ sender: Any) {
        self.stepperValue.text = String(format:"%d",Int(self.stepperView.value))
    }

    @IBAction func textButtonTapped(_ sender: Any) {
    }
    @IBAction func emailButtonTapped(_ sender: Any) {
    }
    
    func invertMode(){
        
        if(nightAppMode){
            
            self.navigationController?.navigationBar.barTintColor = .black
            self.view.backgroundColor = .black
            self.tipSlider.backgroundColor = .black
            self.tipLabel.backgroundColor = .black
            self.tipLabel.textColor = .white
            self.textButton.backgroundColor = .black
            self.textButton.setTitleColor(.white, for: .normal)
            self.emailButton.backgroundColor = .black
            self.emailButton.setTitleColor(.white, for: .normal)
            self.customTipValue.textColor = .white
            self.stepperValue.textColor = .white
            self.customTipStaticLabel.textColor = .white
            self.modeStaticLabel.textColor = .white
            self.splitStaticLabel.textColor = .white
            self.numberStaticLabel.textColor = .white
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            
        }else{
            
            self.navigationController?.navigationBar.barTintColor = .white
            self.view.backgroundColor = .white
            self.tipSlider.backgroundColor = .white
            self.tipLabel.backgroundColor = .white
            self.tipLabel.textColor = .black
            self.textButton.backgroundColor = .white
            self.textButton.setTitleColor(.black, for: .normal)
            self.emailButton.backgroundColor = .white
            self.emailButton.setTitleColor(.black, for: .normal)
            self.customTipValue.textColor = .black
            self.stepperValue.textColor = .black
            self.customTipStaticLabel.textColor = .black
            self.modeStaticLabel.textColor = .black
            self.splitStaticLabel.textColor = .black
            self.numberStaticLabel.textColor = .black
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        }
    }
    
    func saveValues(){
        let defaults = UserDefaults.standard
        
        let tips = self.customTipValue.text?.substring(to: (self.customTipValue.text?.index((self.customTipValue.text?.endIndex)!, offsetBy: -1))!)
        defaults.set(Int(tips!), forKey: "customTip")
        defaults.set(self.modeSwitch.isOn, forKey: "nightAppMode")
        defaults.set(self.splitBill.isOn, forKey: "splitBill")
        defaults.set(Int(self.stepperValue.text!), forKey: "noOfPersons")
        defaults.synchronize()
    }
    func getPersistedAppValues(){
        
        let defaults = UserDefaults.standard
        customTip = defaults.integer(forKey: "customTip")
        noOfPersons = defaults.integer(forKey: "noOfPersons")
        nightAppMode = defaults.bool(forKey: "nightAppMode")
        splitBillOn = defaults.bool(forKey: "splitBill")
    }
}
