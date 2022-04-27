//
//  MapViewController.swift
//  SkateSpot
//
//  Created by Nash Schultz on 4/19/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var spot: Spot?
    var spotList: SpotList?
    var weatherService: WeatherService?

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherService = WeatherService()
        loadWeather()
        setUpView()
    }
    
    func loadWeather() {
        geocode(latitude: spot?.location?.latitude ?? 0, longitude: spot?.location?.longitude ?? 0, completion: { placemark, error in
            if let error = error as? CLError {
                print("CLError:", error)
                return
            } else if let placemark = placemark?.first {
                self.weatherService?.fetchWeather(zipCode: placemark.postalCode ?? "85281", completionHandler: { weather in
                    DispatchQueue.main.async {
                        self.weatherLabel.text = "The weather at this spot is " + String(weather.temp_f) + "F with wind speeds of " + String(weather.wind_mph) + "MPH."
                    }
                })
            }
        })
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: completion)
    }
    
    func setUpView() {
        titleLabel.text = spot?.name
        descriptionLabel.text = spot?.description
        ratingLabel.text = String(spot?.rating ?? 0)
        let location = CLLocation(latitude: spot?.location?.latitude ?? 0, longitude: spot?.location?.longitude ?? 0)
        centerToLocation(location)
        
        imageView.layer.cornerRadius = imageView.frame.height / 2
        if let imageUrl = spot?.image, let url = URL(string: imageUrl) {
            imageView.load(url: url)
        }
    }
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func upVoteSpot() {
        guard let spot = spot else {
            return
        }

        spotList?.rateSpot(spot: spot, val: 1)
        ratingLabel.text = String(spot.rating ?? 0)
    }
    
    @IBAction func downVoteSpot() {
        guard let spot = spot else {
            return
        }

        spotList?.rateSpot(spot: spot, val: -1)
        ratingLabel.text = String(spot.rating ?? 0)
    }
    
    @IBAction func deleteSpot() {
        guard let spot = spot else {
            return
        }

        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this spot?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.spotList?.removeSpot(spot: spot)
            self.navigationController?.popViewController(animated: true)
        }
        let okayAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            return
        }
        
        alert.addAction(deleteAction)
        alert.addAction(okayAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
