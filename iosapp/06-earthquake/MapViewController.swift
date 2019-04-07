//
//  MapViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/04/06.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    let lm = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        var r = mapView.region
        if let cood = lm.location?.coordinate {
            r.center = cood
        }
        r.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        mapView.setRegion(r, animated: true)
    }
}
