//
//  EditProfileViewController.swift
//  CustomLogin
//
//  Created by formando on 04/12/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class EditProfileViewController: UIViewController {

    
    var trenutniKorisnik = [CurrentUser]()
    var userCollectionRef: CollectionReference!
    
    @IBOutlet weak var usernameEdit: UITextField!
    @IBOutlet weak var firstnameEdit: UITextField!
    @IBOutlet weak var lastnameEdit: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailEdit.text = AppData.shared.profileEmail
        self.firstnameEdit.text = AppData.shared.name
        self.lastnameEdit.text = AppData.shared.surname
        self.usernameEdit.text = "username"
        
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
