//
//  CameraViewController.swift
//  06-earthquake
//
//  Created by koogawa on 2020/01/02.
//  Copyright © 2020 LmLab.net. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class CameraViewController: UIViewController {

    @IBOutlet weak var clearButtonItem: UIBarButtonItem!
    @IBOutlet weak var postButtonItem: UIBarButtonItem!

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!

    @IBAction func post(_ sender: Any) {
        guard let image = previewImageView.image else { return }
        uploadImage(image: image)
    }

    @IBAction func clear(_ sender: Any) {
        clear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPreview))
        recognizer.isEnabled = true
        previewImageView.addGestureRecognizer(recognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reverseGeocodeLocation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didSelectCamera()
    }

    @objc private func didTapPreview() {
        didSelectCamera()
    }

    func clear() {
        previewImageView.image = nil
        commentTextView.text = nil
        commentTextView.resignFirstResponder()
        updateButtonEnabled()
    }

    func updateButtonEnabled() {
        clearButtonItem.isEnabled = previewImageView.image != nil || !commentTextView.text.isEmpty
        postButtonItem.isEnabled = previewImageView.image != nil
    }

    func reverseGeocodeLocation() {
        let location = CLLocation(latitude: UserManager.sharedInstance.latitude,
                                  longitude: UserManager.sharedInstance.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first,
                let name = placemark.name,
                let locality = placemark.locality,
                error == nil else { return }
            self?.commentTextView.text = "\(locality)\(name) 付近にて撮影。"
        }
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
        guard let userId = UserManager.sharedInstance.userId else { return }

        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()

        StorageModel().uploadImage(uid: userId, image: image) { [weak self] result in
            switch result {
            case .success(let imagePath):
                self?.addPhoto(imagePath: imagePath,
                               comment: self?.commentTextView.text,
                               latitude: UserManager.sharedInstance.latitude,
                               longitude: UserManager.sharedInstance.longitude)
            case .failure(let error):
                print("error!", error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Network Error!")
            }
        }
    }

    func addPhoto(imagePath: String, comment: String?, latitude: Double, longitude: Double) {
        PhotoModel().addPhoto(imagePath: imagePath, comment: comment, latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success:
                SVProgressHUD.showSuccess(withStatus: "写真を投稿しました")
                self?.clear()
            case .failure(let error):
                print("error!", error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Network Error!")
            }
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // 撮影が完了時した時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[.originalImage] as? UIImage {
            previewImageView.image = originalImage
            commentTextView.becomeFirstResponder()
            updateButtonEnabled()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
