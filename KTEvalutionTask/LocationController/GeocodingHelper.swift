//
//  GeocodingHelper.swift
//  KTEvalutionTask
//
//  Created by abishek m on 02/07/24.
//

import Foundation
import CoreLocation

class GeocodingHelper {
    static let shared = GeocodingHelper()
    let geocoder = CLGeocoder()
    
    private init() {}
    
    func getAddressFromLatLon(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemarks = placemarks, placemarks.count > 0 {
                let pm = placemarks[0]
                var addressString: String = ""
                
                if let subLocality = pm.subLocality {
                    addressString += "\(subLocality),"
                }
                if let thoroughfare = pm.thoroughfare {
                    addressString += "\(thoroughfare),"
                }
                if let locality = pm.locality {
                    addressString += "\(locality),"
                }
                if let country = pm.country {
                    addressString += "\(country),"
                }
                if let postalCode = pm.postalCode {
                    addressString += "\(postalCode)"
                }
                
                completion(addressString)
            } else {
                completion(nil)
            }
        }
    }
}

