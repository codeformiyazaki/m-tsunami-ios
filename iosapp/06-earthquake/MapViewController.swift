//
//  MapViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/04/06.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
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
        
        
        let data =
            [["ティープリモ権現町","標高6m RC 5F","31.92896","131.432472"],["宮崎観光ホテル東館","標高5.3m SRC 13F","31.905684","131.426782"],["TYⅡマンション","標高5.5m RC 6F","31.920798","131.428084"],["セ・ラ・ヴィ柳丸","標高5.8m RC 7F","31.926081","131.434318"],["コアマンション柳丸","標高6.4m RC 9F","31.928688","131.433429"]]
        
        for row in data {
            let pa = MKPointAnnotation()
            let lat = Double(row[2]) ?? 0
            let lng = Double(row[3]) ?? 0
            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[0]
            pa.subtitle = row[1]
            mapView.addAnnotation(pa)
            print(row[0]+": "+row[1])
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: "id") as? MKMarkerAnnotationView
        if av == nil {
            av = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "id")
            av!.glyphImage = UIImage(named: "building")
        } else {
            av!.annotation = annotation
        }
        return av
    }
}
