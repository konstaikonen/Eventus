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
    @IBOutlet weak var stackBack: UIImageView!
    
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Log out", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
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
        
        //logo to nav bar
        _ = self.navigationController?.navigationBar
               let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
               logo.contentMode = .scaleAspectFit
               let image = UIImage(named: "applicationImage")
               logo.image = image
               navigationItem.titleView = logo
        
        //background
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
        
        //modify profile picture
               self.photoImageView.layer.cornerRadius = 8
               self.photoImageView.clipsToBounds = true
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        let email: String = AppData.shared.profileEmail!
        userCollectionRef.getDocuments { (snapshot, error) in
            if let error = error{
                debugPrint("Eror se vraca")
            }else{
                guard let snap = snapshot else { return }
                for document in snap.documents{
                    
                    let data = document.data()
                    let firstName = data["firstname"] as? String ?? "Anonymous"
                    let lastname = data["lastname"] as? String ?? "Anonymous"
                    let username = data["username"] as? String ?? "Anonymous"
                    let emailBaza = data["email"] as? String ?? "Anonymous"
                    if email == emailBaza {
                        let korisnik = CurrentUser(firstName: firstName, lastName: lastname,username: username, email: email)
                        self.trenutniKorisnik.append(korisnik)
                    }
                }
                self.emailLabel.text = self.trenutniKorisnik[0].email
                self.firstnameLabel.text = self.trenutniKorisnik[0].firstName
                self.usernameLabel.text = self.trenutniKorisnik[0].username
                self.lastnameLabel.text = self.trenutniKorisnik[0].lastName
            }
        }
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
