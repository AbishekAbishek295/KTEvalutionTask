//
//  LocationListViewController.swift
//  KTEvalutionTask
//
//  Created by abishek m on 29/06/24.
//

import UIKit
import RealmSwift
import GoogleMaps

class LocationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
     var locations: Results<LocationData>?
     var notificationToken: NotificationToken?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchLocations()
    }
    
     func fetchLocations() {
        let realm = try! Realm()
        locations = realm.objects(LocationData.self).sorted(byKeyPath: "timestamp", ascending: false)
        
        for location in locations! where location.address == nil {
            GeocodingHelper.shared.getAddressFromLatLon(latitude: location.latitude, longitude: location.longitude) { address in
                if let address = address {
                    try! realm.write {
                        location.address = address
                    }
                }
            }
        }
        
        notificationToken = locations?.observe { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            case .update(_, let deletions, let insertions, let modifications):
                DispatchQueue.main.async {
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                        tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                        tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    }, completion: nil)
                }
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    
    deinit {
        notificationToken?.invalidate()
    }
    
//MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! TableViewCell
        
        if let locationData = locations?[indexPath.row] {
            cell.locationLabel.text = locationData.address ?? "loading address"
            
            if locationData.address == nil {
                GeocodingHelper.shared.getAddressFromLatLon(latitude: locationData.latitude, longitude: locationData.longitude) { address in
                    if let address = address {
                        let realm = try! Realm()
                        try! realm.write {
                            locationData.address = address
                        }
                        
                        DispatchQueue.main.async {
                            if let cellToUpdate = tableView.cellForRow(at: indexPath) as? TableViewCell {
                                cellToUpdate.locationLabel.text = address
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let locationData = locations?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mapVC = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
                let coordinate = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
                GeocodingHelper.shared.getAddressFromLatLon(latitude: locationData.latitude, longitude: locationData.longitude) { address in
                    mapVC.coordinate = coordinate
                    mapVC.locationAddress = address ?? "Address not found"
                    self.navigationController?.pushViewController(mapVC, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
