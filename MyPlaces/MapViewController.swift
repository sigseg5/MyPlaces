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
  }
  
  @IBAction func cancelMapVC() {
    dismiss(animated: true, completion: nil)
  }
}
