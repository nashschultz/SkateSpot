//
//  ViewController.swift
//  SkateSpot
//
//  Created by Nash Schultz on 3/20/22.
//

import UIKit
import MapKit

class FindSpotViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var spotList: SpotList?
    var selectedSpot: Spot?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        spotList = SpotList()
        spotList?.loadSpots(updateTable: {
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SpecificSpot":
            let destination = segue.destination as? MapViewController
            destination?.spot = selectedSpot
            destination?.spotList = spotList
            break
        case "AddSpot":
            let destination = segue.destination as? AddSpotViewController
            destination?.spotList = spotList
            break
        default:
            break
        }
    }
}

extension FindSpotViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotList?.spots.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell") as? SkateSpotTableViewCell,
              let spot = spotList?.spots[indexPath.row] else { return UITableViewCell() }
        cell.setUp(spot: spot)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let spot = spotList?.spots[indexPath.row] else { return }
        selectedSpot = spot
        performSegue(withIdentifier: "SpecificSpot", sender: nil)
    }
}

