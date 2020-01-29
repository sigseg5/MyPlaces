//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Kirill Parhomenko on 25.1.2020.
//  Copyright © 2020 Kirill Parhomenko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  var place = Place()
  let annotationIdentifier = "annotationIdentifier"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    setupPlacemark()
  }
  
  @IBAction func cancelMapVC() {
    dismiss(animated: true, completion: nil)
  }
  
  private func setupPlacemark() {
    guard let location = place.location else { return }
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(location) { (placemarksArray, error) in
      
      if let error = error {
        print(error)
        return
      }
      
      guard let placemarksArray = placemarksArray else { return }
      let placemark = placemarksArray.first
      let annotation = MKPointAnnotation()
      annotation.title = self.place.name
      annotation.subtitle = self.place.type
      
      guard let placemarkLocation = placemark?.location else { return }
      annotation.coordinate = placemarkLocation.coordinate
      self.mapView.showAnnotations([annotation], animated: true)
      self.mapView.selectAnnotation(annotation, animated: true)
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard !(annotation is MKUserLocation) else { return nil }
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
      annotationView?.canShowCallout = true
    }
    
    if let imageData = place.imageData {
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
      imageView.layer.cornerRadius = 10
      imageView.clipsToBounds = true
      imageView.image = UIImage(data:imageData)
      annotationView?.rightCalloutAccessoryView = imageView
    }
    
    return annotationView
  }
}
