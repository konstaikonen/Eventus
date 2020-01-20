//
//  ProfileViewController.swift
//  CustomLogin
//
//  Created by Konsta Miro Santeri Ikonen on 19/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    var trenutniKorisnik = [CurrentUser]()
    var userCollectionRef: CollectionReference!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var detailsStack: UIStackView!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "Log out", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            CurrentUser.shared.name = ""
            CurrentUser.shared.profileEmail = ""
            CurrentUser.shared.surname = ""
            CurrentUser.shared.profileUsername = ""
            self.performSegue(withIdentifier: "logOut", sender: self)
            
            
        }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
              }
        ))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollectionRef = Firestore.firestore().collection("users")
        
        //hide keyboard when click out
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        //background
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
        
        //modify profile picture
               self.photoImageView.layer.cornerRadius = 8
               self.photoImageView.clipsToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        self.emailLabel.text = CurrentUser.shared.profileEmail
        self.firstnameLabel.text = CurrentUser.shared.name
        self.usernameLabel.text = CurrentUser.shared.profileUsername
        self.lastnameLabel.text = CurrentUser.shared.surname
    }
}
