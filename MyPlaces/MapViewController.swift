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
  var place: Place!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
