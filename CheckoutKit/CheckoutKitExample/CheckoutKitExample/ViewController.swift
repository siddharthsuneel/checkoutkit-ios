//
//  ViewController.swift
//  test2
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import UIKit
import CheckoutKit
import QuartzCore

class ViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate {
    
    var pickerContent: [[String]] = []
    let months = [1,2,3,4,5,6,7,8,9,10,11,12]
    let years = [2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025]
    var month = "1"
    var year = "2015"
    let errorColor = UIColor(red: 204.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 0.3)
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var cardTokenButton: UIButton!
    @IBAction func dateFieldTouch(_ sender: AnyObject) {
        datePicker.isHidden = false
        doneButton.isHidden = false
        cardTokenButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
        
    }

    @IBAction func finishEdit(_ sender: AnyObject) {
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView!) -> Int{
        return pickerContent.count
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return pickerContent[component].count
    }
    
    func pickerView(_ bigPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return pickerContent[component][row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if component == 0 { month = pickerContent[0][row] }
        else { year = pickerContent[1][row] }
        updateDate()
    }
    
    fileprivate func updateDate() {
        dateField.text = "\(month) / \(year)"
    }
    
    func textFieldShouldBeginEditing( _ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
//    override func canPerformAction(_ action: Selector, withSender sender: AnyObject?) -> Bool {
//        // Disable copy, select all, paste
//        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
//            return false
//        }
//        // Default
//        return super.canPerformAction(action, withSender: sender)
//    }
    
    
    fileprivate func validateCardInfo(_ number: String, expYear: String, expMonth: String, cvv: String) -> Bool {
        var err: Bool = false
        resetFieldsColor()
        if (!CardValidator.validateCardNumber(number)) {
            err = true
            numberField.backgroundColor = errorColor
        }
        if (!CardValidator.validateExpiryDate(month, year: year)) {
            err = true
            dateField.backgroundColor = errorColor
        }
        if (cvv == "") {
            err = true
            cvvField.backgroundColor = errorColor
        }
        return !err
    }
    
    fileprivate func resetFieldsColor() {
            numberField.backgroundColor = UIColor.white
            dateField.backgroundColor = UIColor.white
            cvvField.backgroundColor = UIColor.white
    }
    
    @IBAction func getCardToken(_ sender: AnyObject) {
        
        var ck: CheckoutKit? = nil
        do {
        try ck = CheckoutKit.getInstance("pk_test_6ff46046-30af-41d9-bf58-929022d2cd14")
        } catch _ as NSError {
            let errorController = self.storyboard?.instantiateViewController(withIdentifier: "ErrorController") as! ErrorController
            self.present(errorController, animated: true, completion: nil)
        }
        if ck != nil {
            if (validateCardInfo(numberField.text!, expYear: year, expMonth: month, cvv: cvvField.text!)) {
                resetFieldsColor()
                var card: Card? = nil
                do {
            try card = Card(name: nameField.text!, number: numberField.text!, expYear: year, expMonth: month, cvv: cvvField.text!, billingDetails: nil)
                } catch let err as CardError {
                    switch(err) {
                    case CardError.invalidCVV: cvvField.backgroundColor = errorColor
                    case CardError.invalidExpiryDate: dateField.backgroundColor = errorColor
                    case CardError.invalidNumber: numberField.backgroundColor = errorColor
                    }
                } catch _ as NSError {
                    
            }
            if card != nil {
            ck!.createCardToken(card!, completion:{ (resp: Response<CardTokenResponse>) -> Void in
            if (resp.hasError) {
                let errorController = self.storyboard?.instantiateViewController(withIdentifier: "ErrorController") as! ErrorController
                DispatchQueue.main.async(execute: {
                    self.present(errorController, animated: true, completion: nil)
                });
            } else {
                let successController = self.storyboard?.instantiateViewController(withIdentifier: "SuccessController") as! SuccessController
                DispatchQueue.main.async(execute: {
                    self.present(successController, animated: true, completion: nil)
                    });
            }
        })
            }
        }
    }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateField.delegate = self
        pickerContent.append([])
        for m in 0  ..< months.count  {
            pickerContent[0].append(months[m].description)
        }
        pickerContent.append([])
        for y in 0 ..< years.count {
            pickerContent[1].append(years[y].description)
        }
        datePicker.delegate = self
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

