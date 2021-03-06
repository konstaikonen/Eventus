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
import FirebaseStorage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Properties
    
    var trenutniKorisnik = [CurrentUser]()
    var userCollectionRef: CollectionReference!
    let db = Firestore.firestore()
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameEdit: UITextField!
    @IBOutlet weak var firstnameEdit: UITextField!
    @IBOutlet weak var lastnameEdit: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var clickToChange: UIButton!
    
    
    @IBAction func closeEdit(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Are you sure you want to save changes?", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            self.db.collection("users").whereField("uid",isEqualTo: CurrentUser.shared.uid).getDocuments(){ (snapshot, error) in
            if let error = error{
                debugPrint("Eror se vraca")
            }else{
                let document = snapshot!.documents.first?.reference.updateData(["firstname": self.firstnameEdit.text])
                let document1 = snapshot!.documents.first?.reference.updateData(["lastname": self.lastnameEdit.text])
                let document2 = snapshot!.documents.first?.reference.updateData(["username": self.usernameEdit.text])
                let document3 = snapshot!.documents.first?.reference.updateData(["email": self.emailEdit.text])
                }
            }
            CurrentUser.shared.name = self.firstnameEdit.text
            CurrentUser.shared.surname = self.lastnameEdit.text
            CurrentUser.shared.profileEmail = self.emailEdit.text
            CurrentUser.shared.profileUsername = self.usernameEdit.text
            self.transitionToHome()
        }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
              }
        ))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide keyboard when click outside
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
        
        //hide scrollview background
        scrollView.backgroundColor = .clear
        self.emailEdit.text = CurrentUser.shared.profileEmail
        self.firstnameEdit.text = CurrentUser.shared.name
        self.lastnameEdit.text = CurrentUser.shared.surname
        self.usernameEdit.text = CurrentUser.shared.profileUsername
        //modify background
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
        
        //modify profile picture
        self.photoImageView.clipsToBounds = true
        self.photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2
    }
    
     override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
         //hide when landscape
         if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
            self.photoImageView.layer.cornerRadius = 40

         } else {
            self.photoImageView.layer.cornerRadius = 100
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

    //change user photo
    
    //MARK: Actions
    //open gallery from text
    @IBAction func selectImageFromLibrary(_ sender: Any) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    //open gallery from photo
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
    func transitionToHome(){

           let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.tabBarViewController) as? TabBarViewController
           
           view.window?.rootViewController = tabBarViewController
           view.window?.makeKeyAndVisible()
    
           
           
           //self.performSegue(withIdentifier: "loginToProfile", sender: self)
           
       }
}
