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
        
        userCollectionRef = Firestore.firestore().collection("users")
        
    
    }
    
    func viewDidAppear() {
        
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
                    self.emailEdit.text = self.trenutniKorisnik[0].email
                    self.firstnameEdit.text = self.trenutniKorisnik[0].firstName
                    self.usernameEdit.text = self.trenutniKorisnik[0].username
                    self.lastnameEdit.text = self.trenutniKorisnik[0].lastName
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
