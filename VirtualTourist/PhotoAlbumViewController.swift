//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Abdulkrum Alatubu on 12/12/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import CoreData
import RappleProgressHUD

class PhotoAlbumViewController: UIViewController ,MKMapViewDelegate,UICollectionViewDelegate , UICollectionViewDataSource {

    @IBOutlet weak var Collection: UICollectionView!
    @IBOutlet weak var map: MKMapView!
    var photo = [URL]()
    var pin : Pin?
    var photoList = [Photo]()

    func loadingLocation()->Array<Photo>{
        var array = [Photo]()
        let fetchRegeust:NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRegeust.predicate = NSPredicate(format: "pin = %@", pin!)

        do{
            array =  try context.fetch(fetchRegeust)
        }catch{
            print("erorr")
        }
        
        
        return array
    }
    func SavePhoto(data:Data , pin :Pin , url :URL){
        let photo = Photo(context: context)
        photo.photo = data
        photo.pin = pin
        photo.url = url
        ad.saveContext()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Collection.delegate = self
        Collection.dataSource = self
        
        map.delegate = self

        setup()
     
        
        photoList = loadingLocation()
        
        if photoList.isEmpty{
             loadURLFromAPI()
        }else{
             loadURL(photoList: photoList)
        }
    }

 
    func setup(){
         
        let latitude = CLLocationDegrees(pin!.latitude)
        let longitude = CLLocationDegrees(pin!.longitude)
         
         let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
         
         let annotation = MKPointAnnotation()
         annotation.coordinate = coordinate
         
         map.addAnnotation(annotation)
         
         let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
         map.setRegion(region, animated: true)
    
     }
    func loadURL(photoList :Array<Photo>){
        for imageURL in photoList{
            let url = imageURL.url
            self.photo.append(url!)
        }
    }
    func loadURLFromAPI(){
            RappleActivityIndicatorView.startAnimating()
            API.getURL(latitude: "\(pin!.latitude)", longitude: "\(pin!.longitude)") { (photoAlbum, error) in
            RappleActivityIndicatorView.stopAnimation()
            guard let data = photoAlbum else {
                self.showAlert(title: "Error", message: "No internet connection")
                return
            }
            guard data.photos.photo.count > 0 else {
                self.showAlert(title: "Error", message: "No images found for this location")
                return
            }
                        
            
            for imageURL in data.photos.photo{
                let url = URL(string: imageURL.urlS)
                self.photo.append(url!)
                guard let imageData = try? Data(contentsOf: url!) else {
                    print("Image does not exist at \(String(describing: imageURL))")
                    return
                }
                self.SavePhoto(data: imageData, pin: self.pin!, url: url!)

            }
            self.Collection.reloadData()

        }
         
      }
    func deleteAll(){
            for list in self.photoList{
                context.delete(list)
                try? context.save()
            }
    }
    func deleteImage(at indexPath: IndexPath) {
        if photoList.isEmpty{
           photoList = loadingLocation()
        }
        let imageToDelete = photoList[indexPath.row]
        context.delete(imageToDelete)
        try? context.save()
    }

    @IBAction func newCollection(_ sender: Any) {
        DispatchQueue.main.async {
            self.deleteAll()
            self.photoList.removeAll()
            self.photo.removeAll()
            self.loadURLFromAPI()

        }
    }
}

extension UIViewController {
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .medium)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension PhotoAlbumViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (view.frame.width - 10) / 3, height: (view.frame.height - 10) / 3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photo.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewList:CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection", for: indexPath) as! CollectionViewCell
        viewList.url = photo[indexPath.row]
        return viewList
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteImage(at: indexPath)
        photoList.removeAll()
        photo.removeAll()
        photoList = loadingLocation()
        loadURL(photoList: photoList)
        Collection.reloadData()
        showAlert(title: "delete", message: "the image has been deleted")
    }
    
}


extension PhotoAlbumViewController  {
    
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
}

