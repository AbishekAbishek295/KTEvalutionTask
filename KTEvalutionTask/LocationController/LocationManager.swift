//
//  LocationManager.swift
//  KTEvalutionTask
//
//  Created by abishek m on 29/06/24.
//
import CoreLocation
import RealmSwift

class LocationManager: NSObject, CLLocationManagerDelegate {
     let locationManager = CLLocationManager()
     var lastSavedTime: Date?
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Locations
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let currentTime = Date()
        if lastSavedTime == nil || currentTime.timeIntervalSince(lastSavedTime!) > 900 { 
            saveLocation(location)
            lastSavedTime = currentTime
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .notDetermined:
               locationManager.requestAlwaysAuthorization()
           case .restricted, .denied:
               print("Location access denied.")
           case .authorizedWhenInUse:
               print("Location access granted for when in use.")
               locationManager.startUpdatingLocation()
           case .authorizedAlways:
               print("Location access granted for always.")
               locationManager.startUpdatingLocation()
           @unknown default:
               fatalError("status: \(status)")
           }
       }
    
     func saveLocation(_ location: CLLocation) {
        let realm = try! Realm()
        let locationData = LocationData()
        locationData.latitude = location.coordinate.latitude
        locationData.longitude = location.coordinate.longitude
        locationData.timestamp = Date()
        
        try! realm.write {
            realm.add(locationData)
        }
    }
}


class LocationData: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var timestamp = Date()
    @objc dynamic var address: String?
    
    
    var coordinate: CLLocationCoordinate2D {
           return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
    
    var title: String? {
          return "My Location"
      }
}
