//
//  ViewController.swift
//  CustomLogin
//
//  Created by formando on 07/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        /* hide the navigation bar
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
         */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /* Hide the navigation bar
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements(){}

}

