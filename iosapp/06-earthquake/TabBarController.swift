//
//  TabBarController.swift
//  06-earthquake
//
//  Created by koogawa on 2019/12/28.
//  Copyright © 2019 LmLab.net. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        delegate = self
    }

    func didSelectCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }

    func uploadImage(image: UIImage) {
        // todo: Auth
        let userId = "hoge"
        StorageModel().uploadImage(uid: userId, image: image) { [weak self] result in
            switch result {
            case .success(let imagePath):
                // todo: mapVC に依存しないほうが良さそう。UserManager シングルトンに持たせるか？
                if let mapViewController = self?.viewControllers?[0] as? MapViewController,
                    let coordinate = mapViewController.lm.location?.coordinate {
                    self?.addPhoto(imagePath: imagePath, latitude: coordinate.latitude, longitude: coordinate.longitude)
                }
            case .failure(let error):
                print("error!", error.localizedDescription)
            }
        }
    }

    func addPhoto(imagePath: String, latitude: Double, longitude: Double) {
        PhotoModel().addPhoto(imagePath: imagePath, latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success:
                print("success!")
            case .failure(let error):
                print("error!", error.localizedDescription)
            }
        }
    }
}

extension TabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 撮影が完了時した時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            uploadImage(image: originalImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let restorationIdentifier = viewController.restorationIdentifier,
            restorationIdentifier == "Camera" {
            didSelectCamera()
            return false
        }
        return true
    }
}
