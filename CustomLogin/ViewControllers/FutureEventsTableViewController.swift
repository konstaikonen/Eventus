//
//  FutureEventsTableViewController.swift
//  CustomLogin
//
//  Created by Konsta Miro Santeri Ikonen on 19/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth



class FutureEventsTableViewController: UITableViewController {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    
    
    var userCollectionRef: CollectionReference!
    var finalName = [String]()
    var futureEvents = [String]()
    var opisArray = [String]()
    var datumArray = [String]()
    var selectedRow: Int?
    var myLon = [Double]()
    var myLat = [Double]()
    var myAdress = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set background color
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
      
        // add progress indicator
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
                    let opis = data["description"] as? String ?? "Anonymous"
                    let hostname = data["username"] as? String ?? "Anonymous"
                    let datum = data["date"] as? String ?? "Anonymous"
                    let adresa = data["adress"] as? String ?? "Anonymous"
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy' 'HH:mm"
                    let datumDateType = formatter.date(from: datum)
                    let danasnjiDatumDateType = formatter.date(from: self.getCurrentTime())
                    let latitude = data["latitude"] as? Double
                    let longitude = data["longitude"] as? Double
                    
                    if datumDateType?.compare(danasnjiDatumDateType!) == .orderedDescending{
                        self.futureEvents.append(name)
                        self.finalName.append(hostname)
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
        return futureEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellE", for: indexPath)
    
        let(events) = futureEvents [indexPath.row]
        cell.textLabel?.text = events
        cell.detailTextLabel?.text = datumArray[indexPath.row]
        
        return cell
 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(futureEvents[indexPath.row])
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showdetail", sender: self)
    }
    

/*
    func prepare(segue: UIStoryboardSegue, sender: Any?) {
            print("segue funkcija")
            let vc = segue.destination as! EventInfoViewController
            print("segue funkcija")
            vc.name = self.finalName
            print("segue funkcija")
        }
  */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("uslo u prepare")
          if segue.identifier == "showdetail"{
            print("uslo u if")
           let destView = segue.destination as! EventInfoViewController
            destView.name = self.finalName[selectedRow!]
            destView.eventName = self.futureEvents[selectedRow ?? 0]
            destView.dec = self.opisArray[selectedRow ?? 0]
            destView.date = self.datumArray[selectedRow ?? 0]
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
    
    func getCurrentTime() -> String{
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy' 'HH:mm"
        let date = Date()
        let formattedDate = format.string(from: date)
        return formattedDate
    }

}
