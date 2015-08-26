//
//  ViewController.swift
//  test2
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import UIKit
import CheckoutKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cardTokenLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var monthField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func getCardToken(sender: AnyObject) {
        
        
//        var ck = CheckoutKit(pk: "pk_test_6ff46046-30af-41d9-bf58-929022d2cd14")  pk_1ADBEB2D-2BEA-4F82-8ABC-EDE3A1201C8D
        var error: NSError?
        var ck = CheckoutKit.getInstance("pk_test_6ff46046-30af-41d9-bf58-929022d2cd14", error: &error)
        if ck == nil {
            self.errorLabel.text = error?.domain
        } else {
        var card = Card(name: nameField.text, number: numberField.text, expYear: yearField.text, expMonth: monthField.text, cvv: cvvField.text, billingDetails: nil, error: &error)
        if card == nil {
            self.errorLabel.text = error?.domain
        } else {
        ck!.createCardToken(card!, completion:{ (resp: Response<CardTokenResponse>) -> Void in
            if (resp.hasError) {
                self.errorLabel.text = "ERROR \(resp.httpStatus) : \(resp.error?.message)"
                self.cardTokenLabel.text = " "
            } else {
                self.cardTokenLabel.text = resp.model!.cardToken
                self.errorLabel.text = " "
            }
        })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        var error: NSError?
//        var ck = CheckoutKit.getInstance("pk_test_6ff46046-30af-41d9-bf58-929022d2cd14", error: &error)
//        ck!.getCardProviders({(resp: Response<CardProviderResponse>) -> Void in
//
//            if !resp.hasError {
//                for i in resp.model!.data {
//                    println(i.name)
//                }
//            }
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

