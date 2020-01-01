//
//  MapViewController.swift
//  06-earthquake
//
//  Created by Yosei Ito on 2019/04/06.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class CustomAnnotation : MKPointAnnotation {
    let name: String
    let color: UIColor
    var imagePath: String?

    init(name: String, color: UIColor, imagePath: String? = nil) {
        self.name = name
        self.color = color
        self.imagePath = imagePath
        super.init()
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, IconSettingsViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    private lazy var iconSettingsRepository: IconSettingsRepository = IconSettingsRepositoryImpl()

    var shelters = [String]()
    var webcams = [String]()

    let lm = CLLocationManager()
    var route:MKRoute?
    var webcam_title:String?
    var webcam_url:URL?

    var needResetRegion:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // 指定緊急避難場所（地震発生時の一時避難場所） > sites4earthquake
        // 指定緊急避難場所（津波発生時の一時避難場所） > sites4tsunami
        // 指定緊急避難場所（津波避難ビル） > buildings
        // 指定避難所 > shelters
        // 指定避難所兼指定緊急避難場所 > site_and_shelters

        // 設定のデフォルト値をセット
        UserDefaults.standard.register(defaults: ["site4earthquake" : true,
                                                  "site4tsunami" : true,
                                                  "building" : true,
                                                  "shelter" : true,
                                                  "site_and_shelter" : true,
                                                  "webcams" : true])

        lm.delegate = self

        loadData()
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

    private func clearData() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }

    private func loadData() {
        let TYPE2NAME = ["指定緊急避難場所（地震発生時の一時避難場所）":"site4earthquake",
                         "指定緊急避難場所（津波発生時の一時避難場所）":"site4tsunami",
                         "指定緊急避難場所（津波避難ビル）":"building",
                         "指定避難所":"shelter",
                         "指定避難所兼指定緊急避難場所":"site_and_shelter"]
        let TYPE2COLOR = ["指定緊急避難場所（地震発生時の一時避難場所）":UIColor.orange,
                          "指定緊急避難場所（津波発生時の一時避難場所）":UIColor.orange,
                          "指定緊急避難場所（津波避難ビル）":UIColor.gray,
                          "指定避難所":UIColor.orange,
                          "指定避難所兼指定緊急避難場所":UIColor.orange]

        shelters = loadCSV(name: "shelters")
        for line in shelters {
            if line == "" { continue }
            let row = line.components(separatedBy: ",")
            let name = TYPE2NAME[row[0]] ?? ""
            if !iconSettingsRepository.fetch(key: name) { continue }
            let pa = CustomAnnotation(name: name, color: TYPE2COLOR[row[0]] ?? UIColor.red)
            let lng = Double(row[5]) ?? 0
            let lat = Double(row[6]) ?? 0

            pa.coordinate = CLLocationCoordinate2DMake(
                lat,lng)
            pa.title = row[1]
            pa.subtitle = "想定収容人数: "+row[3]
            if row[4] != "0" { pa.subtitle! += " MHトイレ基数: "+row[4] }
            mapView.addAnnotation(pa)
        }

        // ウェブカメラ
        if iconSettingsRepository.fetch(key: "webcams") {
            webcams = loadCSV(name: "webcams_locations")
            for line in webcams {
                if line == "" { continue }
                let row = line.components(separatedBy: ",")
                let pa = CustomAnnotation(name: "webcam", color: UIColor.blue)
                let lng = Double(row[2]) ?? 0
                let lat = Double(row[3]) ?? 0

                pa.coordinate = CLLocationCoordinate2DMake(
                    lat,lng)
                pa.title = row[0]
                pa.subtitle = "Powered by ii-nami.com"
                mapView.addAnnotation(pa)
            }
        }

        // 投稿写真
        PhotoModel().addSnapshotListener { [weak self] result in
            switch result {
            case .success(let photo):
                let annotation = CustomAnnotation(name: "camera", color: UIColor.yellow)
                annotation.coordinate = CLLocationCoordinate2DMake(photo.location.latitude, photo.location.longitude)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy/M/d HH:mm:ss"
                annotation.title = dateFormatter.string(from: photo.createdAt.dateValue())
                annotation.imagePath = photo.imagePath
                self?.mapView.addAnnotation(annotation)
            case .failure(let error):
                print("error!", error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Network Error!")
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let ca = annotation as? CustomAnnotation ?? CustomAnnotation(name: "square-empty-info", color: UIColor.red)
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: ca.name) as? MKMarkerAnnotationView
        if av == nil {
            av = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: ca.name)
            av?.glyphImage = UIImage(named: ca.name)
            av?.markerTintColor = ca.color
            if ca.name == "camera" {
                av?.canShowCallout = true
                av?.displayPriority = .required
                let iv = Bundle.main.loadNibNamed("PhotoCalloutAccessoryView", owner: nil, options: nil)!.first as! PhotoCalloutAccessoryView
                av?.detailCalloutAccessoryView = iv
            }
        } else {
            av?.annotation = annotation
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
        guard let a = view.annotation as? CustomAnnotation else { return }
        if a.name == "webcam" {
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
        if a.name == "camera", let imagePath = a.imagePath {
            let iv = view.detailCalloutAccessoryView as! PhotoCalloutAccessoryView
            StorageModel().fetchImage(imagePath: imagePath) { result in
                switch result {
                case .success(let image):
                    iv.photoImageView.image = image
                    iv.userLabel.text = "ID: " + (UserManager.sharedInstance.userId ?? "")
                case .failure(let error):
                    print("error!", error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "Network Error!")
                }
            }
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
            let rect = new_route.polyline.boundingMapRect.insetBy(dx: -900, dy: -900)
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
        if let location = locations.first {
            UserManager.sharedInstance.latitude = location.coordinate.latitude
            UserManager.sharedInstance.longitude = location.coordinate.longitude
        }

        if needResetRegion {
            resetRegion()
            needResetRegion = false
        }
    }

    func iconSettingsViewControllerDidClose() {
        clearData()
        loadData()
    }

    private func loadCSV(name:String) -> [String]{
        let path = Bundle.main.path(forResource:name, ofType:"csv")!
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        return csvString.components(separatedBy: .newlines)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ivc = segue.destination as? IinamiViewController {
            ivc.webcam_url = webcam_url
            ivc.webcam_title = webcam_title
        } else if let ivc = segue.destination as? IconSettingsViewController {
            ivc.delegate = self
        }
    }
}
