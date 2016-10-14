//
//  ErrorController.swift
//  CheckoutKitExample
//
//  Created by Manon Henrioux on 02/09/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import UIKit
import CheckoutKit

class ErrorController: UIViewController {
    
    @IBAction func backButton(_ sender: AnyObject) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(viewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

