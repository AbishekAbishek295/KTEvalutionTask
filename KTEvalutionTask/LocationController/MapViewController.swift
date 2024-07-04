//
//  MapViewController.swift
//  KTEvalutionTask
//
//  Created by abishek m on 29/06/24.
//


import UIKit
import GoogleMaps
import RealmSwift
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: GMSMapView!
    var coordinate: CLLocationCoordinate2D?
    var locationAddress: String?
    var locationData: Results<LocationData>?
    var marker: GMSMarker?
    let geocodingBatchSize = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let coordinate = coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
            mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
            mapView.delegate = self
            self.view.addSubview(mapView)
            
            marker = GMSMarker(position: coordinate)
            marker?.title = "Location"
            marker?.snippet = locationAddress
            marker?.map = mapView
            
            mapView.selectedMarker = marker
        }
        

        let playbackButtonSize = CGSize(width: 40, height: 40)
        let playbackButton = UIButton(type: .custom)
        playbackButton.frame = CGRect(x: view.bounds.width - playbackButtonSize.width - 20,
                                      y: view.bounds.height - 100,
                                      width: playbackButtonSize.width,
                                      height: playbackButtonSize.height)
        playbackButton.setImage(UIImage(named: "PlayBack"), for: .normal)
        playbackButton.addTarget(self, action: #selector(playbackButtonTapped), for: .touchUpInside)
        view.addSubview(playbackButton)
        
        loadLocationData()
    }

    func loadLocationData() {
        let realm = try! Realm()
        locationData = realm.objects(LocationData.self).sorted(byKeyPath: "timestamp", ascending: true)
        print("\(locationData?.count ?? 0) locations")
    }

    @objc func playbackButtonTapped() {
        animateLocationHistory()
    }

    func animateLocationHistory() {
        guard let locations = locationData, locations.count > 0 else {
            print("No locations to playback")
            return
        }
        
        var index = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if index < locations.count {
                let locationData = locations[index]
                let position = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
                DispatchQueue.main.async {
                    self.mapView.animate(toLocation: position)
                    
                    GeocodingHelper.shared.getAddressFromLatLon(latitude: position.latitude, longitude: position.longitude) { address in
                        self.updateMarker(position: position, address: address ?? "Lat: \(position.latitude), Lon: \(position.longitude)")
                    }
                    print("Animating to location: \(position.latitude), \(position.longitude)")
                }
                index += 1
            } else {
                timer.invalidate()
                print("Playback finished")
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }

    func updateMarker(position: CLLocationCoordinate2D, address: String) {
        if let marker = self.marker {
            marker.position = position
            marker.title = "Location"
            marker.snippet = address
            marker.map = mapView
        } else {
            self.marker = GMSMarker(position: position)
            self.marker?.title = "Location"
            self.marker?.snippet = address
            self.marker?.map = mapView
        }
    }
}

