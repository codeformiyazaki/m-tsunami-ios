//
//  MyPageViewController.swift
//  06-earthquake
//
//  Created by koogawa on 2020/01/04.
//  Copyright © 2020 LmLab.net. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var photos: [Photo] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        loadData()
    }

    func loadData() {
        guard let userId = UserManager.sharedInstance.userId else {
            return
        }
        PhotoModel().fetchPhotos(userId: userId) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                for photo in photos {
                    print(photo)
//                    let annotation = CustomAnnotation(name: "camera", color: UIColor.yellow)
//                    annotation.coordinate = CLLocationCoordinate2DMake(photo.location.latitude, photo.location.longitude)
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//                    dateFormatter.dateFormat = "yyyy/M/d HH:mm:ss"
//                    annotation.title = dateFormatter.string(from: (photo.createdAt?.dateValue())!)
//                    annotation.imagePath = photo.imagePath
//                    self?.mapView.addAnnotation(annotation)
                }
            case .failure(let error):
                print("error!", error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Network Error!")
            }
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: .value1, reuseIdentifier: identifier)
        let photo = photos[indexPath.row]
        cell.selectionStyle = .gray
        cell.textLabel?.text = photo.imagePath
        StorageModel().fetchImage(imagePath: photo.imagePath) { result in
            switch result {
            case .success(let image):
                cell.imageView?.image = image
                cell.imageView?.contentMode = .scaleAspectFill
            case .failure(let error):
                print("error!", error.localizedDescription)
            }
        }
        return cell
    }
}
