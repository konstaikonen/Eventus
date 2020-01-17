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
    
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var startDateAndTime: UITextField!
    var locationTest: String = ""

    @IBOutlet weak var scrollView: UIView!
    
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
    //back button programmatically

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.backgroundColor = .clear
        //hide keyboard when clickout
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            view.addGestureRecognizer(tap)
        
        //backgroundcolor
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)

        
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
        hostnameLabel.text = CurrentUser.shared.name
        eventNameLabel.text = AppData.shared.pomIme
        eventDescriptionLabel.text = AppData.shared.pomeDesc
        startDateAndTime.text = AppData.shared.pomLoc
        startDateAndTime.inputView = datePicker
        eventNameLabel.becomeFirstResponder()
        locationLabel.text = AppData.shared.adresa

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
  
        var eventName = eventNameLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let eventDescription = eventDescriptionLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let eventTime = startDateAndTime.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let hostname = CurrentUser.shared.profileEmail!.trimmingCharacters(in: .whitespacesAndNewlines)
        if eventName == "" || eventDescription == "" || eventTime == "" || AppData.shared.latitude == nil || AppData.shared.longitude == nil {
            print("Ovo je error")
        }else{
        let db = Firestore.firestore()
            db.collection("events").addDocument(data: ["name":eventName,"description":eventDescription,"date":eventTime,"hostname":hostname,"longitude":AppData.shared.longitude,"latitude":AppData.shared.latitude,"adress":AppData.shared.adresa,"username":CurrentUser.shared.profileUsername])
        //Transition to home screen
        print(AppData.shared.adresa!)
        AppData.shared.adresa = ""
        AppData.shared.selectedAdress = ""
        AppData.shared.pomIme = ""
            AppData.shared.pomeDesc = ""
            AppData.shared.pomLoc = ""
            transitionToHome()
        }
    }
    
     func transitionToHome(){

           let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.tabBarViewController) as? TabBarViewController
           
           view.window?.rootViewController = tabBarViewController
           view.window?.makeKeyAndVisible()
    
           
           
           //self.performSegue(withIdentifier: "loginToProfile", sender: self)
           
       }
    
    @IBAction func openMapsButton(_ sender: Any) {
        performSegue(withIdentifier: "goToMaps", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMaps"{
            AppData.shared.pomIme = eventNameLabel.text
            AppData.shared.pomeDesc = eventDescriptionLabel.text
            AppData.shared.pomLoc = startDateAndTime.text
        }
    }
    
    
    @IBAction func cancelCreateEvent(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        /*
        let tabBarViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.tabBarViewController) as? TabBarViewController
           view.window?.rootViewController = tabBarViewController
           view.window?.makeKeyAndVisible()
        */
           
        
    }
    
}
