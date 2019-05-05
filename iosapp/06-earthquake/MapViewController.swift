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
    var csvLines = [String]()

    let lm = CLLocationManager()
    var route:MKRoute?

    override func viewDidLoad() {
        super.viewDidLoad()

        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        let path = Bundle.main.path(forResource:"buildings_locations", ofType:"csv")!
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        csvLines = csvString.components(separatedBy: .newlines)
    }

    override func viewDidAppear(_ animated: Bool) {
        var r = mapView.region
        if let cood = lm.location?.coordinate {
            r.center = cood
        }
        r.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        mapView.setRegion(r, animated: true)
        
        for line in csvLines {
            if line == "" { continue }
            let row = line.components(separatedBy: ",")
            let pa = MKPointAnnotation()
            let lat = Double(row[6]) ?? 0
            let lng = Double(row[7]) ?? 0
            
            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[1]
            pa.subtitle = "標高" + row[3] + "m " + row[4] + " " + row[5] + "階"
            mapView.addAnnotation(pa)
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
            av!.markerTintColor = UIColor.gray
        } else {
            av!.annotation = annotation
        }
        return av
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        guard let src = lm.location?.coordinate else { return }
        guard let dst = view.annotation?.coordinate else { return }
        let p_src = MKPlacemark(coordinate: src)
        let p_dst = MKPlacemark(coordinate: dst)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: p_src)
        directionRequest.destination = MKMapItem(placemark: p_dst)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                guard let e = error else { return }
                print("we have error getting directions==\(e.localizedDescription)")
                return
            }
            // 以前の経路があれば消す
            if let prev_route = self.route {
                self.mapView.removeOverlay(prev_route.polyline)
            }
            // 新しい経路（とりあえず最初の候補）
            let new_route = directionResponse.routes[0]
            self.mapView.addOverlay(new_route.polyline, level: .aboveRoads)
            self.route = new_route
            // 現在地と目的地が収まるよう縮尺変更
            let rect = new_route.polyline.boundingMapRect.insetBy(dx: -600, dy: -600)
            self.mapView.setRegion(MKCoordinateRegion(rect),animated: true)
        }
    }
}
