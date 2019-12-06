//
//  EventInfoViewController.swift
//  CustomLogin
//
//  Created by Konsta Miro Santeri Ikonen on 14/11/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import MapKit

class EventInfoViewController: UIViewController {
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var evenNameLabel: UILabel!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var name = ""
    var eventName = ""
    var dec = ""
    var location = ""
    var date = ""
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostNameLabel.text = name
        evenNameLabel.text = eventName
        decLabel.text = dec
        dateLabel.text = date
        checkLocationServices()
        
        
        
    }
    
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
    
    @IBOutlet weak var mapView: MKMapView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
