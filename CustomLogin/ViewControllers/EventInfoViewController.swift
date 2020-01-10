//
//  EventInfoViewController.swift
//  CustomLogin
//
//  Created by Konsta Miro Santeri Ikonen on 14/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import MapKit

class EventInfoViewController: UIViewController {
        
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    

    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var name = ""
    var eventName = ""
    var dec = ""
    var location = ""
    var date = ""
    var longitude = 0.0
    var latitude  = 0.0
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            view.backgroundColor = UIColor(red: 45/255, green: 40/255, blue: 62/255, alpha: 1.0)
            
        self.title = eventName
        hostNameLabel.text = name
        eventNameLabel.text = eventName
        decLabel.text = dec
        dateLabel.text = date
        locationLabel.text = location
        let location = CLLocationCoordinate2D(latitude: latitude,
                                              longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
       mapView.setRegion(region, animated: true)
        
       let annotation = MKPointAnnotation()
       annotation.coordinate = location
       annotation.title = "Event Location"
       mapView.addAnnotation(annotation)
        
       
        
  /*      self.imageView.layer.cornerRadius = 8
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOpacity = 1
        self.imageView.layer.shadowOffset = .zero
        self.imageView.layer.shadowOpacity = 1
    */
    }
    /*
    func checkLocationServices(){
    if CLLocationManager.locationServicesEnabled(){
        checkLocationAuthorization()
    }else {
        
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case.authorizedWhenInUse:
            
            mapView.showsUserLocation = true
            
        case .denied:
            
            break
            
        case .notDetermined:
            
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true

            
        case .restricted: break
        case .authorizedAlways: break
        }
    }
    */
    @IBOutlet weak var mapView: MKMapView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func navigateMaps(_ sender: UITapGestureRecognizer) {
        let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
                      let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
                      mapItem.name = "Target location"
                      mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
  
    @IBAction func openAppleMaps(_ sender: UITapGestureRecognizer) {
        
        let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Target location"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    

}
