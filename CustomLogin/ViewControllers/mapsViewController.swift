//
//  mapsViewController.swift
//  CustomLogin
//
//  Created by formando on 04/12/2019.
//  Copyright © 2019 formando. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import GoogleMapsBase

class mapsViewController: UIViewController, CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate {
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
       
    }
    var locationManager: CLLocationManager?
    var mapView: GMSMapView?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    
    var CustomLongtitude:Double = 0.0;
    var CustomLatitude:Double = 0.0;
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      // 3
      guard status == .authorizedWhenInUse else {
        return
      }
     
      locationManager?.startUpdatingLocation()
      mapView?.isMyLocationEnabled = true
      mapView?.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.first else {
        return
      }
        
      // 7
      mapView?.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()

        let camera = GMSCameraPosition.camera(withLatitude: 39.747457, longitude: -8.807676, zoom: 9.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        
        self.view.addSubview(mapView!)
        setupSearchController()
    }
   
    func setupSearchController(){
      
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        //resultsViewController?.autocompleteBounds
        let neBoundsCorner = CLLocationCoordinate2D(latitude: 39.747457,
                                                    longitude: -8.807676)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: 39.747457,
                                                    longitude: -8.807676)
        resultsViewController?.setAutocompleteBoundsUsingNorthEastCorner(neBoundsCorner, southWestCorner: swBoundsCorner)
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
         let searchBar = UIView(frame: CGRect(x: 0, y: 45.0, width: 350.0, height: 45.0))
         searchBar.addSubview((searchController?.searchBar)!)
         view.addSubview(searchBar)
         //searchController?.searchBar.isUserInteractionEnabled = true
         searchController?.searchBar.sizeToFit()
         searchController?.hidesNavigationBarDuringPresentation = false
         definesPresentationContext = true
         
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        
        CustomLatitude = place.coordinate.latitude
        CustomLongtitude = place.coordinate.longitude
        
        AppData.shared.latitude = CustomLatitude
        AppData.shared.longitude = CustomLongtitude
       
        AppData.shared.adresa = place.formattedAddress
        AppData.shared.selectedAdress = place.formattedAddress
        let addEventViewController = self.storyboard?.instantiateViewController(withIdentifier: "addEvent") as! addEventViewController
        addEventViewController.locationTest = place.formattedAddress!
        print(place.coordinate.latitude)
        print(AppData.shared.adresa!)
        let position = CLLocationCoordinate2D(latitude: CustomLatitude, longitude: CustomLongtitude)
        let marker = GMSMarker(position:position)
        marker.tracksViewChanges = true
        marker.map = mapView
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = place.formattedAddress

        }

    
     
     
    func transitionToHome(){
        dismiss(animated: true, completion: nil)

        /* Cancel and go home old way
        let nextViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.addEventViewController) as? addEventViewController
           view.window?.rootViewController = nextViewController
           view.window?.makeKeyAndVisible()
           //self.performSegue(withIdentifier: "loginToProfile", sender: self)
         */
    }

    @IBAction func cancelButton(_ sender: Any) {
        transitionToHome()
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        transitionToHome()
    }
}
