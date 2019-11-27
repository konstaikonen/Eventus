//
//  addEventViewController.swift
//  CustomLogin
//
//  Created by formando on 27/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class addEventViewController: UIViewController {
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var eventDescriptionLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveButton(_ sender: Any) {
        let eventName = eventNameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let eventDescription = eventDescriptionLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let db = Firestore.firestore()
        db.collection("events").addDocument(data: ["name":eventName,"description":eventDescription])
        //Transition to home screen
        self.transitionToHome()
    }
    
     func transitionToHome(){

           let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.tabBarViewController) as? TabBarViewController
           
           view.window?.rootViewController = tabBarViewController
           view.window?.makeKeyAndVisible()
    
           
           
           //self.performSegue(withIdentifier: "loginToProfile", sender: self)
           
       }
}
