//
//  MapViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/04/06.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import MapKit

class TolietAnnotation : MKPointAnnotation {}
class BuildingAnnotation : MKPointAnnotation {}
class WebcamAnnotation : MKPointAnnotation {}
class ShelterAnnotation : MKPointAnnotation {}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var buildings = [String]()
    var toilets = [String]()
    var webcams = [String]()
    var shelters = [String]()

    let lm = CLLocationManager()
    var route:MKRoute?
    var webcam_title:String?
    var webcam_url:URL?

    var needResetRegion:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        lm.delegate = self
        buildings = loadCSV(name: "buildings_locations")
        toilets = loadCSV(name: "toilets_locations")
        webcams = loadCSV(name: "webcams_locations")
        shelters = loadCSV(name: "shelters_locations")

        for line in buildings {
            if line == "" { continue }
            let row = line.components(separatedBy: ",")
            let pa = BuildingAnnotation()
            let lng = Double(row[5]) ?? 0
            let lat = Double(row[6]) ?? 0

            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[0]
            pa.subtitle = "標高" + row[2] + "m " + row[3] + " " + row[4] + "階"
            mapView.addAnnotation(pa)
        }
        for line in toilets {
            if line == "" { continue }
            let row = line.components(separatedBy: ",")
            let pa = TolietAnnotation()
            let lng = Double(row[2]) ?? 0
            let lat = Double(row[3]) ?? 0

            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[0]
            pa.subtitle = "トイレ" + row[1] + "個"
            mapView.addAnnotation(pa)
        }
        for line in webcams {
            if line == "" { continue }
            let row = line.components(separatedBy: ",")
            let pa = WebcamAnnotation()
            let lng = Double(row[2]) ?? 0
            let lat = Double(row[3]) ?? 0

            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[0]
            pa.subtitle = "Powered by ii-nami.com"
            mapView.addAnnotation(pa)
        }
        for line in shelters {
            if line == "" { continue }
            let row = line.components(separatedBy: ",")
            let pa = ShelterAnnotation()
            let lng = Double(row[2]) ?? 0
            let lat = Double(row[3]) ?? 0

            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[0]
            mapView.addAnnotation(pa)
        }
    }

    @IBAction func didTapCurrentButton(_ sender: Any) {
        resetRegion()
    }

    func resetRegion() {
        var r = mapView.region
        if let cood = lm.location?.coordinate {
            r.center = cood
        }
        r.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        mapView.setRegion(r, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var name = "building"
        var color = UIColor.gray
        if annotation is TolietAnnotation {
            name = "toilet"
            color = UIColor.cyan
        } else if annotation is WebcamAnnotation {
            name = "webcam"
            color = UIColor.purple
        } else if annotation is ShelterAnnotation {
            name = "shelter"
            color = UIColor.cyan
        }
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: name) as? MKMarkerAnnotationView
        if av == nil {
            av = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: name)
            av!.glyphImage = UIImage(named: name)
            av!.markerTintColor = color
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
        guard let a = view.annotation else { return }
        if a is WebcamAnnotation {
            webcam_url = nil
            webcam_title = a.title ?? ""
            for line in webcams {
                if line == "" { continue }
                let row = line.components(separatedBy: ",")
                if webcam_title == row[0] {
                    webcam_url = URL(string: row[1])
                }
            }
            self.performSegue(withIdentifier: "iinami", sender: self)
            return
        }
        guard let src = lm.location?.coordinate else { return }
        let dst = a.coordinate
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

    // 位置情報取得の許可状況が変わると呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            lm.startUpdatingLocation()
        default:
            lm.requestWhenInUseAuthorization()
        }
    }

    // 位置情報が変更するたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if needResetRegion {
            resetRegion()
            needResetRegion = false
        }
    }

    private func loadCSV(name:String) -> [String]{
        let path = Bundle.main.path(forResource:name, ofType:"csv")!
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        return csvString.components(separatedBy: .newlines)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ivc = segue.destination as? IinamiViewController else { return }
        ivc.webcam_url = webcam_url
        ivc.webcam_title = webcam_title
    }
}
