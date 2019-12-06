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

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Properties
    
    var trenutniKorisnik = [CurrentUser]()
    var userCollectionRef: CollectionReference!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameEdit: UITextField!
    @IBOutlet weak var firstnameEdit: UITextField!
    @IBOutlet weak var lastnameEdit: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure you want to save changes?", message: "Save or cancel", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
              }
        ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //modify profile picture
        self.photoImageView.layer.cornerRadius = self.photoImageView.frame.width/100.0
        self.photoImageView.clipsToBounds = true
    }
    
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

    //change user photo
    
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
}
