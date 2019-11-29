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
    @IBOutlet weak var backgroundStack: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //modify stack view
        /* self.backgroundStack.layer.cornerRadius = self.detailsStack.frame.width/50.0
        self.backgroundStack.clipsToBounds = true
       */ self.backgroundStack.layer.shadowColor = UIColor.gray.cgColor
        self.backgroundStack.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.backgroundStack.layer.shadowOpacity = 1
        self.backgroundStack.layer.shadowRadius = 1
        self.backgroundStack.clipsToBounds = false
        
        
        //modify profile picture
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.width/40.0
        self.photoImageView.clipsToBounds = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        userCollectionRef = Firestore.firestore().collection("users")
   

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
    
    
    //MARK: Actions

    
    // edit profile informations
    @IBAction func usernameEdit(_ sender: UITapGestureRecognizer) {
        
        let userEdit = UITextField(frame: CGRect(x: 20.0, y: 30.0, width: 100.0, height: 33.0))
        userEdit.backgroundColor = UIColor.red
        userEdit.borderStyle = UITextField.BorderStyle.line
        self.view.addSubview(userEdit)
    
    }
    
    @IBAction func firstnameEdit(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func lastnameEdit(_ sender: UITapGestureRecognizer) {
    }
    
    @IBAction func emailEdit(_ sender: UITapGestureRecognizer) {
    }
    
    //change user photo
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
      
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
    
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- ---> UITextFieldDelegate
    
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            // return NO to disallow editing.
            print("TextField should begin editing method called")
            return true
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            // became first responder
            print("TextField did begin editing method called")
        }

        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
            print("TextField should snd editing method called")
            return true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
            print("TextField did end editing method called")
        }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            // if implemented, called in place of textFieldDidEndEditing:
            print("TextField did end editing with reason method called")
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // return NO to not change text
            print("While entering the characters this method gets called")
            return true
        }

        func textFieldShouldClear(_ textField: UITextField) -> Bool {
            // called when clear button pressed. return NO to ignore (no notifications)
            print("TextField should clear method called")
            return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // called when 'return' key pressed. return NO to ignore.
            print("TextField should return method called")
            // may be useful: textField.resignFirstResponder()
            return true
        }

    

    // MARK: UITextFieldDelegate <---
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
