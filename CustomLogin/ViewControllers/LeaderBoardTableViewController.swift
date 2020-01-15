//
//  LeaderBoardTableViewController.swift
//  CustomLogin
//
//  Created by Konsta Miro Santeri Ikonen on 19/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
    
    

class LeaderBoardTableViewController: UITableViewController {
    
    var finalName = "Patrik"
    var selectedRow: Int?
    var userCollectionRef: CollectionReference!
    var opisArray = [String]()
    var datumArray = [String]()
    var myEvents = [String]()
    var myLon = [Double]()
    var myLat = [Double]()
    var myAdress = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //set background color
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()

      userCollectionRef = Firestore.firestore().collection("events")
      userCollectionRef.getDocuments { (snapshot, error) in
          if let error = error{
              debugPrint("Eror se vraca")
          }else{
              guard let snap = snapshot else { return }
              for document in snap.documents{
                      
                let data = document.data()
                let name = data["name"] as? String ?? "Anonymous"
                let hostname = data["hostname"] as? String ?? "Anonymous"
                let opis = data["description"] as? String ?? "Anonymous"
                let datum = data["date"] as? String ?? "Anonymous"
                let latitude = data["latitude"] as? Double
                let longitude = data["longitude"] as? Double
                let adresa = data["adress"] as? String ?? "Anonymous"
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy' 'HH:mm"
                
                  
                if hostname == CurrentUser.shared.profileEmail!{
                      self.myEvents.append(name)
                      self.opisArray.append(opis)
                      self.datumArray.append(datum)
                    self.myLat.append(latitude!)
                    self.myLon.append(longitude!)
                    self.myAdress.append(adresa)
                      print(name)
                  }
                  
              }
              //print(self.futureEvents.count)
              
              // hide progress view
            self.tableView.reloadData()
            activityIndicatorView.stopAnimating()
          }
      }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
           
       }


       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return myEvents.count
       }

       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "cells", for: indexPath)
           let(events) = myEvents[indexPath.row]
           cell.textLabel?.text = events
        
           // Add date to "Subtitle"
           //cell.detailTextLabel?.text =
        
           return cell
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print(indexPath.row)
           print("Oznacio ga je")
           print(myEvents[indexPath.row])
           selectedRow = indexPath.row
           self.performSegue(withIdentifier: "showyourdetail", sender: self)
       }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            //call alert before deleting
            deleteEventAlert()
            
            myEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
        }

    }

    //alert before deleting
    func deleteEventAlert(){
          let alert = UIAlertController(title: "Delete Event?", message: "", preferredStyle: UIAlertController.Style.alert)
          
          alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
          }
          ))
          
          alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                }
          ))
          
          self.present(alert, animated: true, completion: nil)
        
      }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           print("uslo u prepare")
             if segue.identifier == "showyourdetail"{
               print("uslo u if")
              let destView = segue.destination as! EventInfoViewController
               destView.name = self.finalName
                destView.eventName = self.myEvents[selectedRow!]
                destView.dec = self.opisArray[selectedRow!]
                destView.date = self.datumArray[selectedRow!]
                destView.longitude = self.myLon[selectedRow!]
                destView.latitude = self.myLat[selectedRow!]
                destView.location = self.myAdress[selectedRow!]
              }
          }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
