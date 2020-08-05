//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Abdulkrum Alatubu on 12/12/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Foundation

class TravelLocationsMapView: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var location:Pin?
    
    var pinList = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinList = loadingLocation()
        map.delegate = self
        // Do any additional setup after loading the view.
        updatePins()
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPin(longGesture:)))
        map.addGestureRecognizer(longGesture)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "photoAlbum"{
               let PhotoAlbumVC = segue.destination as! PhotoAlbumViewController
               let location = sender as! Pin
               
               PhotoAlbumVC.pin = location
               
           }
       }
    func loadingLocation()->Array<Pin>{
        var array = [Pin]()
        let fetchRegeust:NSFetchRequest<Pin> = Pin.fetchRequest()
      
        do{
            array =  try context.fetch(fetchRegeust)
        }catch{
            print("erorr")
        }
        
        
        return array
    }
    func updatePins() {
       // guard let locations = pinList else { return }
        
        var annotations = [CustomPointAnnotation]()

        for location in pinList {

            let latitude = location.latitude
            let longitude = location.longitude

            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)


            let annotation = CustomPointAnnotation(pinVariable: location)
            annotation.coordinate = coordinate
       
            annotations.append(annotation)
        }

        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotations)
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        // customAnnotation for add location
        if let customAnnotation = view.annotation as? CustomPointAnnotation {
            self.location = customAnnotation.pin
        }
        
        self.performSegue(withIdentifier: "photoAlbum", sender: location)
    }
 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            
           self.performSegue(withIdentifier: "photoAlbum", sender: location)
        }
    }
    @objc func addPin(longGesture: UIGestureRecognizer) {
       
           if longGesture.state != .began { return }
           let touchPoint = longGesture.location(in: map)
           let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
           let annotation = MKPointAnnotation()
           annotation.title = "photo album"
           annotation.coordinate = newCoordinates
           map.addAnnotation(annotation)
          // location = Location(log: newCoordinates.longitude, lat: newCoordinates.latitude)
           addLocation(longitude: newCoordinates.longitude, latitude: newCoordinates.latitude)
    }
    
    func addLocation(longitude:Double , latitude :Double){
        let Data = Pin(context: context)
        Data.latitude = latitude
        Data.longitude = longitude
        ad.saveContext()
        location = Data
    }

}

class CustomPointAnnotation: MKPointAnnotation {
     var pin: Pin!

     init(pinVariable: Pin) {
          self.pin = pinVariable
     }
}
