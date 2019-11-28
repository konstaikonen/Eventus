//
//  SignUpViewController.swift
//  CustomLogin
//
//  Created by formando on 07/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameLabel: UITextField!
    
    var pomocniEmail:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String?{
        
        //Check that al fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""||passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || usernameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""{
            
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) != false{
            return "Please make sure zour password is at least 8 characters , contains a special character and a number"
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }else{
            
            //creat cleaned version of the data
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = usernameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if  err != nil{
                    self.showError("Error creating user")
                }else{
                    self.pomocniEmail = email
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname":firstName,"email":email,"username":username,"lastname":lastName,"uid":result!.user.uid]) { (error) in
                        
                        if error != nil{
                            self.showError("Error saving user data")
                        }
                    }
                    //Transition to home screen
                    self.transitionToHome()
                }
            }
        
        }
        
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){

        let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.tabBarViewController) as? TabBarViewController
        
       
        
        AppData.shared.profileEmail = pomocniEmail
        view.window?.rootViewController = tabBarViewController
        view.window?.makeKeyAndVisible()
 
        
        
        //self.performSegue(withIdentifier: "loginToProfile", sender: self)
        
    }
    
}
