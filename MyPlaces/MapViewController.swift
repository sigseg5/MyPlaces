//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Kirill Parhomenko on 25.1.2020.
//  Copyright © 2020 Kirill Parhomenko. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  var place = Place()
  let annotationIdentifier = "annotationIdentifier"
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    mapView.showsCompass = false
    setupPlacemark()
    checkLocationServices()
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
  
  private func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      setupLocationManager()
      checkLocationAuth()
    } else {
      DispatchQueue.main.async {
        let locationErrorAlert = UIAlertController(title: "Geolocation Services Error", message: "Please enable Location Services in iPhone settings", preferredStyle: .alert)
        locationErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        locationErrorAlert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action:UIAlertAction!) in
          self.openLocationSettings()
        }))
        self.present(locationErrorAlert, animated: true, completion: nil)
      }
    }
  }
  
  private func setupLocationManager() {
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.delegate = self
  }
  
  private func checkLocationAuth() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      DispatchQueue.main.async {
        let locationErrorAlert = UIAlertController(title: "Geolocation Services Error – restricted", message: "Please enable Location Services in iPhone settings", preferredStyle: .alert)
        locationErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        locationErrorAlert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action:UIAlertAction!) in
          self.openLocationSettings()
        }))
        self.present(locationErrorAlert, animated: true, completion: nil)
      }
      break
    case .denied:
      DispatchQueue.main.async {
        let locationErrorAlert = UIAlertController(title: "Geolocation Services Error", message: "Please enable Location Services in iPhone settings", preferredStyle: .alert)
        locationErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        locationErrorAlert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action:UIAlertAction!) in
          self.openLocationSettings()
        }))
        self.present(locationErrorAlert, animated: true, completion: nil)
      }
      break
    case .authorizedAlways:
      break
    case .authorizedWhenInUse:
      mapView.showsUserLocation = true
      break
    @unknown default:
      NSLog("New case here")
    }
  }
  
  private func openLocationSettings() {
    if let url = URL(string:"App-Prefs:root=Privacy") {
      if UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
          UIApplication.shared.openURL(url)
        }
      }
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

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuth()
  }
}
