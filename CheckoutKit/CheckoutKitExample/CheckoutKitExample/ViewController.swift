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
    @IBAction func dateFieldTouch(sender: AnyObject) {
        datePicker.hidden = false
        doneButton.hidden = false
        cardTokenButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        datePicker.hidden = true
        doneButton.hidden = true
        cardTokenButton.hidden = false
        
    }

    @IBAction func finishEdit(sender: AnyObject) {
        datePicker.hidden = true
        doneButton.hidden = true
        cardTokenButton.hidden = false
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        datePicker.hidden = true
        doneButton.hidden = true
        cardTokenButton.hidden = false
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return pickerContent.count
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return pickerContent[component].count
    }
    
    func pickerView(bigPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        
        return pickerContent[component][row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if component == 0 { month = pickerContent[0][row] }
        else { year = pickerContent[1][row] }
        updateDate()
    }
    
    private func updateDate() {
        dateField.text = "\(month) / \(year)"
    }
    
    func textFieldShouldBeginEditing( textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        // Disable copy, select all, paste
        if action == Selector("copy:") || action == Selector("selectAll:") || action == Selector("paste:") {
            return false
        }
        // Default
        return super.canPerformAction(action, withSender: sender)
    }
    
    
    private func validateCardInfo(number: String, expYear: String, expMonth: String, cvv: String) -> Bool {
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
    
    private func resetFieldsColor() {
            numberField.backgroundColor = UIColor.whiteColor()
            dateField.backgroundColor = UIColor.whiteColor()
            cvvField.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func getCardToken(sender: AnyObject) {
        
        var error: NSError?
        var ck = CheckoutKit.getInstance("pk_test_6ff46046-30af-41d9-bf58-929022d2cd14", error: &error)
        if ck == nil {
            let errorController = self.storyboard?.instantiateViewControllerWithIdentifier("ErrorController") as! ErrorController
            self.presentViewController(errorController, animated: true, completion: nil)
        } else {
            if (validateCardInfo(numberField.text, expYear: year, expMonth: month, cvv: cvvField.text)) {
                resetFieldsColor()
            var err: NSError?
            var card = Card(name: nameField.text, number: numberField.text, expYear: year, expMonth: month, cvv: cvvField.text, billingDetails: nil, error: &err)
            if card == nil {
                if (err!.domain == CardError.InvalidCVV.rawValue) {
                    cvvField.backgroundColor = errorColor
                } else if (err!.domain == CardError.InvalidExpiryDate.rawValue) {
                    dateField.backgroundColor = errorColor
                } else if (err!.domain == CardError.InvalidNumber.rawValue) {
                    numberField.backgroundColor = errorColor
                }
            } else {
            ck!.createCardToken(card!, completion:{ (resp: Response<CardTokenResponse>) -> Void in
            if (resp.hasError) {
                let errorController = self.storyboard?.instantiateViewControllerWithIdentifier("ErrorController") as! ErrorController
                self.presentViewController(errorController, animated: true, completion: nil)
            } else {
                let successController = self.storyboard?.instantiateViewControllerWithIdentifier("SuccessController") as! SuccessController
                self.presentViewController(successController, animated: true, completion: nil)
            }
        })
            }
        }
    }
    }
    
//    private func errorMessage(error: String) {
//        let alert = UIAlertView()
//        alert.title = "Error"
//        alert.message = error
//        alert.addButtonWithTitle("Try again")
//        alert.show()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateField.delegate = self
        pickerContent.append([])
        for (var m = 0 ; m < months.count ; m++) {
            pickerContent[0].append(months[m].description)
        }
        pickerContent.append([])
        for (var y = 0 ; y < years.count ; y++) {
            pickerContent[1].append(years[y].description)
        }
        datePicker.delegate = self
        datePicker.hidden = true
        doneButton.hidden = true
        cardTokenButton.hidden = false
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

