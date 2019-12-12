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
    
    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var startDateAndTime: UITextField!

    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.minuteInterval = 15
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        return picker
    }()
    lazy var dateFormatter: DateFormatter = {
              let formatter = DateFormatter()
               formatter.dateFormat = "MM-dd-yyyy' 'HH:mm"
              return formatter
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostnameLabel.text = AppData.shared.name
        startDateAndTime.inputView = datePicker
        eventNameLabel.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
         startDateAndTime.text = dateFormatter.string(from: sender.date)
       
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           
           view.endEditing(true)
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
        let eventTime = startDateAndTime.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let hostname = AppData.shared.profileEmail!.trimmingCharacters(in: .whitespacesAndNewlines)
        let db = Firestore.firestore()
        db.collection("events").addDocument(data: ["name":eventName,"description":eventDescription,"date":eventTime,"hostname":hostname])
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
