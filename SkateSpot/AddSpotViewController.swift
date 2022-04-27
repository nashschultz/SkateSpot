//
//  AddSpotViewController.swift
//  SkateSpot
//
//  Created by Nash Schultz on 4/21/22.
//

import UIKit
import FirebaseFirestore
import CoreLocation

class AddSpotViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageLabelView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var selectedImage: UIImage?
    var spotList: SpotList?
    var geoPoint: GeoPoint?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageLabelView.addGestureRecognizer(imageViewTap)
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func saveSpot() {
        guard let title = titleTextField.text, let description = descriptionTextField.text else { return }
        let spot = Spot(id: nil, name: title, description: description, rating: 0, image: imageUrl ?? "", location: geoPoint ?? GeoPoint(latitude: 0, longitude: 0))
        spotList?.addSpot(spot: spot)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectImage() {
        let photoPicker = UIImagePickerController ()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        // display image selection view
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker .dismiss(animated: true, completion: nil)
        imageView.image=info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.5) else { return }
        let imageUploader = ImageUploader()
        imageUploader.uploadMedia(data: imageData) { url in
            self.imageUrl = url
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

extension AddSpotViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            geoPoint = GeoPoint(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        geoPoint = GeoPoint(latitude: 0, longitude: 0)
    }
}
