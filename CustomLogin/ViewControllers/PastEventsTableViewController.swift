//
//  PastEventsTableViewController.swift
//  CustomLogin
//
//  Created by Konsta Miro Santeri Ikonen on 15/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PastEventsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
   func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)

        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        searchController.searchResultsController?.view.isHidden = false
        self.tableView.reloadData()
    }
 
    var finalName = "Patrik"
    var tableData = [String]()
    var userCollectionRef: CollectionReference!
    var futureEvents = [String]()
    var opisArray = [String]()
    var datumArray = [String]()
    var selectedRow: Int?
    var myLon = [Double]()
    var myLat = [Double]()
    var myAdress = [String]()
    
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
            resultSearchController = ({
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.obscuresBackgroundDuringPresentation = false
                controller.searchBar.sizeToFit()
                controller.searchBar.delegate = self
                tableView.tableHeaderView = controller.searchBar
                return controller
            })()
        
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
                            let adresa = data["adress"] as? String ?? "Anonymous"
                           let datum = data["date"] as? String ?? "Anonymous"
                           let formatter = DateFormatter()
                           formatter.dateFormat = "MM-dd-yyyy' 'HH:mm"
                           let datumDateType = formatter.date(from: datum)
                        let latitude = data["latitude"] as? Double
                        let longitude = data["longitude"] as? Double
                           let danasnjiDatumDateType = formatter.date(from: self.getCurrentTime())
                           if datumDateType?.compare(danasnjiDatumDateType!) == .orderedAscending{
                                self.futureEvents.append(name)
                                self.opisArray.append(opis)
                                self.datumArray.append(datum)
                               self.tableData.append(name)
                            self.myAdress.append(adresa)//konsta!
                            self.myLat.append(latitude!)
                            self.myLon.append(longitude!)
                               print(name)
                           }
                        
                        
                       }
                      
                       
                       // hide progress view
                       self.tableView.reloadData()
                       activityIndicatorView.stopAnimating()
                   }
               }
            // Reload the table
        }

    // MARK: - Table view data source

   override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
           
       }


       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return tableData.count
       }

       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
           let(events) = tableData[indexPath.row]
           cell.textLabel?.text = events

        return cell
    
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(tableData[indexPath.row])
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showdetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     print("uslo u prepare")
       if segue.identifier == "showdetails"{
         print("uslo u if")
        let destView = segue.destination as! EventInfoViewController
         destView.name = self.finalName
        destView.eventName = self.tableData[selectedRow!]
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
    func getCurrentTime() -> String{
        let format = DateFormatter()
        format.dateFormat = "MM-dd-yyyy' 'HH:mm"
        let date = Date()
        let formattedDate = format.string(from: date)
        return formattedDate
    }

}
