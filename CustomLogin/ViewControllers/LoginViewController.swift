//
//  LoginViewController.swift
//  CustomLogin
//
//  Created by formando on 07/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    var jesiLoginan = false
     var userCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginTapped(_ sender: Any) {
        
        //Validate text fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.errorLabel.text = "Wrong Info"
            }else{
                
                self.userCollectionRef = Firestore.firestore().collection("users")
                self.userCollectionRef.getDocuments { (snapshot, error) in
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
                                       AppData.shared.profileEmail = email
                                    AppData.shared.name = firstName
                                    AppData.shared.surname =  lastname
                                    self.jesiLoginan = true
                                    
                            }
                        }
                            
                    }
                }
                
            }
        
            if self.jesiLoginan == true{
                let tabBarViewController = self.storyboard?.instantiateViewController(identifier: Constants.StoryBoard.tabBarViewController) as? TabBarViewController
                
                AppData.shared.profileEmail = email
                
                self.view.window?.rootViewController = tabBarViewController
                self.view.window?.makeKeyAndVisible()
            }else{
                self.errorLabel.text = "Wrong Info"
            }
                
                
                
                //self.performSegue(withIdentifier: "loginToProfile", sender: self)
                
            }
        }
        
}
    


