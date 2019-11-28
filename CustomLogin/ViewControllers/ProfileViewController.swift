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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    self.backgroundStack.layer.cornerRadius = self.detailsStack.frame.width/50.0
        self.backgroundStack.clipsToBounds = true
        self.backgroundStack.layer.shadowColor = UIColor.gray.cgColor
        self.backgroundStack.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.backgroundStack.layer.shadowOpacity = 1
        self.backgroundStack.layer.shadowRadius = 5
        self.backgroundStack.clipsToBounds = false
        
        
        //modify profile picture
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.width/2.0
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
