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
    
    var tableData = [String]()
    var userCollectionRef: CollectionReference!
    
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            resultSearchController = ({
                let controller = UISearchController(searchResultsController: nil)
                controller.searchResultsUpdater = self
                controller.obscuresBackgroundDuringPresentation = false
                controller.searchBar.sizeToFit()
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
                           let datum = data["date"] as? String ?? "Anonymous"
                           let formatter = DateFormatter()
                           formatter.dateFormat = "MM-dd-yyyy' 'HH:mm"
                           let datumDateType = formatter.date(from: datum)
                           let danasnjiDatumDateType = formatter.date(from: self.getCurrentTime())
                           if datumDateType?.compare(danasnjiDatumDateType!) == .orderedAscending{
                               self.tableData.append(name)
                               print(name)
                           }
                        
                        
                       }
                      
                       
                       // hide progress view
                       self.tableView.reloadData()
                       activityIndicatorView.stopAnimating()
                   }
               }
            // Reload the table
            tableView.reloadData()
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // 2
        // return the number of rows
        if  (resultSearchController.isActive) {
            return filteredTableData.count
        } else {
            return tableData.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // 3
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

          if (resultSearchController.isActive) {
              cell.textLabel?.text = filteredTableData[indexPath.row]

              return cell
          }
          else {
              cell.textLabel?.text = tableData[indexPath.row]
              print(tableData[indexPath.row])
              return cell
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
