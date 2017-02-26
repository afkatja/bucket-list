//
//  ViewController.swift
//  Bucket List
//
//  Created by Katja Hollaar on 19/02/2017.
//  Copyright © 2017 Katja Hollaar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uiLongpressHandler = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        uiLongpressHandler.minimumPressDuration = 1.0
        map.addGestureRecognizer(uiLongpressHandler)
        
        if activePlace > -1 {
            if places.count > activePlace {
                if let name = places[activePlace]["name"] {
                    if let subtitle = places[activePlace]["subtitle"] {
                        if let lat = places[activePlace]["lat"] {
                            if let long = places[activePlace]["lon"] {
                                let latitude = Double(lat)
                                let longitude = Double(long)
                                setupMap(lat: latitude!, long: longitude!, delta: 0.05)
                                addAnnotation(title: name, subtitle: subtitle, latitude: latitude!, longitude: longitude!)
                            }
                        }
                    }
                }
            }
        } else {
            //creating a new place from user's location
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        self.setupMap(lat: lat, long: long, delta: 0.05)
        locationManager.stopUpdatingLocation();
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let point = gestureRecognizer.location(in: self.map)
            let coordinates = map.convert(point, toCoordinateFrom: self.map)
            self.getAddressFromLocation(location: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude))
        }
    }
    
    func setupMap(lat: CLLocationDegrees, long: CLLocationDegrees, delta: CLLocationDegrees) {
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    func addAnnotation(title: String, subtitle: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.map.addAnnotation(annotation)
    }
    
    func processGeoResponse(withPlacemarks placemarks:[CLPlacemark]?, location: CLLocation, error: Error?) {
        if error != nil {
            print(error!)
        } else {
            if let placemark = placemarks?[0] {
                var title = ""
                var subtitle = ""
                if placemark.locality != nil {
                    title += placemark.locality!
                    if placemark.thoroughfare != nil {
                        subtitle += placemark.thoroughfare!
                    }
                } else {
                    title = "\(String(location.coordinate.latitude)) \(String(location.coordinate.longitude))"
                    subtitle = "Added \(NSDate())"
                }
                places.append(["name": title, "subtitle": subtitle, "lat": String(location.coordinate.latitude), "lon": String(location.coordinate.longitude)])
                updateUserPlaces(object: places, key: "places")
                self.addAnnotation(title: title, subtitle: subtitle, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
    }
    
    func getAddressFromLocation(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error)  in
            self.processGeoResponse(withPlacemarks: placemarks, location: location, error: error)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

