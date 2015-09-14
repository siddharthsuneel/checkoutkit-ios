//
//  ViewController.swift
//  testPod
//
//  Created by Manon Henrioux on 14/09/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import UIKit
import CheckoutKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println(CardValidator.validateCardNumber("094857684765837485"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

